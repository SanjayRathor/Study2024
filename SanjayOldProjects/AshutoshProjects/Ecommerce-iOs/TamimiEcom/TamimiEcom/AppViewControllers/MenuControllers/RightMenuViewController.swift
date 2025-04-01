//
//  RightMenuViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 23/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit
class footerSubmit: UITableViewCell {
    @IBOutlet weak var submitBtn: UIButton!
    
}
class sortByBrand: UITableViewCell {
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var checkUncheck: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
}
class sortByCategory: UITableViewCell {
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var rowImg: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
}

class sortByTableViewCell: UITableViewCell {
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var rowImg: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
}
protocol ClikInfomartionDelegte : class {
    func clikeInformationSent(info:[String:Any])
}
class RightMenuViewController: UIViewController {
    
    @IBOutlet weak var btnLowest: UIButton!
    @IBOutlet weak var btnHighest: UIButton!
    
    var filterByBrandValues =  NSMutableArray()
    var filterByCategoryValues = NSMutableArray()
    @IBOutlet weak var txtMinPrice: UITextField!
    @IBOutlet weak var txtMaxprice: UITextField!
    @IBOutlet weak var subCatView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var subTitleViiew: UITableView!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var subTitleView: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblHint: UILabel!
    var isShortByShow = true
    var isCategoryShow = true
    var selctedPageId = ""
    var isFromCategary = true
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    let sortByInfo = ["POPULARITY","NEW","PRICE"]
    var isPopularity = false
    var isNew = false
    var isLowestFirst = -1
    var isHighestFirst = false
    var range = ""
    
    var filterByInfo = ["BRAND","CATEGORY"]
    
    var filterByCategory = NSMutableArray()
    var filterByBrand = NSMutableArray()
    weak var delgate:ClikInfomartionDelegte?
    @IBOutlet weak var sortByView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterByBrandValues = NSMutableArray.init()
        txtView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBAction func closeAction(_ sender: Any) {
        self.sideMenuController?.hideRightView(animated: true, completionHandler: nil)
    }
    
    func sortByViewCall() {
        DispatchQueue.main.async {
            if self.isFromCategary {
                self.filterByInfo = ["BRAND","CATEGORY"]
            }else {
                self.filterByInfo = ["CATEGORY"]
            }
            self.priceView.isHidden = true
            self.isShortByShow = true
            self.feedbackView.isHidden = true
            let yourAttributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
            
            let attributeString = NSMutableAttributedString(string: "Reset Sorting",
                                                            attributes: yourAttributes)
            
            self.btnReset.setAttributedTitle(attributeString, for: .normal)
            let rangeInfo  = self.range.components(separatedBy: ":")
            if rangeInfo.count > 1 {
                self.txtMinPrice.text = rangeInfo.first
                self.txtMaxprice.text = rangeInfo.last
            }else {
                self.txtMinPrice.text = "0"
                self.txtMaxprice.text = "0"
                
            }
            self.btnSort.setTitle("SORT BY", for: .normal)
            self.sortByView.isHidden = false
            self.tbView.delegate = self
            self.tbView.dataSource = self
            self.tbView.reloadData()
            self.showSubCatView(isShow: false, isCategory: false)
            
        }
    }
    func filterByCall() {
        DispatchQueue.main.async {
            if self.isFromCategary {
                self.filterByInfo = ["BRAND","CATEGORY"]
            }else {
                self.filterByInfo = ["CATEGORY"]
            }
            
            self.priceView.isHidden = true
            self.isShortByShow = false
            self.feedbackView.isHidden = true
            self.sortByView.isHidden = false
            self.btnSort.setTitle("FILTER BY", for: .normal)
            let yourAttributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
            
            let attributeString = NSMutableAttributedString(string: "Reset Filter",
                                                            attributes: yourAttributes)
            
            self.btnReset.setAttributedTitle(attributeString, for: .normal)
            
            self.tbView.delegate = self
            self.tbView.dataSource = self
            self.tbView.reloadData()
            self.showSubCatView(isShow: false, isCategory: true)
            
        }
    }
    func feedbackViewShow() {
        DispatchQueue.main.async {
            self.priceView.isHidden = true
            self.feedbackView.isHidden = false
            self.sortByView.isHidden = true
            self.showSubCatView(isShow: false, isCategory: false)
            self.txtView.text = ""
            self.lblHint.isHidden = false
        }
    }
    
    @IBAction func feedBackSubMit(_ sender: Any) {
        if let stringFeedback = self.txtView.text {
            if !stringFeedback.isEmpty {
                self.sideMenuController?.hideRightView(animated: true, completionHandler: {
                    self.delgate?.clikeInformationSent(info: ["feedback":self.txtView.text ?? ""])
                })
            }else {
                alert(Constants.appName, message: "Please enter feedback!", view: self)
            }
        }
    }
    
    @IBAction func resetBtnAction(_ sender: Any) {
        self.sideMenuController?.hideRightView(animated: true, completionHandler: {
            if !self.isShortByShow {
                self.filterByCategoryValues.removeAllObjects()
                self.filterByBrand.removeAllObjects()
                self.delgate?.clikeInformationSent(info: ["filterByBrand":self.filterByCategoryValues,"filterByCategory":self.filterByCategoryValues])
            }else {
                self.isPopularity = false
                self.isNew = false
                self.range = ""
                self.delgate?.clikeInformationSent(info: ["price":"","new":"","popular":"","range":""])
            }
        })
    }
}

extension RightMenuViewController:UITableViewDelegate, UITableViewDataSource {
    
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.subTitleViiew {
            if !self.isCategoryShow && self.filterByBrand.count == 0 {
                return 1
            }else if self.isCategoryShow && self.filterByCategory.count == 0{
                return 1
            }
            return 75
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.subTitleViiew {
            
            if !self.isCategoryShow &&  self.filterByBrand.count == 0{
                let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
                hv.backgroundColor = UIColor.clear
                return hv
                
            }
            else if self.isCategoryShow && self.filterByCategory.count == 0{
                let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
                hv.backgroundColor = UIColor.clear
                return hv
                
            }
            if !self.isCategoryShow {
                let cell : footerSubmit = tableView.dequeueReusableCell(withIdentifier: "footerSubmit") as! footerSubmit
                cell.submitBtn.isHidden = false
                return cell
            }else {
                let cell : footerSubmit = tableView.dequeueReusableCell(withIdentifier: "footerSubmit") as! footerSubmit
                cell.submitBtn.isHidden = true
                return cell
            }
        }
        let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
        hv.backgroundColor = UIColor.clear
        return hv
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbView {
            if self.isShortByShow {
                return self.sortByInfo.count
            }else {
                return self.filterByInfo.count
            }
        }else if tableView == self.subTitleViiew {
            if self.isCategoryShow {
                return self.filterByCategory.count
            }else {
                return self.filterByBrand.count
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tbView {
            let cell : sortByTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sortByTableViewCell", for: indexPath) as! sortByTableViewCell
            cell.btnCall.tag = indexPath.row
            if self.isShortByShow {
                cell.infoLbl.text = self.sortByInfo[indexPath.row]
                cell.infoLbl.textColor = UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0)
                
                if isPopularity && indexPath.row == 0 {
                    cell.infoLbl.textColor = UIColor(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }
                if isNew && indexPath.row == 1 {
                    cell.infoLbl.textColor = UIColor(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }
                if indexPath.row == 2 {
                    cell.rowImg.isHidden = false
                }else {
                    cell.rowImg.isHidden = true
                }
            }else {
                cell.infoLbl.text = self.filterByInfo[indexPath.row]
                cell.rowImg.isHidden = false
            }
            return cell
        }else {
            if self.isCategoryShow {
                let cell : sortByCategory = tableView.dequeueReusableCell(withIdentifier: "sortByCategory", for: indexPath) as! sortByCategory
                cell.btnCall.tag = indexPath.row
                if let dict = self.filterByCategory[indexPath.row] as? NSDictionary {
                    cell.infoLbl.textColor = UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0)
                    
                    cell.infoLbl.text = dict["categoryName"] as? String
                    if let _id =  dict["_id"] as? String {
                        if self.filterByCategoryValues.contains(_id)   {
                            cell.infoLbl.textColor = UIColor(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                            
                        }
                    }
                }
                
                cell.rowImg.isHidden = true
                return cell
            }else {
                
                let cell : sortByBrand = tableView.dequeueReusableCell(withIdentifier: "sortByBrand", for: indexPath) as! sortByBrand
                cell.btnCall.tag = indexPath.row
                cell.checkUncheck.image = UIImage(named: "checkbox")
                
                if let dict = self.filterByBrand[indexPath.row] as? NSDictionary {
                    cell.infoLbl.text = dict["name"] as? String
                    if let _id =  dict["_id"] as? String {
                        if self.filterByBrandValues.contains(_id)   {
                            cell.checkUncheck.image = UIImage(named: "chechboxS")
                        }
                    }
                }
                cell.checkUncheck.isHidden = false
                return cell
            }
        }
    }
    
    @IBAction func callBtn(_ sender: Any) {
        if let btn = sender as? UIButton {
            print(btn.tag)
            if !isShortByShow {
                if self.isFromCategary {
                    if btn.tag == 0 {
                        self.isCategoryShow = false
                    }else {
                        self.isCategoryShow = true
                    }
                }else {
                    self.isCategoryShow = true
                }
                self.subTitleViiew.delegate = self
                self.subTitleViiew.dataSource = self
                self.subTitleViiew.reloadData()
                
                self.getCategoryList(isCategory:self.isCategoryShow )
                
                self.showSubCatView(isShow: true, isCategory: self.isCategoryShow)
            }else {
                if btn.tag == 0 || btn.tag == 1 {
                    self.sideMenuController?.hideRightView(animated: true, completionHandler: {
                        if btn.tag == 0 {
                            self.isPopularity = true
                            self.delgate?.clikeInformationSent(info: ["popular":"asc"])
                        }else {
                            self.isNew = true
                            self.delgate?.clikeInformationSent(info: ["new":"asc"])
                        }
                    })
                }else{
                    if self.isLowestFirst == 1 {
                     self.btnHighest.setTitleColor( UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0), for: .normal)
                    self.btnLowest.setTitleColor( UIColor(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0), for: .normal)
                        
                    }else  if self.isLowestFirst == 0 {
                        self.btnLowest.setTitleColor( UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0), for: .normal)
                        self.btnHighest.setTitleColor( UIColor(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0), for: .normal)
                        
                    }else {
                        self.btnLowest.setTitleColor( UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0), for: .normal)
                        self.btnHighest.setTitleColor( UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0), for: .normal)
                        
                    }
                    self.priceView.isHidden = false
                }
            }
        }
    }
    
}
extension RightMenuViewController:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars == 0 {
            self.lblHint.isHidden = false
        }else {
            self.lblHint.isHidden = true
        }
        if numberOfChars == 0 && text == " " {
            return false
        }
        
        if numberOfChars > 300 {
            return false
        }
        return true
    }
}
extension RightMenuViewController {
    func showSubCatView(isShow:Bool,isCategory:Bool) {
        if isShow {
            self.subCatView.isHidden = false
        }else {
            self.subCatView.isHidden = true
        }
    }
    @IBAction func backToSuper(_ sender: Any) {
        self.showSubCatView(isShow: false, isCategory: self.isCategoryShow)
    }
    @IBAction func sortByCatClick(_ sender: Any) {
        self.sideMenuController?.hideRightView(animated: true, completionHandler: {
            if let btn = sender as? UIButton {
                if let dict = self.filterByCategory[btn.tag] as? NSDictionary {
                    if let filterByCategoryId = dict["_id"] as? String {
                        self.delgate?.clikeInformationSent(info: ["filterByCategory":NSMutableArray.init(object: filterByCategoryId)])
                    }
                }
            }
        })
    }
    @IBAction func sortByBrandClick(_ sender: Any) {
        if let btn = sender as? UIButton {
            if let dict = self.filterByBrand[btn.tag] as? NSDictionary {
                if let _id =  dict["_id"] as? String {
                    if self.filterByBrandValues.contains(_id) {
                        self.filterByBrandValues.remove(_id)
                    }else {
                        self.filterByBrandValues.add(_id)
                    }
                }
            }
        }
        self.subTitleViiew.reloadData()
        
    }
    @IBAction func fotterSubmitCall(_ sender: Any) {
        self.sideMenuController?.hideRightView(animated: true, completionHandler: {
            self.delgate?.clikeInformationSent(info: ["filterByBrand": self.filterByBrandValues])
        })
    }
}
extension RightMenuViewController {
    
    @IBAction func hidePriceView(_ sender: Any) {
        self.priceView.isHidden = true
        
    }
    @IBAction func highestValue(_ sender: Any) {
        
        self.sideMenuController?.hideRightView(animated: true, completionHandler: {
            self.delgate?.clikeInformationSent(info: ["price":"desc"])
        })
    }
    @IBAction func lowestValue(_ sender: Any) {
       
        self.sideMenuController?.hideRightView(animated: true, completionHandler: {
            self.delgate?.clikeInformationSent(info: ["price":"asc"])
        })
    }
    @IBAction func priceRangeSubmit(_ sender: Any) {
        self.txtMaxprice.resignFirstResponder()
        self.txtMinPrice.resignFirstResponder()
        
        var minValue = 0
        var maxvalue = 0
        
        var pricerange = ""
        if let min = self.txtMinPrice.text {
            pricerange = min
            minValue = Int(min) ?? 0
        }else {
            pricerange = "0"
        }
        pricerange.append(":")
        if let max = self.txtMaxprice.text {
            pricerange.append(max)
            maxvalue = Int(max) ?? 0
        }else {
            pricerange.append("0")
        }
        if minValue >= maxvalue {
            alert(Constants.appName, message: "Please add max range greater than  min", view: self)
        }else  {
            self.sideMenuController?.hideRightView(animated: true, completionHandler: {
                self.delgate?.clikeInformationSent(info: ["range":pricerange])
            })
        }
        
    }
}
extension RightMenuViewController {
    func getCategoryList(isCategory:Bool) {
        self.filterByCategory = NSMutableArray.init()
        self.filterByBrand = NSMutableArray.init()
        self.subTitleViiew.reloadData()
        
        var  requestPath =  Constants.getRelatedInfo
        if isFromCategary {
            requestPath.append("?source=category&tmCode=\(self.selctedPageId)")
        }else {
            requestPath.append("?source=brand&brandId=\(self.selctedPageId)")
        }
        if isCategory {
            self.subTitleView.text = "FILTER BY CATEGORY"
            requestPath.append("&type=category")
        }else {
            self.subTitleView.text = "FILTER BY BRAND"
            requestPath.append("&type=brand")
        }
        
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:true) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"]  as? NSArray {
                                if isCategory  {
                                    self.filterByCategory.addObjects(from: data as! [Any])
                                }else {
                                    self.filterByBrand.addObjects(from: data as! [Any])
                                }
                            }
                            self.subTitleViiew.reloadData()
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
}
