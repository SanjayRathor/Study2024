//
//  ApplicationStates.swift


import UIKit



class ApplicationStates: NSObject {
    
    static func isUserLoggedIn() -> Bool {
        if let userDetails = UserDefaults.standard.value(forKey: "user") as? [String:Any]{
            let userId = userDetails["_id"] as? String ?? ""
            if !userId.isEmpty {
                return true;
            }
        }
        return false
    }
    
    static func setUserData(Info:[String:Any]) -> Void {
        UserDefaults.standard.set(Info, forKey:"user")
        UserDefaults.standard.synchronize()
    }
    static func setUserSid(sid:String) -> Void {
        UserDefaults.standard.set(sid, forKey:"sid")
        UserDefaults.standard.synchronize()
    }
    static func getUserSid() -> String {
        if let sid = UserDefaults.standard.value(forKey: "sid") as? String{
            return sid
        }
        return ""
    }
    static func setLoyaltyUserId(loyaltyUserId:String) -> Void {
        UserDefaults.standard.set(loyaltyUserId, forKey:"loyaltyUserId")
        UserDefaults.standard.synchronize()
    }
    static func getLoyaltyUserId() -> String {
        if let loyaltyUserId = UserDefaults.standard.value(forKey: "loyaltyUserId") as? String{
            return loyaltyUserId
        }
        return ""
    }
    
    static func setRemberMobAndPassword(info:[String:String]) -> Void {
           UserDefaults.standard.set(info["rMob"], forKey:"rMob")
        UserDefaults.standard.set(info["rPassword"], forKey:"rPassword")
           UserDefaults.standard.synchronize()
       }
    static func getRMob() -> String {
        if let rEmail = UserDefaults.standard.value(forKey: "rMob") as? String{
            return rEmail
        }
        return ""
    }
    static func getRPassword() -> String {
           if let rPassword = UserDefaults.standard.value(forKey: "rPassword") as? String{
               return rPassword
           }
           return ""
       }
    static func removeUserData() -> Void {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "locationId")
        UserDefaults.standard.removeObject(forKey: "locationName")
        UserDefaults.standard.removeObject(forKey: "locationAddress")
        UserDefaults.standard.removeObject(forKey: "sid")
        UserDefaults.standard.removeObject(forKey: "loyaltyUserId")

    }
    
    static func getUserData() -> [String:Any]? {
        return UserDefaults.standard.dictionary(forKey: "user")
    }
    static func getUserID() -> String {
        if let userDetails = UserDefaults.standard.value(forKey: "user") as? [String:Any]{
            let userId = userDetails["id"] as? String ?? ""
            return userId
        }
        return ""
    }
    static func saveOrderNumber(Info:String) -> Void {
        UserDefaults.standard.set(Info, forKey:"orderNumber")
        UserDefaults.standard.synchronize()
    }
    static func getOrderNumber() -> String {
        if let orderNumber = UserDefaults.standard.value(forKey: "orderNumber") as? String{
            return orderNumber
        }
        return ""
    }
    static func saveOrderId(Info:String) -> Void {
        UserDefaults.standard.set(Info, forKey:"orderId")
        UserDefaults.standard.synchronize()
    }
    static func getOrderId() -> String {
        if let orderNumber = UserDefaults.standard.value(forKey: "orderId") as? String{
            return orderNumber
        }
        return ""
    }
    static func removeOrderInformation() -> Void {
        UserDefaults.standard.set("", forKey:"orderId")
        UserDefaults.standard.set("", forKey:"orderNumber")
        UserDefaults.standard.set("0", forKey:"cartBudge")
        UserDefaults.standard.synchronize()
        let userInfo = ["type":3]
        NotificationCenter.default.post(name: Notification.Name("cartBudgeUpdate"), object: nil, userInfo:userInfo)
    }
    
    
    static func saveCartBudge(Info:String) -> Void {
        UserDefaults.standard.set(Info, forKey:"cartBudge")
        UserDefaults.standard.synchronize()
    }
    static func getCartBudge() -> String {
        if let cartBudgeNumber = UserDefaults.standard.value(forKey: "cartBudge") as? String{
            return cartBudgeNumber
        }
        return "0"
    }
    
    static func saveLocationInformation(locationId:String,locationName:String,locationAddress:String)  {
        UserDefaults.standard.set(locationId,forKey: "locationId")
        UserDefaults.standard.set(locationName,forKey: "locationName")
        UserDefaults.standard.set(locationAddress,forKey: "locationAddress")
        UserDefaults.standard.synchronize()
    }
    static func getLocationInformation() -> [String:String]  {
        if let locationId = UserDefaults.standard.value(forKey: "locationId") as? String{
            let dict = ["locationId":locationId,"locationName":UserDefaults.standard.value(forKey: "locationName") as! String ,"locationAddress":UserDefaults.standard.value(forKey: "locationName") as! String ]
            return dict
            
        }
        return [:]
    }
    static func getLocationSelctedID() -> String  {
        if let locationId = UserDefaults.standard.value(forKey: "locationId") as? String{
            return locationId
        }
        return ""
    }
    static func getUniqId() -> String {
         let userID :String = self.getUserID()
            if userID != "" {
                return  ""
            }
        if let uuidSting = UIDevice.current.identifierForVendor?.uuidString {
        return uuidSting
        }
        return ""
    }
    static func getUniqIdForOrder() -> String {
        if let uuidSting = UIDevice.current.identifierForVendor?.uuidString {
        return uuidSting
        }
        return ""
    }
}
