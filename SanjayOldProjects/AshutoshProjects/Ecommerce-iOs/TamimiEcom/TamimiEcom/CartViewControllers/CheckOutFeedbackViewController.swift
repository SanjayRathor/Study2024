//
//  CheckOutFeedbackViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 10/09/20.
//

import UIKit

class CheckOutFeedbackViewController: UIViewController {
    var orderId : String = ""
    
    @IBOutlet weak var asf: UILabel!
    
    @IBOutlet weak var ttf: UILabel!
    @IBOutlet weak var info1: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setOrderNumber()
        // Do any additional setup after loading the view.
    }
    func setOrderNumber () {
        let orderNumber = ApplicationStates.getOrderNumber()
        let attributedString = NSMutableAttributedString(string: "Your order \(orderNumber) will be picked soon and you will be \nnotified when it will be ready for delivery. Please rest assured \nthat you are our top priority and our team will select the best \nquality for your satisfaction.", attributes: [
            .font: UIFont(name: "SegoeUI", size: 12.0)!,
            .foregroundColor: UIColor(red: 106.0 / 255.0, green: 109.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttributes([
            .font: UIFont(name: "SegoeUI", size: 14.0)!,
            .foregroundColor: UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 11, length: orderNumber.count))
        self.orderLbl.attributedText = attributedString
        self.infoTask()
    }
    func infoTask() {
        let attributedString = NSMutableAttributedString(string: "From our home to yours!\nYou can track your order here:\nhttps://www.shop.tamimimarkets.com/orders", attributes: [
            .font: UIFont(name: "SegoeUI", size: 12.0)!,
            .foregroundColor: UIColor(red: 68.0 / 255.0, green: 87.0 / 255.0, blue: 1.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: 24))
        attributedString.addAttribute(.foregroundColor, value: UIColor(white: 112.0 / 255.0, alpha: 1.0), range: NSRange(location: 24, length: 31))
        self.info1.attributedText = attributedString
        self.asfValue()
    }
    func asfValue(){
        let attributedString = NSMutableAttributedString(string: "Login to Tamimi Rewards Program \nto redeem your savings!", attributes: [
            .font: UIFont(name: "SegoeUI", size: 13.0)!,
            .foregroundColor: UIColor(red: 106.0 / 255.0, green: 109.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), range: NSRange(location: 0, length: 5))
        attributedString.addAttribute(.font, value: UIFont(name: "SegoeUI-Bold", size: 13.0)!, range: NSRange(location: 9, length: 24))
        asf.attributedText = attributedString
        self.ttfValues()
    }
    func ttfValues() {
        let attributedString = NSMutableAttributedString(string: "Your Feedback matters!\nPlease share your shopping experience", attributes: [
            .font: UIFont(name: "SegoeUI", size: 12.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: 23))
        ttf.attributedText = attributedString
    }
    @IBAction func leftMenuAction(_ sender: Any) {
        self.backAction()
    }
    func backAction(){
        self.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 0
        ApplicationStates.removeOrderInformation()
        NotificationCenter.default.post(name: Notification.Name("orderComplete"), object: nil, userInfo:nil)

//        PresentingCoordinator.shared().loginSucessAndPageRefersh()

    }
    @IBAction func submitFeedback(_ sender: Any) {
        if let btn : UIButton = sender as? UIButton {
            self.saveFeedBack(vale: String(btn.tag))
        }
    }
    
    @IBAction func trackOrderClick(_ sender: Any) {
        if let url = URL(string: "https://www.shop.tamimimarkets.com/orders") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func tamilRewardsAction(_ sender: Any) {
        if let url = URL(string: "https://tamimimarkets.com/members/") {
            UIApplication.shared.open(url)
        }
    }
}
extension CheckOutFeedbackViewController {
    func saveFeedBack(vale:String) {
        let params : [String : String] = ["orderId":ApplicationStates.getOrderId() ,"feedback":vale]
        NetworkManager.shared.postJSONResponse(path: Constants.provideFeedback, parameters: params) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            alert(Constants.appName, message: "Feedback saved sucessfully!", view: UIApplication.shared.keyWindow?.rootViewController ?? self)
                            self.backAction();
                        }
                    }
                }
                
            case .error(let error):
                print(error!)
            }
            
        }
    }
}
