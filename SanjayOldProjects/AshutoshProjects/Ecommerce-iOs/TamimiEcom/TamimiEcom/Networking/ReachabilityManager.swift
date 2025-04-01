//
//  ReachabilityManager.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 08/08/20.
//  Copyright © 2020  . All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager: NSObject {
    
    var reachability:Reachability!
    static let sharedManager : ReachabilityManager = {
        let instance = ReachabilityManager()
        return instance
    }()
    
    func isInternetAvailableForAllNetworks() -> Bool
    {
        if(self.reachability == nil){
            self.doSetupReachability()
            return self.reachability!.isReachable || reachability!.isReachableViaWiFi || self.reachability!.isReachableViaWWAN
        }
        else{
            return reachability!.isReachable || reachability!.isReachableViaWiFi || reachability!.isReachableViaWWAN
        }
    }
    
    func doSetupReachability() {
        
        do{
            let reachability = try Reachability()
            
            self.reachability = reachability
        }
        catch ReachabilityError.failedToCreateWithAddress(_){
            return
        }
        catch{}
        
        reachability.whenReachable = { reachability in
        }
        reachability.whenUnreachable = { reachability in
        }
        do {
            try reachability.startNotifier()
        }
        catch {
        }
    }
    deinit{
        reachability.stopNotifier()
        reachability = nil
    }
    
}
