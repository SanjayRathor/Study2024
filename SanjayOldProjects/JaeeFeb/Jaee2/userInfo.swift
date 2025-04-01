//
//  userInfo.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/28/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation


struct DefaultsKey
{
    static let dateArray = [""]
    static let user_id  = "user_id"
    static let username  = "username"
    static let user_phone  = "user_phone"
    static let isGuest = "guest"
    static let previous = "previous"
    static let code = "code"
    static let lat = "lat"
    static let lng = "lng"
    static let address = "address"
    static let id = "id"
    static let notificationOn = "on"
    static let notificationComing = "coming"
    static let rate = "rate"


    



    
    
}


class UserDataSingleton
{
    static let sharedDataContainer = UserDataSingleton()
    init() {
        let defaults = UserDefaults.standard
        
        self.rate = defaults.object(forKey:DefaultsKey.rate) as? String

        self.notificationComing = defaults.object(forKey:DefaultsKey.notificationComing) as? String
        self.is_guest = defaults.object(forKey:DefaultsKey.isGuest) as? String
        self.notificationOn = defaults.object(forKey:DefaultsKey.notificationOn) as? String
        self.user_id = defaults.object(forKey:DefaultsKey.user_id) as? String
        self.username = defaults.object(forKey:DefaultsKey.username) as? String
        self.user_phone = defaults.object(forKey:DefaultsKey.user_phone) as? String
        self.previous = defaults.object(forKey:DefaultsKey.previous) as? String
        self.code = defaults.object(forKey:DefaultsKey.code) as? String
        self.lat = defaults.object(forKey:DefaultsKey.lat) as? String
        self.lng = defaults.object(forKey:DefaultsKey.lng) as? String
        self.address = defaults.object(forKey:DefaultsKey.address) as? String
        self.id = defaults.object(forKey:DefaultsKey.id) as? String


        
        
    }
    var rate : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(rate, forKey:DefaultsKey.rate)
            
        }
    }
    var notificationComing : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(notificationComing, forKey:DefaultsKey.notificationComing)
            
        }
    }
    var notificationOn : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(notificationOn, forKey:DefaultsKey.notificationOn)
            
        }
    }
    var id : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(id, forKey:DefaultsKey.id)
            
        }
    }
    var address : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(address, forKey:DefaultsKey.address)
            
        }
    }
    var lat : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(lat, forKey:DefaultsKey.lat)
            
        }
    }
    var lng : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(lng, forKey:DefaultsKey.lng)
            
        }
    }
    var is_guest : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(is_guest, forKey:DefaultsKey.isGuest)
            
        }
    }
    var code : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(code, forKey:DefaultsKey.code)
            
        }
    }
    var previous : String?{
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(previous, forKey:DefaultsKey.previous)
            
        }
    }
    
    
    
    var user_id: String? {
        didSet {
            
            let defaults = UserDefaults.standard
            defaults.set(user_id , forKey:DefaultsKey.user_id)
        }
        
        
    }
    
    
    var username: String? {
        didSet {
            
            let defaults = UserDefaults.standard
            defaults.set(username, forKey:DefaultsKey.username)
        }
    }


    var user_phone: String? {
        didSet {
            
            let defaults = UserDefaults.standard
            defaults.set(user_phone, forKey:DefaultsKey.user_phone)
        }
    }
  

 
    
}
