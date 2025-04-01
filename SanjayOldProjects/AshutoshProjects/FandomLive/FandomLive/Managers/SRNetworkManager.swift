//
//  SRNetworkManager.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Connectivity

class SRNetworkManager: NSObject {
    
    fileprivate let connectivity: Connectivity = Connectivity()
    
    private static let _sharedInstance = SRNetworkManager()
    public class func sharedInstance() -> SRNetworkManager {
        return _sharedInstance
    }
    private override init () {
        super.init()
        self.startNetworkMonitor();
    }
}

extension SRNetworkManager {
    
    func startNetworkMonitor() {
        let connectivityChanged: (Connectivity) -> Void = { [weak self] connectivity in
            self?.updateConnectionStatus(connectivity.status)
        }
        
        connectivity.whenConnected = connectivityChanged
        connectivity.whenDisconnected = connectivityChanged
        connectivity.startNotifier()
    }
    
    func stopNetworkMonitor() {
        connectivity.stopNotifier()
    }
    
    func updateConnectionStatus(_ status: Connectivity.Status) {
        switch status {
        case .connected:
            break
        case .connectedViaWiFi:
            break
        case .connectedViaWiFiWithoutInternet:
            break
        case .determining:
            break
        case .notConnected:
            break
        case .connectedViaCellular:
            break
        case .connectedViaCellularWithoutInternet:
            break
            
        }
    }
    
    /*
     Utlity method for getting the network status
     */
    public func isNetworkReachible () -> Bool {
        return true;// self.connectivity.isConnected;
        
    }
}

extension SRNetworkManager {

    enum NetworkError:Error {
        case domainError
        case decodingError
        case badDominError
        case parsingError
    }
    
//    func fetchServiceData<T: Model>(_ urlString: String, completion: @escaping(Result)-> ()) {
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, resp, err) in
//            if err != nil {
//                completion(.failure(.badDominError))
//                return
//            }
//            do {
//                let courses = try JSONDecoder().decode(T.self, from: data!)
//                completion(.success(courses))
//
//            } catch _ {
//                completion(.failure(.parsingError))
//            }
//
//
//        }.resume()
//    }
}

/*
 fetchCoursesJSONWithResult { (res) in
 switch res {
 case .success(let courses):
 courses.forEach({ (course) in
 print(course.name)
 })
 case .failure(let err):
 print("Failed to fetch courses:", err)
 }
 }
 */
