//
//  CommentsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 20/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit


fileprivate let kCommentsIdentifier = "CommentsTableViewCell"

class CommentsViewController: SRBaseViewController {
    var forumsModels:FLReplayModel? = nil
    var comments:[Replies] = []
    var userId = ""
    
    public var didCloseClicked:(()->())?
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var repliesLabel: UILabel!
    
    var commentID:String = ""
    var topicId = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init()
        self.commentsView .castShadow(withPosition: SCShadowEdgeBottom)
        tableView.register(UINib.init(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: kCommentsIdentifier)
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            self.userId = profileInfo.userId;
        }
        self.hideKeyboardWhenTappedAround()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func closeButtonDidClicked(_ sender: Any) {
        didCloseClicked?();
        tableView.alpha = 0
        comments.removeAll()
        self.tableView.reloadData()
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCommentsIdentifier) as! CommentsTableViewCell
        cell.configReplies(forCell: comments[indexPath.row])
        cell.didReplayClickedCallback = { (comment: Replies) in
            self.configureReplay(comment: comment)
        }
        return cell
    }
}

extension CommentsViewController {
    func getRepliesFor( commentId:String, for topic:String ) {
        tableView.alpha = 1
        self.topicId = topic
        self.commentID = commentId
        
        self.presentCustomActivity()
        var userInfo:[String:Any] = ["userId": userId, "topicId" : topic, "commentId": commentID]
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getThreardRepliesURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.forumsModels = try? JSONDecoder().decode(FLReplayModel.self, from: json as! Data)
                
                if let interests = self.forumsModels?.result {
                    self.comments.removeAll()
                    self.comments += interests
                    
                    self.repliesLabel.text = "Replies \(self.comments.count)"
                    self.tableView.reloadData()
                } else {
                    self.dismissCustomActivity()
                    self.tableView .setNoDataPlaceholder(AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.tableView.setNoDataPlaceholder(error)
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
}

extension CommentsViewController {
    
    func configureReplay(comment: Replies) {
        commentID = "\(comment.commentID)"
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        viewController.topicId = topicId
        viewController.commentsForAll = false
        viewController.commentId = commentID
        viewController.isReplayComment = true
        viewController.replyPersion = "@\(comment.userName)"
        
        let navigationController =  UINavigationController.init(rootViewController: viewController)
        
        self.present(navigationController, animated: true, completion: nil)
        viewController.didPostedCommentCallback = { (status) in
            self.getRepliesFor(commentId: self.commentID, for: self.topicId)
        }
    }
}

