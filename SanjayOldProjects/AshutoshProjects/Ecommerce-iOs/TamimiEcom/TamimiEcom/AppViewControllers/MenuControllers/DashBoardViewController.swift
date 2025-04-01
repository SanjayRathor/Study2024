//
//  DashBoardViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 23/08/20.
//  Copyright ©  ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
class DashBoardViewController: UIViewController {
    @IBOutlet weak var btnEx: UIButton!
    @IBOutlet weak var middleBtnConst: NSLayoutConstraint!
    @IBOutlet weak var btnBundleOffer: UIButton!
    @IBOutlet weak var btnWeekOffer: UIButton!
    var firstTimeDataRecived =  false
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var advertsSection : AdvertsSection? = nil
    var dataSections: [DashBoardSection] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationCartUapdate(notification:)), name: Notification.Name("cartUpdateCount"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationBudgeUpdate(notification:)), name: Notification.Name("cartBudgeUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationCategoryClick(notification:)), name: Notification.Name("leftmenuCategoryClick"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOrderCompete), name: Notification.Name("orderComplete"), object: nil)
    }
    @objc func methodOfReceivedNotificationOrderCompete(notification: Notification) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFont()
        self.addObserver()
        if ApplicationStates.isUserLoggedIn() {
            if ApplicationStates.getCartBudge() == "0" {
                self.tabBarController?.tabBar.items?[1].badgeValue = nil
            }else {
                self.tabBarController?.tabBar.items?[1].badgeValue = String(ApplicationStates.getCartBudge())
            }
        }
        self.registerNib()
        self.sideMenuController?.isRightViewSwipeGestureEnabled = false
        self.sideMenuController?.isRightViewSwipeGestureDisabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        self.getOrderDetails()
        self.getDashBoardData()
        // Do any additional setup after loading the view.
    }
    func registerNib() {
        let nibInfoFooter = UINib(nibName: "footerCollectionViewCell", bundle: nil)
        self.collectionView.register(nibInfoFooter, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerCollectionViewCell")
        let nibInfoEmptyCell = UINib(nibName: "emptyCollectionViewCell", bundle: nil)
        self.collectionView.register(nibInfoEmptyCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "emptyCollectionViewCell")
        self.collectionView.register(nibInfoEmptyCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "emptyCollectionViewCell")
        self.collectionView.register(nibInfoEmptyCell, forCellWithReuseIdentifier: "emptyCollectionViewCell")
        let nibBanner = UINib(nibName: "banneCollectionViewCell", bundle: nil)
        self.collectionView.register(nibBanner, forCellWithReuseIdentifier: "banneCollectionViewCell")
        let nibtitleHeader = UINib(nibName: "titleHeaderCollectionViewCell", bundle: nil)
        self.collectionView.register(nibtitleHeader, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleHeaderCollectionViewCell")
        let nibBrandCell = UINib(nibName: "brandCell", bundle: nil)
        self.collectionView.register(nibBrandCell, forCellWithReuseIdentifier: "brandCell")
        let nibDepartmentCell = UINib(nibName: "departmentCell", bundle: nil)
        self.collectionView.register(nibDepartmentCell, forCellWithReuseIdentifier: "departmentCell")
        let nibInfoCell = UINib(nibName: "homeCell", bundle: nil)
        self.collectionView.register(nibInfoCell, forCellWithReuseIdentifier: "homeCell")
        let nibBestSellerCell = UINib(nibName: "bestSellerCollectionViewCell", bundle: nil)
        self.collectionView.register(nibBestSellerCell, forCellWithReuseIdentifier: "bestSellerCollectionViewCell")
    }
    
    @IBAction func openLeftMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    @IBAction func selectLocationAction(_ sender: Any) {
        let objLocation : PickIUpViewController = PickIUpViewController(nibName: "PickIUpViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(objLocation, animated: true)
    }
    @IBAction func openSearchViewControllers(_ sender: Any) {
        let searchViewController : SearchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(searchViewController, animated: true)
    }
}
//MARK: UICollectionViewDataSource
extension DashBoardViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let cellModel = dataSections[section].sectionType
        var h : CGFloat = 0.0;
        switch cellModel {
        case .banner:
            h =  0
        case .brand:
            h =  30
        case .department:
            h =  30
        case .seller:
            h =  30
        }
        let w = self.view.frame.size.width
        let size = CGSize(width: w, height: h)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        let cellModel = dataSections[section].sectionType
        var h : CGFloat = 0.0;
        switch cellModel {
        case .banner:
            h =  0
        case .brand:
            h =  0
        case .department:
            if self.advertsSection != nil && self.advertsSection?.adverts.count ?? 0 > 0 {
                h =  120
            }else {
                h =  0
            }
        case .seller:
            h =  0
        }
        let w = self.view.frame.size.width
        let size = CGSize(width: w, height: h)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let model = dataSections[indexPath.section]
        if (kind == UICollectionView.elementKindSectionFooter) {
            let cellModel = dataSections[indexPath.section].sectionType
            switch cellModel {
            case .banner:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
                return headerView
            case .brand:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
                return headerView
            case .department:
                if self.advertsSection != nil && self.advertsSection?.adverts.count ?? 0 > 0 {
                    let cell : banneCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "banneCollectionViewCell", for: indexPath as IndexPath) as! banneCollectionViewCell
                    cell.isBanner = false
                    cell.advertsInfoArray = self.advertsSection?.adverts
                    cell.loadBanner()
                    cell.delegate = self
                    return cell
                }else {
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
                    return headerView                                      }
            case .seller:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
                return headerView
            }
        }else {
            if model.title == "" {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
                return headerView
            }else {
                let titleHeader : titleHeaderCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "titleHeaderCollectionViewCell", for: indexPath) as! titleHeaderCollectionViewCell
                titleHeader.lblTitle.text = model.title.uppercased()
                titleHeader.backgroundColor = UIColor.clear
                return titleHeader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = dataSections[section].cellModels
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = dataSections[indexPath.section].cellModels[indexPath.row]
        switch cellModel {
        case .Banner(banner: let banners):
            let cell : banneCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "banneCollectionViewCell", for: indexPath as IndexPath) as! banneCollectionViewCell
            cell.bannerInfoArray = banners
            cell.loadBanner()
            cell.delegate = self
            return cell
        case .Brand(brand: let brand):
            let cell : brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath as IndexPath) as! brandCell
            let imageUrl = NetworkManager.shared.baseImageURL + brand.imageUrl
            let url = URL(string:imageUrl )
            cell.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
            return cell
        case .Department(department: let department):
            let cell : departmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "departmentCell", for: indexPath as IndexPath) as! departmentCell
            let imageUrl = NetworkManager.shared.baseImageURL + department.imageUrl
            let url = URL(string:imageUrl )
            cell.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
            if department.name != "" {
                cell.lblTitle.text = department.name.uppercased()
            }else {
                cell.lblTitle.text = "Department name".uppercased()
            }
            return cell
        case .BestSeller(product: let product):
            let cell : bestSellerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCollectionViewCell", for: indexPath as IndexPath) as! bestSellerCollectionViewCell
            cell.delegate = self
            cell.bestSellerInfoArray = product
            cell.loadBestSeller()
            
            return cell
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.collectionView.visibleCells.forEach { vissibleCell in
            if let cell : banneCollectionViewCell = vissibleCell as? banneCollectionViewCell {
                cell.isVisbileShow(isShow:true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell : banneCollectionViewCell = cell as? banneCollectionViewCell {
            cell.isVisbileShow(isShow:false)
        }
    }
    
}
extension DashBoardViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var idCat = ""
        var catName = ""
        var catType = 0
        let cellModel = dataSections[indexPath.section].cellModels[indexPath.row]
        switch cellModel {
        case .Banner(banner: let banners):
            break
        case .Brand(brand: let brand):
            idCat =  brand.id
            catName = brand.name
            catType = 2
            break
        case .Department(department: let department):
            idCat =  department.tmCode
            catName = department.name
            catType = 1
            break
        case .BestSeller(product: let product):break
        }
        
        if idCat != "" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            categoryViewController.categoryID = idCat
            categoryViewController.categoryType = catType
            categoryViewController.catName = catName
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }
        
    }
}
extension DashBoardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.size.width/2-5
        let model = dataSections[indexPath.section]
        switch model.sectionType {
        case .banner:
            return CGSize(width: self.view.frame.size.width , height:160)
        case .brand:
            return CGSize(width: w , height:self.getBrandCellHeight(width: w))
        case .department:
            return CGSize(width: w , height:self.getCellHeight(width: w))
        case .seller:
            return CGSize(width: self.view.frame.size.width , height:235)
        }
    }
    func  getCellHeight(width:CGFloat) -> CGFloat {
        let multiplier = 0.675
        return width*CGFloat(multiplier)
    }
    func  getBrandCellHeight(width:CGFloat) -> CGFloat {
        let multiplier = 0.40
        return width*CGFloat(multiplier)
    }
}

extension DashBoardViewController {
    
    func getBestSellersBoardData() {
        NetworkManager.shared.getJSONResponse(path: Constants.getBestSellers,isLoader:false) { (value, status) in
            switch status {
                       case .success:
                        if let valueData  = value as? NSDictionary {
                if let success = valueData["success"] as? Int {
                if success == 1 {
                if let data = valueData["data"] as? NSArray {
                    if data.count > 0 {
                        let obj = self.dataSections[2]
                        let sellerDict  = ["Name":obj.title,"count":obj.count,"id":obj.id,"items":data] as [String : Any]
                    self.dataSections.remove(at: 2)
                    self.dataSections.insert(BestSellerSection(dataDict:sellerDict as NSDictionary), at: 2)
                    }
            }
                }
                    }
                        }
                       case .error(let error):
                           print(error!)
                       }
        };
    }
    
    func getDashBoardData() {
           NetworkManager.shared.getJSONResponse(path: Constants.fetchLandingDetails,isLoader:false) { (value, status) in
               switch status {
               case .success:
                   self.dataSections = self.preapareDashBoard(response: JSON(value!))
                   self.firstTimeDataRecived = true
                   self.getBestSellersBoardData()
               case .error(let error):
                   print(error!)
               }
           };
       }
    
    
    func preapareDashBoard(response:JSON) ->[DashBoardSection] {
        var noOfsections = [DashBoardSection]()
        let responseData = response["data"].dictionaryValue
        if let bannerdict = responseData["banner"] {
            let bannerSelction = BannerSection(bannerdict)
            noOfsections.append(bannerSelction)
        }
        if let advertsdict = responseData["adverts"] {
            self.advertsSection = AdvertsSection(advertsdict)
        }
        
        if let jsonArray = responseData["object"]?.arrayValue {
            let brandsDict =  jsonArray[0]
            let departmentDict =  jsonArray[1]
             let sellerDict =  jsonArray[2]
            //Parse banner
            let brandSection = BrandSection(brandsDict)
            noOfsections.append(DepartmentSection(departmentDict))
            if let items = sellerDict["items"].rawValue as? NSArray {
                if items.count > 0 {
            noOfsections.append(BestSellerSection(sellerDict))
                }
            }
            noOfsections.append(brandSection)
        }
        return noOfsections;
    }
}
extension DashBoardViewController {
    func getOrderDetails() {
        NetworkManager.shared.getJSONResponse(path: Constants.orderDetails,isLoader:false) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSDictionary {
                                if let productId = data["productId"] as? NSArray {
                                    if productId.count > 0 {
                                        
                                        ApplicationStates.saveCartBudge(Info: String(productId.count))
                                        self.tabBarController?.tabBar.items?[1].badgeValue = String(ApplicationStates.getCartBudge())
                                    }
                                }
                                if data.count > 0 {
                                    if let orderNumber = data["orderNumber"] as? String {
                                        ApplicationStates.saveOrderNumber(Info: orderNumber)
                                    }
                                    if let orderId = data["_id"] as? String {
                                        ApplicationStates.saveOrderId(Info: orderId)
                                    }
                                }else {
                                    ApplicationStates.removeOrderInformation()
                                }
                                
                            }
                        }}}
                
            case .error(let error):
                print(error!)
            }
            print( ApplicationStates.getOrderNumber());
        }
    }
    @objc func methodOfReceivedNotificationBudgeUpdate(notification: Notification) {
        if let userInfo = notification.userInfo as? [String:Any] {
            if let type = userInfo["type"] as? Int {
                if  var budgeVlaue = Int(self.tabBarController?.tabBar.items?[1].badgeValue ?? "0") {
                    if budgeVlaue == 0  && type == 1 {
                        return
                    }
                    if type == 1 {
                        budgeVlaue = budgeVlaue - 1;
                    }else  if type == 2 {
                        budgeVlaue = budgeVlaue + 1;
                    }else {
                        budgeVlaue = 0
                    }
                    if budgeVlaue == 0 {
                        self.tabBarController?.tabBar.items?[1].badgeValue = nil
                    }else {
                        self.tabBarController?.tabBar.items?[1].badgeValue = String(budgeVlaue)
                    }
                }
            }
            ApplicationStates.saveCartBudge(Info: String(self.tabBarController?.tabBar.items?[1].badgeValue ?? "0"))
            
        }
    }
    @objc func methodOfReceivedNotificationCartUapdate(notification: Notification) {
    if let dict  =  notification.userInfo {
        if let count  = dict["count"] as? Int {
        if count > 0 {
            ApplicationStates.saveCartBudge(Info: String(count))
            self.tabBarController?.tabBar.items?[1].badgeValue = String(ApplicationStates.getCartBudge())
        }
    }
    }
    }
    @objc func methodOfReceivedNotificationCategoryClick(notification: Notification) {
        if let categoryInfo = notification.userInfo {
            if let localRedirect = categoryInfo["localCategoryType"] as? String {
                if localRedirect == "1" || localRedirect == "3" {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let moreOptionsViewController = storyboard.instantiateViewController(withIdentifier: "MoreOptionsViewController") as! MoreOptionsViewController
                    if localRedirect == "1" {
                        moreOptionsViewController.categoryType = 4
                    }else {
                        moreOptionsViewController.categoryType = 5
                    }
                    self.navigationController?.pushViewController(moreOptionsViewController, animated: true)
                }else if localRedirect == "2" {
                    let storyboard = UIStoryboard(name: "Recipes", bundle: nil)
                    let moreOptionsViewController = storyboard.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
                    self.navigationController?.pushViewController(moreOptionsViewController, animated: true)

                }
            }
            else  if let idValue = categoryInfo["_id"] as? String {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                categoryViewController.categoryID = idValue
                categoryViewController.categoryType = 1
                categoryViewController.catName = categoryInfo["categoryName"] as! String
                self.navigationController?.pushViewController(categoryViewController, animated: true)
            }
        }
    }
    @IBAction func moreOptionClick(_ sender: Any) {
        if let btn  = sender as? UIButton {
            //MoreOptionsViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreOptionsViewController = storyboard.instantiateViewController(withIdentifier: "MoreOptionsViewController") as! MoreOptionsViewController
            moreOptionsViewController.categoryType = btn.tag
            self.navigationController?.pushViewController(moreOptionsViewController, animated: true)
        }
    }
}
extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}
extension DashBoardViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLocation()
        if self.firstTimeDataRecived {
            self.getBestSellersBoardData()
        }
    }
    func updateLocation() {
        if  let info = ApplicationStates.getLocationInformation() as? NSDictionary {
            if var locationName = info["locationName"] as? String {
                locationName = "  " + locationName
                self.btnLocation.setTitle(locationName, for: .normal)
            }
            else {
                self.btnLocation.setTitle("  Select Your Location", for: .normal)
            }
        }
    }
}
extension DashBoardViewController : BannerInformation,ClickFooterInformation {
    func bannerInfoClick(banner: Banner?, advert: Adverts?) {
        if let bt  = banner{
            let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
            let webViewViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            webViewViewController.isTamilMemberPage = true
            webViewViewController.directUrlPath =  bt.urlPath
            self.navigationController?.pushViewController(webViewViewController, animated: true)
        }else  if let ad  = advert {
            let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
            let webViewViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            webViewViewController.isTamilMemberPage = true
            webViewViewController.directUrlPath =  ad.urlPath
            self.navigationController?.pushViewController(webViewViewController, animated: true)
        }
    }
    func clickIndex(ad: Adverts) {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let webViewViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        webViewViewController.isTamilMemberPage = true
        webViewViewController.directUrlPath =  ad.urlPath
        self.navigationController?.pushViewController(webViewViewController, animated: true)
    }
}
extension DashBoardViewController : BestSellerInformation {
    func bannerInfoClick(category: CategoryDetail?) {
        if let categoryId = category?.id {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetilsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetilsVC") as! ProductDetilsVC
        productDetilsVC.productId = categoryId
        self.navigationController?.pushViewController(productDetilsVC, animated: true)
        }
    }
    func setFont() {
        if self.view.frame.size.width < 375 {
        self.middleBtnConst.constant =  95
        }else if self.view.frame.size.width == 375 {
            self.middleBtnConst.constant =  120
            }
    }
}
