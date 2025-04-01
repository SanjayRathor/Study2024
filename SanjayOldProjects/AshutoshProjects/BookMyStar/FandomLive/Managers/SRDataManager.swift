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
    
    public func performMultiFormRequest(requestURL: String, postData:Parameters, imageData:UIImage?, completionHandler: @escaping JSONCompletionHandler) {
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if let image = imageData {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(imageData, withName: "photo")
                    }
                }
                
                for (key, value) in postData {
                    
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    
                }
                
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON {response in
                        switch(response.result){
                        case let .success(value):
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
                completionHandler(NetworkResponse.success(value as AnyObject))
            case .failure:
                let error: Error = response.result.error!
                completionHandler(NetworkResponse.failure(error.localizedDescription))
            }
        })
    }
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
}
