//
//  LeftMenuViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 23/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var leadingViewCategory: NSLayoutConstraint!
    @IBOutlet weak var leadingViewSubCategory: NSLayoutConstraint!
    var isSubCategoryImage = false
    var isSubToSub = false
    var isSub = false
    
    @IBOutlet weak var lblHintCat: UILabel!
    @IBOutlet weak var lblHintSubCat: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var subCateTitle: UILabel!
    @IBOutlet weak var subCategaryImage: UIImageView!
    @IBOutlet var subCategoryView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet var subCategoryFotter: UIView!
    @IBOutlet var categoryFotter: UIView!
    @IBOutlet weak var btnLogoutCat: UIButton!
    @IBOutlet weak var btnLogoutSubCat: UIButton!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet var categoryHeaderView: UIView!
    @IBOutlet weak var categoryTbView: UITableView!
    @IBOutlet weak var suCategoryTbView: UITableView!
    @IBOutlet weak var subCateView: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet var footerView: UIView!
    var menuArray = NSMutableArray.init()
    var menuCatArray = NSMutableArray.init()
    var menuSubCatArray = NSMutableArray.init()
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leadingViewCategory.constant = self.view.frame.size.width
        self.leadingViewSubCategory.constant = self.view.frame.size.width
        tbView.delegate = self
        tbView.dataSource = self
        categoryTbView.delegate  = self
        categoryTbView.dataSource = self
        suCategoryTbView.delegate  = self
        suCategoryTbView.dataSource = self
        
        let nibhView = UINib(nibName: "MenuTableViewCell", bundle: nil)
        self.tbView.register(nibhView, forCellReuseIdentifier: "MenuTableViewCell")
        self.categoryTbView.register(nibhView, forCellReuseIdentifier: "MenuTableViewCell")
        self.suCategoryTbView.register(nibhView, forCellReuseIdentifier: "MenuTableViewCell")
        let nibMenuFooterTableViewCell = UINib(nibName: "menuFooterTableViewCell", bundle: nil)
        self.tbView.register(nibMenuFooterTableViewCell, forCellReuseIdentifier: "menuFooterTableViewCell")
        self.categoryTbView.register(nibMenuFooterTableViewCell, forCellReuseIdentifier: "menuFooterTableViewCell")
        self.suCategoryTbView.register(nibMenuFooterTableViewCell, forCellReuseIdentifier: "menuFooterTableViewCell")
        
        if ApplicationStates.isUserLoggedIn() {
            self.loginView.isHidden = true
            self.nameView.isHidden = false
            if let user = ApplicationStates.getUserData() {
                if let fname = user["fname"] as? String {
                    self.nameLbl.text  = "Hi " + fname
                }else {
                    self.nameLbl.text  = "Hi "
                }
                
                if let ffs = self.nameLbl.text {
                if ffs.count <= 10 {
                    if let lname = user["lname"] as? String {
                        if lname.count <= 8 {
                            self.nameLbl.text = "\(ffs) \(lname)"
                        }
                    }
                }
                }
            }
            self.btnLogout.isHidden  = false;
            self.btnLogoutCat.isHidden  = false;
            self.btnLogoutSubCat.isHidden  = false;
        }else {
            self.loginView.isHidden = false
            self.nameView.isHidden = true
            self.btnLogout.isHidden  = true;
            self.btnLogoutCat.isHidden  = true;
            self.btnLogoutSubCat.isHidden  = true;
        }
        self.getCategoryList()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func loginAction(_ sender: Any) {
        self.sideMenuController?.hideLeftView(animated: false, completionHandler: {
            let storyboard = UIStoryboard(name: "UserAuthenticate", bundle: nil)
            let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            if let navigation = self.sideMenuController?.children.last as? UINavigationController {
                navigation.pushViewController(signInViewController, animated: true)
            }
        })
    }
    
    @IBAction func signupAction(_ sender: Any) {
        self.sideMenuController?.hideLeftView(animated: false, completionHandler: {
            let storyboard = UIStoryboard(name: "UserAuthenticate", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            if let navigation = self.sideMenuController?.children.last as? UINavigationController {
                navigation.pushViewController(signUpViewController, animated: true)
            }
        })
    }
    
    @IBAction func langSelection(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let langSelectionVC = storyboard.instantiateViewController(withIdentifier: "langSelectionViewController") as! langSelectionViewController
        langSelectionVC.modalPresentationStyle =  .fullScreen
        self.present(langSelectionVC, animated: true) {
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        self.sideMenuController?.hideLeftView(animated: false, completionHandler: {
            showMessage(title: Constants.appName, message: Constants.logoutMessage, okButton: "Yes", cancelButton: "Cancel", controller: self, okHandler: {
                ApplicationStates.removeUserData()
                ApplicationStates.removeOrderInformation()
                PresentingCoordinator.shared().loginSucessAndPageRefersh()
            }) {
                //Cancel
            }
        })
    }
    
    @IBAction func backCategoryView(_ sender: Any) {
        isSub = false
        isSubToSub = false
        self.animationHide(isCategory: true)
    }
    @IBAction func backSubCatAction(_ sender: Any) {
        self.animationHide(isCategory: false)
        isSubToSub = false
        isSub = true
    }
    
}
extension LeftMenuViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tbView {
            return 10
        }else if tableView == self.categoryTbView {
            return 150
        }else if tableView == self.suCategoryTbView {
            if self.isSubCategoryImage {
                return 150
            }else {
                return 1
            }
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tbView {
            let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 10))
            hv.backgroundColor = UIColor.clear
            return hv
        }else if tableView == self.categoryTbView{
            return self.categoryHeaderView
        }else if tableView == self.suCategoryTbView {
            if self.isSubCategoryImage {
            return self.subCategoryView
            }
        }
            let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
            hv.backgroundColor = UIColor.clear
            return hv
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.tbView {
            return self.footerView
        }else if tableView == self.categoryTbView{
            return self.categoryFotter
        }else if tableView == self.suCategoryTbView{
            return self.subCategoryFotter
        }
        else {
            let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
            hv.backgroundColor = UIColor.clear
            return hv
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbView {
            if self.menuArray.count > 0 {
                return self.menuArray.count + 3
            }else {
                return self.menuArray.count
            }
        }else if tableView == self.categoryTbView {
            return self.menuCatArray.count
        }else if tableView == self.suCategoryTbView {
            return self.menuSubCatArray.count
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.infoLbl.text = ""
        cell.infoLbl.textColor = UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        cell.infoLbl.font = UIFont(name: "SegoeUI", size: 14)
        
        if tableView == self.tbView {
            cell.arrowImg.isHidden = false
            if indexPath.row == 0 {
                cell.infoLbl.font = UIFont(name: "SegoeUI-Bold", size: 14)

                cell.infoLbl.textColor = UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
                cell.infoLbl.text = "HOT DEALS"
                cell.arrowImg.isHidden = true
            }
            else if indexPath.row == self.menuArray.count + 1  {
                cell.infoLbl.textColor = UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
                cell.infoLbl.font = UIFont(name: "SegoeUI-Bold", size: 14)

                cell.infoLbl.text = "RECIPES"
                cell.arrowImg.isHidden = true
            }
            else if indexPath.row == self.menuArray.count + 2 {
                cell.infoLbl.textColor = UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
                cell.infoLbl.font = UIFont(name: "SegoeUI-Bold", size: 14)

                cell.infoLbl.text = "NEW ARRIVAL"
                cell.arrowImg.isHidden = true
            }
            else if let dict = self.menuArray[indexPath.row - 1] as? NSDictionary {
                if let ss = dict["categoryName"] as? String {
                    cell.infoLbl.text = ss.uppercased()
                }
            }
        }else if tableView == self.categoryTbView {
            cell.arrowImg.isHidden = true
            if let dict = self.menuCatArray[indexPath.row] as? NSDictionary {
                cell.infoLbl.text = dict["categoryName"] as? String
                if let subCategories = dict["subCategories"] as? NSArray {
                    if subCategories.count > 0 {
                        cell.arrowImg.isHidden = false
                    }
                }
            }
            
        }
        else if tableView == self.suCategoryTbView {
            cell.arrowImg.isHidden = true
            if let dict = self.menuSubCatArray[indexPath.row] as? NSDictionary {
                cell.infoLbl.text = dict["categoryName"] as? String
            }
        }
        cell.infoLbl.text = cell.infoLbl.text?.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.suCategoryTbView {
            if let dict = self.menuSubCatArray[indexPath.row] as? NSDictionary {
                self.openCategoryInfo(dict: dict)
            }
        }
        else if tableView == self.categoryTbView {
            isSubToSub = true
            if let dict = self.menuCatArray[indexPath.row] as? NSDictionary {
                if let subCategories = dict["subCategories"] as? NSArray {
                    if subCategories.count > 0 {
                        self.menuSubCatArray.removeAllObjects()
                        self.suCategoryTbView.reloadData()
                        self.animationShow(isCategory: false)
                        self.menuSubCatArray = NSMutableArray.init()
                        self.menuSubCatArray.addObjects(from: subCategories as! [Any])
                        self.loadSubCateGoryImageAndInfo(dict: dict)
                        self.suCategoryTbView.reloadData()
                    }else {
                        self.openCategoryInfo(dict: dict)
                    }
                }
            }
        }
        else if tableView == self.tbView {
            if indexPath.row == 0 {
                    let dict : [AnyHashable : Any] = ["localCategoryType":"1"]
                    self.openCategoryInfo(dict: dict as NSDictionary)
            }
            else if indexPath.row == self.menuArray.count + 1  {
                    let dict : [AnyHashable : Any] = ["localCategoryType":"2"]
                    self.openCategoryInfo(dict: dict as NSDictionary)
            }
            else if indexPath.row == self.menuArray.count + 2  {
                    let dict : [AnyHashable : Any] = ["localCategoryType":"3"]
                    self.openCategoryInfo(dict: dict as NSDictionary)
            }
            else {
                isSub = true
                self.menuCatArray.removeAllObjects()
                self.categoryTbView.reloadData()
                self.animationShow(isCategory: true)
                if let dict = self.menuArray[indexPath.row - 1] as? NSDictionary {
                    if let cat : String = dict["_id"] as? String {
                        self.loadCateGoryImageAndInfo(dict: dict)
                        self.getCategoryInfo(catId:cat)
                    }
                }
            }
        }else {
            
        }
    }
    func openCategoryInfo(dict:NSDictionary) {
        self.sideMenuController?.hideLeftView(animated: false, completionHandler: {
            NotificationCenter.default.post(name: Notification.Name("leftmenuCategoryClick"), object: nil, userInfo:dict as? [AnyHashable : Any])
        })
    }
    func loadCateGoryImageAndInfo(dict:NSDictionary){
        if let ss = dict["categoryName"] as? String {
            self.lblHintSubCat.text = ss.uppercased()
            self.categoryTitle.text = ss.uppercased()
            if let imagePath = dict["imageUrl"] as? String {
                let imageUrl = NetworkManager.shared.baseImageURL + imagePath.replacingOccurrences(of: " ", with: "%20")
                let url = URL(string:imageUrl )
                self.categoryImageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
            }
            
        }
    }
    func loadSubCateGoryImageAndInfo(dict:NSDictionary){
        if let ss = dict["categoryName"] as? String {
            self.subCateTitle.text = ss.uppercased()
        }
        if let imagePath = dict["imageUrl"] as? String {
            self.isSubCategoryImage = true
            let imageUrl = NetworkManager.shared.baseImageURL + imagePath.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string:imageUrl )
            self.subCategaryImage.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
        }else {
            self.isSubCategoryImage = false
        }
    }
    func animationShow(isCategory:Bool) {
        if isCategory {
            self.leadingViewCategory.constant = self.view.frame.size.width
        }else {
            self.leadingViewSubCategory.constant = self.view.frame.size.width
        }
        UIView.animate(withDuration: 0.3) {
            if isCategory {
                self.leadingViewCategory.constant = 0
            }else {
                self.leadingViewSubCategory.constant = 0
            }
            self.view.layoutIfNeeded()
        }
    }
    func animationHide(isCategory:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isCategory {
                self.leadingViewCategory.constant = self.view.frame.size.width
            }else {
                self.leadingViewSubCategory.constant = self.view.frame.size.width
            }
            self.view.layoutIfNeeded()
        }) { (isSucess) in
        }
    }
    
}
extension LeftMenuViewController {
    func getCategoryInfo(catId:String) {
        let post:[String:Any] = ["categoryId": catId]
        NetworkManager.shared.postJSONResponse(path:  Constants.subCategory, parameters:post,isLoder: false) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSArray {
                                self.menuCatArray = NSMutableArray.init()
                                self.menuCatArray.addObjects(from: data as! [Any])
                                self.categoryTbView.reloadData()
                            }
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func getSubCategoryInfo(catId:String) {
        let post:[String:Any] = ["categoryId": catId]
        NetworkManager.shared.postJSONResponse(path:  Constants.subCategory, parameters:post,isLoder: false) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSArray {
                                self.menuSubCatArray = NSMutableArray.init()
                                self.menuSubCatArray.addObjects(from: data as! [Any])
                                self.suCategoryTbView.reloadData()
                            }
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func getCategoryList(){
        let requestPath =  "core/category-by-level?categoryLevel=1"
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:false) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSArray {
                               for ids in data {
                                    self.menuArray.add(ids)
                                }
                                self.tbView.reloadData()
                                self.categoryTbView.reloadData()
                            }
                        }}}
            case .error(let error):
                print(error!)
            }
        }
    }
}
