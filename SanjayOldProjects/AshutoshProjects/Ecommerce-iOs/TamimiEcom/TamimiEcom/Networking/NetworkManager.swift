//
//  NetworkManager.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 08/08/20.
//  Copyright © 2020  . All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

public enum NetworkResponseStatus {
    case success
    case error(string: String?)
}

public class NetworkManager {
    public var baseImageURL: String = "http://134.209.153.34:5000/"
    public var baseURL: String = "http://134.209.153.34:5000/v1/"
    public static let shared: NetworkManager = NetworkManager()
    private init () {
        
    }
}

extension NetworkManager {
    
    func getJSONResponse(path: String,isLoader :Bool, completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
        var requestPath = ""
        if path.contains("?") {
            requestPath = baseURL + path + "&deviceId=\(ApplicationStates.getUniqId())"
        }else {
            requestPath = baseURL + path + "?deviceId=\(ApplicationStates.getUniqId())"
        }
        let userId =   ApplicationStates.getUserID()
        
        if !userId.isEmpty {
            requestPath = requestPath + "&userId=\(userId)"
        }
        print(requestPath)
        if isLoader {
            SVProgressHUD.show()
        }
        print(requestPath)
//        AF.sessionConfiguration.timeoutIntervalForRequest  = 180;
        AF.request(requestPath).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    completionHandler(json, .success)
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            case .failure(let error):
                completionHandler(nil, .error(string: error.localizedDescription))
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    func postJSONResponse(path: String, parameters: [String:Any]?,isLoder:Bool = true, isHeader:Bool = false,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
        let requestPath = baseURL + path
        if isLoder {
            SVProgressHUD.show()
        }
        print(requestPath)
        var updateParams = parameters
        let userId =   ApplicationStates.getUserID()
        if !userId.isEmpty {
            updateParams?["userId"] = userId
        }
        if path == "core/add-order" || path == "core/edit-order" {
            updateParams?["deviceId"] = ApplicationStates.getUniqIdForOrder()

        }else {
        updateParams?["deviceId"] = ApplicationStates.getUniqId()
        }
       
        let headerValue: HTTPHeaders = ["sid":ApplicationStates.getUserSid(),"userId":ApplicationStates.getLoyaltyUserId()]
        
        print(requestPath)
        print(updateParams)
        AF.request(requestPath,method: .post,parameters: updateParams,headers: isHeader ? headerValue : nil).responseJSON { response in
            switch response.result {
            case .success(let value):
               // print(value)
                if let json = value as? [String: Any] {
                    completionHandler(json, .success)
                }
            case .failure(let error):
                completionHandler(nil, .error(string: error.localizedDescription))
            }
            DispatchQueue.main.async {
                if isLoder {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    func getJSONResponse(path: String, parameters: [String:Any]?, isHeader:Bool = false,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
        let requestPath = baseURL + path
        SVProgressHUD.show()
        var updateParams = parameters
        updateParams?["deviceId"] = ApplicationStates.getUniqId()
        let userId =   ApplicationStates.getUserID()
        if !userId.isEmpty {
            updateParams?["userId"] = userId
        }
//        AF.sessionConfiguration.timeoutIntervalForRequest  = 180;
        
        let headerValue: HTTPHeaders = ["sid":ApplicationStates.getUserSid(),"userId":ApplicationStates.getLoyaltyUserId()]
        
        AF.request(requestPath,method: .get,parameters: updateParams, headers: isHeader ? headerValue : nil).responseJSON { response in
         
            print(response.request)
            print(headerValue)

            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    completionHandler(json, .success)
                }
            case .failure(let error):
                completionHandler(nil, .error(string: error.localizedDescription))
            }
        }
        
    }
}

