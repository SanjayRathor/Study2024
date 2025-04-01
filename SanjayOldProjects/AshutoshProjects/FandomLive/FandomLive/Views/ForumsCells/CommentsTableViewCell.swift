//
//  CommentsTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 21/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    public var didClickedCallback: ((Comments)->())?
    public var didReplyToClickedCallback: ((Comments)->())?
    
    public var didReplayClickedCallback: ((Replies)->())?
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var viewRepliesButton: UIButton!
    
    @IBOutlet weak var uploadImageView: UIImageView!
    var comment:Comments!
    var reply:Replies!
    var isCommentTypeCell = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configComments(forCell comment:Comments) {
        self.comment = comment
        
        isCommentTypeCell = true
        titleLabel.text = comment.userName
        descLabel.text = comment.comment
        let url = URL(string: (comment.image))
        placeHolderImage.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
        
        likeButton.setTitle("\(comment.totalLike) Like", for: .normal)
        replayButton.setTitle("\(comment.totalReply) Replies", for: .normal)
        viewRepliesButton.isHidden = false
        if comment.totalReply == 0 {
            viewRepliesButton.isHidden = true
        }
        
         if let commentImage = comment.commentImage {
            
            let _commentImage = commentImage.replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string:_commentImage)
            uploadImageView.kf.setImage(with: url2, placeholder:nil)
        }
    }
    
    func configReplies(forCell comment:Replies) {
        self.reply = comment
        isCommentTypeCell = false
        titleLabel.text = comment.userName
        descLabel.text = comment.comment
        let url = URL(string: (comment.image))
        placeHolderImage.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
        likeButton.setTitle("\(comment.totalLike) Like", for: .normal)
        replayButton.setTitle("Reply", for: .normal)
        viewRepliesButton.isHidden = true
        
        if let replyImage1 = comment.replyImage {
            let _commentImage = replyImage1.replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string:_commentImage)
            uploadImageView.kf.setImage(with: url2, placeholder:nil)
        }
        
}
    
    
    
    @IBAction func likeButtonDidClicked(_ sender: Any) {
        if isCommentTypeCell {
            likeComment()
        } else {
            likeReplay()
        }
        
    }
    
    @IBAction func viewRepliesButtonDidClicked(_ sender: Any) {
        didClickedCallback?(comment)
    }
    
    @IBAction func replayDidClicked(_ sender: Any) {
        if isCommentTypeCell {
            didReplyToClickedCallback?(comment)
        } else {
            didReplayClickedCallback?(reply)
        }
    }
}

extension CommentsTableViewCell {
    
    func likeComment () {
        
        if (self.comment.isLike == 1) {
            SRUtilities.showToastMessage(AlertMessages.LikedErrorMsg)
        } else {
            if (!SRNetworkManager.sharedInstance().isNetworkReachible()) {
                SRUtilities.showToastMessage(AlertMessages.NetworkErrorMsg)
                return
            }
            if(!SRApplicationStates.isUserLoggedIn()){
                AppCoordinator.promptUserForSignIn()
                return
            }
            
            comment.totalLike += 1;
            likeButton.setTitle("\(comment.totalLike) Like", for: .normal)
            self.comment.isLike = 1
            SRDataManager.sharedInstance().commentsLikeCliked(topicId: "\(comment.topicID)",
                commentId: "\(comment.commentID)", replyId: "", flag: "0")
        }
        
    }
    
    func likeReplay () {
        
        if (self.reply.isLike == 1) {
            SRUtilities.showToastMessage(AlertMessages.LikedErrorMsg)
        } else {
            if (!SRNetworkManager.sharedInstance().isNetworkReachible()) {
                SRUtilities.showToastMessage(AlertMessages.NetworkErrorMsg)
                return
            }
            if(!SRApplicationStates.isUserLoggedIn()){
                AppCoordinator.promptUserForSignIn()
                return
            }
            
            reply.totalLike += 1;
            likeButton.setTitle("\(reply.totalLike) Like", for: .normal)
            self.reply.isLike = 1
            SRDataManager.sharedInstance().commentsLikeCliked(topicId: "\(reply.commentID)",
                commentId: "\(reply.commentID)", replyId:"\(reply.replyID)", flag: "1")
        }
    }
}
