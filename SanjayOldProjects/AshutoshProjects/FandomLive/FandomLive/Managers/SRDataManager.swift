//
//  DataManager.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 01/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Alamofire
import Foundation


public typealias Parameters = [String: Any]
typealias JSONCompletionHandler = (NetworkResponse) -> Void
typealias JSONDictionary = [String:Any]

enum NetworkResponse {
    case success(AnyObject?)
    case failure(String)
}

class SRDataManager: NSObject {
    
    private static let _sharedInstance = SRDataManager()
    public class func sharedInstance() -> SRDataManager {
        return _sharedInstance
    }
    private override init () {
        super.init()
    }
}

extension SRDataManager {
    
    public func performMultiFormRequest(requestURL: String, postData:Parameters, imagesData:Data, completionHandler: @escaping JSONCompletionHandler) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if !imagesData.isEmpty {
                multipartFormData.append(imagesData, withName: "commentImage", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: postData,
                options: []) {
                multipartFormData.append(theJSONData , withName: "data")
            }
        },
                         to: requestURL,
                         method: .post,
                         encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.responseData {response in
                                    switch(response.result){
                                    case let .success(value):
                                        
                                        let datastring = NSString(data: value, encoding: String.Encoding.utf8.rawValue)
                                        print("URL => \(requestURL)")
                                        print("\n URL RESPONSE => \(String(describing: datastring))")
                                        
                                        completionHandler(NetworkResponse.success(value as AnyObject))
                                    case .failure:
                                        let error: Error = response.result.error!
                                        completionHandler(NetworkResponse.failure(error.localizedDescription))
                                    }
                                }
                                
                            case .failure(let encodingError):
                                completionHandler(NetworkResponse.failure(encodingError.localizedDescription))
                            }
                            
        })
        
    }
    
    
    public func performNetworkServiceRequest(requestURL: String, postData:Parameters,  completionHandler: @escaping JSONCompletionHandler) {
        
        Alamofire.request(requestURL, method: .post, parameters:postData, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            
            switch(response.result){
            case let .success(value):
                completionHandler(NetworkResponse.success(value as AnyObject))
            case .failure:
                let error: Error = response.result.error!
                completionHandler(NetworkResponse.failure(error.localizedDescription))
            }
        })
    }
    
    public func performNetworkGETServiceRequest(requestURL: String, completionHandler: @escaping JSONCompletionHandler) {
        
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            
            switch(response.result){
            case let .success(value):
                completionHandler(NetworkResponse.success(value as AnyObject))
            case .failure:
                let error: Error = response.result.error!
                completionHandler(NetworkResponse.failure(error.localizedDescription))
            }
        })
    }
    
    public func performNetworkGETServiceRequestWithData(requestURL: String, completionHandler: @escaping JSONCompletionHandler) {
        
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300).responseData(completionHandler: { response in
            
            switch(response.result){
            case let .success(value):
                
                let datastring = NSString(data: value, encoding: String.Encoding.utf8.rawValue)
                print("URL => \(requestURL)")
                print("\n URL RESPONSE => \(String(describing: datastring))")
                
                completionHandler(NetworkResponse.success(value as AnyObject))
            case .failure:
                let error: Error = response.result.error!
                completionHandler(NetworkResponse.failure(error.localizedDescription))
            }
        })
    }
    
    
    public func performNetworkCodablePostRequest(requestURL: String, postData:Parameters, completionHandler: @escaping JSONCompletionHandler) {
        
        Alamofire.request(requestURL, method: .post, parameters:postData, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300).responseData(completionHandler: { response in
            
            switch(response.result){
            case let .success(value):
                
                let datastring = NSString(data: value, encoding: String.Encoding.utf8.rawValue)
                print("URL => \(requestURL)")
                print("\nURL RESPONSE => \(String(describing: datastring))")
                
                
                completionHandler(NetworkResponse.success(value as AnyObject))
            case .failure:
                let error: Error = response.result.error!
                completionHandler(NetworkResponse.failure(error.localizedDescription))
            }
        })
    }
    
    
    /* public func performUploadCodablePostRequest(requestURL: String, postData:Parameters, postImage:UIImage?, completionHandler: @escaping JSONCompletionHandler) {
     
     var imgDataData:Data = Data.init()
     if let imageData = postImage {
     imgDataData = imageData.jpegData(compressionQuality: 0.9)!
     }
     
     
     Alamofire.upload(multipartFormData: { multipartFormData in
     multipartFormData.append(imgDataData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
     for (key, value) in postData {
     multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8), withName: key)
     } //Optional for extra parameters
     },
     to:"mysite/upload.php")
     { (result) in
     switch result {
     case .success(let upload, _, _):
     
     upload.uploadProgress(closure: { (progress) in
     print("Upload Progress: \(progress.fractionCompleted)")
     })
     
     upload.responseJSON { response in
     print(response.result.value)
     }
     
     case .failure(let encodingError):
     print(encodingError)
     }
     }
     
     
     
     
     
     
     Alamofire.request(requestURL, method: .post, parameters:postData, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300).responseData(completionHandler: { response in
     
     switch(response.result){
     case let .success(value):
     
     let datastring = NSString(data: value, encoding: String.Encoding.utf8.rawValue)
     print("URL => \(requestURL)")
     print("\nURL RESPONSE => \(String(describing: datastring))")
     
     
     completionHandler(NetworkResponse.success(value as AnyObject))
     case .failure:
     let error: Error = response.result.error!
     completionHandler(NetworkResponse.failure(error.localizedDescription))
     }
     })
     }*/
    
}


extension SRDataManager {
    
    func likedClicked(isLiked:String, for campaignId:String ) {
        
        var userId:String = ""
        if let profileInfo =   RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
        }
        
        var userInfo:[String:Any] = [
            "UserId": userId,
            "CampaignId": campaignId
        ]
        
        if isLiked == "1" {
            userInfo.updateValue("L", forKey: "Flag")
        } else {
            userInfo.updateValue("D", forKey: "Flag")
        }
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.likeCampaignURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success( _):
                break
            case .failure( _):
                
                break;
            }
        }
    }
    
    func likedRewardClicked(isLiked:String, for campaignId:String ) {
        
        var userId:String = ""
        if let profileInfo =   RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
        }
        
        var userInfo:[String:Any] = [
            "UserId": userId,
            "CampaignId": campaignId
        ]
        
        if isLiked == "1" {
            userInfo.updateValue("L", forKey: "Flag")
        } else {
            userInfo.updateValue("D", forKey: "Flag")
        }
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.likeRewardCampaignURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success( _):
                break
            case .failure( _):
                
                break;
            }
        }
    }
    
    func likeSecurityCampaignClicked(isLiked:String, for campaignId:String ) {
        
        var userId:String = ""
        if let profileInfo =   RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
        }
        
        var userInfo:[String:Any] = [
            "UserId": userId,
            "CampaignId": campaignId
        ]
        
        if isLiked == "1" {
            userInfo.updateValue("L", forKey: "Flag")
        } else {
            userInfo.updateValue("D", forKey: "Flag")
        }
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.likeSecurityCampaignURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success( _):
                break
            case .failure( _):
                
                break;
            }
        }
    }
    
    
}

extension SRDataManager {
    
    func commentsLikeCliked(topicId:String, commentId:String, replyId:String, flag:String) {
        
        var userId:String = ""
        if let profileInfo =   RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
        }
        
        var userInfo:[String:Any] = [
            "userId": userId,
            "topicId": topicId,
            "commentId": commentId,
            "replyId" : replyId,
            "flag" : flag
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.getCommentsLikeURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success( _):
                break
            case .failure( _):
                
                break;
            }
        }
    }
}
