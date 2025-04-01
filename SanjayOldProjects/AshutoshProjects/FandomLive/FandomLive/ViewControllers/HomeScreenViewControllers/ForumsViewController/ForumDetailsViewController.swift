//
//  ForumDetailsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 19/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class ForumDetailsViewController: SRBaseViewController {
    
    fileprivate let kCommentsIdentifier = "CommentsTableViewCell"
    @IBOutlet weak var imageHightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commnetsShadowView: UIView!
    @IBOutlet weak var forumImage: UIImageView!
    
    var forumsModels:FLCommentsModel? = nil
    var comments:[Comments] = []
    var forum:ForumItem? = nil
    var userId = ""
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    weak var repliesViewController:CommentsViewController? = nil
    @IBOutlet weak var commentsView: UIView!
    var hideHeader = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title =  forum?.topicName {
            self.navigationItem.title = title
        } else {
            self.navigationItem.title = "Forum"
        }
        
        ///let totalLiked = forum?.totalLike ?? 0
        tableView.tableFooterView = UIView.init()
        self.commnetsShadowView .castShadow(withPosition: SCShadowEdgeBottom)
        tableView.register(UINib.init(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: kCommentsIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        refreshData()
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            self.userId = profileInfo.userId;
            self.getComments(userId: userId)
        }
        
        commentsView.isHidden = true
        self.hideKeyboardWhenTappedAround()
        
        if hideHeader {
            let newConstraint = imageHightConstraints.constraintWithMultiplier(0.0001)
            view.removeConstraint(imageHightConstraints)
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            imageHightConstraints = newConstraint
            forumImage.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func refreshData() {
        let totalcomments = forum?.totalcomments ?? 0
        commnetsShadowView.castShadow(withPosition: SCShadowEdgeBottom)
        commentsLabel.text = "Comments \(totalcomments)"
        let url = URL(string: (forum?.banner ?? ""))
        forumImage.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentsViewController" {
            self.repliesViewController = segue.destination as? CommentsViewController
            self.repliesViewController?.didCloseClicked = {
                self.hideReplies()
            }
        }
    }
    
    @IBAction func addCommentsDidClicked(_ sender: Any) {
        
        guard let topicId = forum?.topicID else {
            return
        }
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        viewController.topicId = "\(topicId)"

       let navigationController =  UINavigationController.init(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
        viewController.didPostedCommentCallback = { (status) in
            self.getComments(userId: self.userId)
            self.forum?.totalcomments =  (self.forum?.totalcomments ?? 0) + 1
            self.refreshData()
        }
    }
}

extension ForumDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCommentsIdentifier) as! CommentsTableViewCell
        cell.configComments(forCell: comments[indexPath.row])
        cell.didClickedCallback = { [weak self] (comment) in
            self?.showReplies(commentId:"\(comment.commentID)")
        }
        
        cell.didReplyToClickedCallback = { (comment) in
            
            let storyboard = UIStoryboard(storyboard: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
            viewController.topicId = "\(comment.topicID)"
            viewController.commentsForAll = false;
            viewController.replyPersion = "@\(comment.userName)"
            
            let navigationController =  UINavigationController.init(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
            viewController.didPostedCommentCallback = { (status) in
                self.getComments(userId: self.userId)
                self.forum?.totalcomments =  (self.forum?.totalcomments ?? 0) + 1
                self.refreshData()
            }
            
            
        }
        
        return cell
    }
}

extension ForumDetailsViewController {
    
    func getComments(userId:String) {
        self.presentCustomActivity()
        var userInfo:[String:Any] = ["userId": userId, "topicId" : forum?.topicID ?? "0"]
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getThreardCommentsURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.forumsModels = try? JSONDecoder().decode(FLCommentsModel.self, from: json as! Data)
                
                if let interests = self.forumsModels?.result {
                    self.comments.removeAll()
                    self.comments += interests
                    self.tableView.reloadData()
                    if self.hideHeader {
                        self.commentsLabel.text = "Comments \(self.comments.count)"
                    }
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


extension ForumDetailsViewController {
    
    func hideReplies() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.topConstraints.constant = UIScreen.main.bounds.height
            self.view.layoutSubviews()
        }) { (_) in
            
            self.commentsView.isHidden = true
        }
    }
    
    func showReplies (commentId:String) {
        self.topConstraints.constant = UIScreen.main.bounds.height
        self.view.layoutSubviews()
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.commentsView.isHidden = false
            self.topConstraints.constant = 0
            self.view.layoutSubviews()
            
        }) { (_) in
            
            if let topicId = self.forum?.topicID {
                self.repliesViewController?.getRepliesFor(commentId: commentId, for: "\(topicId)")
            }
        }
    }
}

