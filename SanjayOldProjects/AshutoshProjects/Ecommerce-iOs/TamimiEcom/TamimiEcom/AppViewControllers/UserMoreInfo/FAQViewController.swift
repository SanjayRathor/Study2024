//
//  FAQViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 20/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
class FAQCell:UITableViewCell {
    
    @IBOutlet weak var lblInfo: UILabel!
}
class FAQViewController: UIViewController {
    var itemArray :NSMutableArray!
    
    @IBOutlet weak var ansPopUp: UIView!
    @IBOutlet weak var btnPopU: UIButton!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblsQuestion: UILabel!
    @IBOutlet weak var hs: NSLayoutConstraint!
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemArray = NSMutableArray.init()
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.btnPopU.isHidden = true
        self.ansPopUp.isHidden = true
        self.getAllFQA()
        // Do any additional setup after loading the view.
    }
    func getAllFQA() {
        let  requestPath =  Constants.listFaq
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:true) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            self.itemArray.removeAllObjects()
                            if let data = valueData["data"]  as? NSArray {
                                self.itemArray.addObjects(from: data as! [Any])
                            }
                            self.tbView.reloadData()
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hidePopup(_ sender: Any) {
        self.btnPopU.isHidden = true
        self.ansPopUp.isHidden = true

    }
}
extension FAQViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 10
   }
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 10))
       hv.backgroundColor = UIColor.clear
       return hv
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FAQCell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQCell
        if let dict = self.itemArray[indexPath.row] as? NSDictionary {
            cell.lblInfo.text = dict["question"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = self.itemArray[indexPath.row] as? NSDictionary {
        self.getTheDynamicAnswer(info: dict)
        }
    }
    func getTheDynamicAnswer(info:NSDictionary) {
        if let answer = info["answer"] as? String {
            
            if let question = info["question"] as? String {
            self.lblsQuestion.text = question
        }
            self.lblAnswer.text = answer
        self.btnPopU.isHidden = false
        self.ansPopUp.isHidden = false
        print(self.lblAnswer.text?.height(constraintedWidth: self.lblAnswer.frame.size.width, font: self.lblAnswer.font) ?? 0)
        var hsValue = self.lblAnswer.text?.height(constraintedWidth: self.lblAnswer.frame.size.width, font: self.lblAnswer.font) ?? 50
        if hsValue >  (self.view.frame.size.height - 250) {
            hsValue = self.view.frame.size.height - 250
        }
        
            self.hs.constant = 70  + hsValue

        
    }
    }
}
extension String {
func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = self
    label.font = font
    label.sizeToFit()

    return label.frame.height
 }
}
