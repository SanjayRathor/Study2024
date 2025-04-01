//
//  RepositoryManager.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 16/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class RepositoryManager: NSObject {
    static let shared = RepositoryManager()
    override init(){}
    var userProfile:UserInfoModel?
}


extension RepositoryManager {
    
    func saveProfileFor(user:UserInfoModel?) {
        guard let userProfile = user else {
            return
        }
        self.userProfile = userProfile
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.userProfile) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Profile")
        }
    }
    
    func getProfileData() -> UserInfoModel? {
        if let profile  =  userProfile {
            return profile
        }
        
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "Profile") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserInfoModel.self, from: savedPerson) {
                self.userProfile = loadedPerson
                return loadedPerson
            }
        }
        return nil;
    }
    
    
}
