//
//  PostViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 21/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Photos

class PostViewController: SRBaseViewController {
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var textView: RSKGrowingTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var replyToLabel: UILabel!
    var attachedImage: UIImage = UIImage.init();
    
    var userId = ""
    var topicId:String = ""
    var commentId:String = ""
    
    public var didPostedCommentCallback:((Bool)->())?
    let imagePicker = UIImagePickerController()
    
    var commentsForAll:Bool = true
    var isReplayComment:Bool = false
    
    var replyPersion:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Post"
        let closeButton = UIButton(type: .custom)
        closeButton.setTitle("Dismiss", for: .normal)
        let barButton =  UIBarButtonItem(customView: closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonDidClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = barButton
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            self.userId = profileInfo.userId;
            
            if commentsForAll {
                replyToLabel.text = ""
                headerTitle.text = "Commenting publicly as \(profileInfo.name)"
            } else {
                replyToLabel.text = replyPersion
                headerTitle.text = ""
            }
            
        } else {
            headerTitle.text = ""
            replyToLabel.text = ""
        }
        
        
        textView.delegate = self
        sendButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    @objc func closeButtonDidClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostViewController:RSKGrowingTextViewDelegate, UITextViewDelegate {
    
    @IBAction func attachmentDidClicked(_ sender: Any) {
        ImagePickerClicked()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.isEmpty) {
            sendButton.isEnabled = false
        }
        else {
            sendButton.isEnabled = true
            sendButton.isSelected = true
        }
    }
    
    @IBAction func sendButtonDidClicked(_ sender: Any) {
        
        textView.resignFirstResponder()
        if (textView.text.isEmpty) {
            return
            
        }
        self.presentCustomActivity()
    
        var userInfo:[String:Any] = ["userId": userId, "topicId" : topicId, "comment": textView.text ?? "", "commentId": commentId]

        var  postImageData:Data = Data.init()
        if let imageData =  self.attachedImage.jpegData(compressionQuality: 0.8) {
            postImageData = imageData
        }
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performMultiFormRequest(requestURL: self.isReplayComment ? API.threadcommentReplyURL : API.postthreadCommentsURL, postData: userInfo, imagesData:postImageData ) { (result) -> Void in
            switch (result) {
            case .success( _):
                self.dismissCustomActivity()
                self.textView.text = "";
                self.didPostedCommentCallback?(true)
                self.dismiss(animated: true, completion: nil)
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.showToastMessage(error)
                break;
            }
        }
    }
}


extension PostViewController :UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func ImagePickerClicked() {
        
        let alert: UIAlertController = UIAlertController(title: "ChooseImage",
                                                         message: nil,
                                                         preferredStyle: UIAlertController.Style.actionSheet)
        let gallaryAction = UIAlertAction(title: "Gallery",
                                          style: UIAlertAction.Style.default) {
                                            UIAlertAction in
                                            self.openGallary()
        }
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: UIAlertAction.Style.default) {
                                            UIAlertAction in
                                            self.takePhoto()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.cancel) {
                                            UIAlertAction in
        }
        
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        self.present(alert, animated: true) {
            
        }
    }
    
    //Uploading image from the Gallery or choose from the Camera
    func takePhoto() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openGallary() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.present(self.imagePicker, animated: true, completion: nil)
            case .restricted:
                self.present(self.imagePicker, animated: true, completion: nil)
            case .denied:
                self.present(self.imagePicker, animated: true, completion: nil)
            default:
                
                break
            }
        }
    }
    
    //MARK: Image PickerView Delegates
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        imagePicker .dismiss(animated: true, completion: nil)
        self.attachedImage =  self.compressImage(image: (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

