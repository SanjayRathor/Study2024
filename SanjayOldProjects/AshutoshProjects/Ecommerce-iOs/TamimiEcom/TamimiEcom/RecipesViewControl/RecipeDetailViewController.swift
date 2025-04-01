//
//  RecipeDetailViewController.swift
//  TamimiEcom
//
//  Created by Aravind Kumar on 24/10/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import UIKit
class gridDetailsCell : UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
}
class RecipeDetailViewController: UIViewController {
    var itemArray : NSMutableArray!
    var gridType = true
    
    var  ingredients : [String] = NSArray.init() as! [String]
    var directions : [String] = NSArray.init() as! [String]
    var info:NSDictionary?
    var infoFullResponce:NSDictionary?
    
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnEx: UIButton!
    @IBOutlet weak var middleBtnConst: NSLayoutConstraint!
    @IBOutlet weak var btnBundleOffer: UIButton!
    @IBOutlet weak var btnWeekOffer: UIButton!
    @IBOutlet weak var ctView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemArray = NSMutableArray.init()
        
        self.setFont()
        self.registerNib()
        
        self.ctView.delegate = self
        self.ctView.dataSource =  self
        
        self.getFullRecipesData()
        self.getProductByRecipeData()
        // Do any additional setup after loading the view.
    }
    func registerNib() {
        let nibtitleHeader = UINib(nibName: "titleHeaderCollectionViewCell", bundle: nil)
        self.ctView.register(nibtitleHeader, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleHeaderCollectionViewCell")
        let nibInfoEmptyCell = UINib(nibName: "emptyCollectionViewCell", bundle: nil)
        self.ctView.register(nibInfoEmptyCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "emptyCollectionViewCell")
        
        let nibCategory = UINib(nibName: "categoryCell", bundle: nil)
        self.ctView.register(nibCategory, forCellWithReuseIdentifier: "categoryCell")
        let categoryNormal = UINib(nibName: "categoryNormal", bundle: nil)
        self.ctView.register(categoryNormal, forCellWithReuseIdentifier: "categoryNormal")
    }
    func getFullRecipesData() {
        if let recipesId = self.info?["_id"] as? String {
            let  requestPath =  Constants.getRecipeById
            let params : [String : String] = ["recipeId":recipesId]
            NetworkManager.shared.getJSONResponse(path: requestPath, parameters: params) { (value, status) in
             //   print(value)
                switch status {
                case .success:
                    if let valueData  = value as? NSDictionary {
                        if let code = valueData["code"] as? Int {
                            if code == 201 {
                                if let data = valueData["data"] as? NSDictionary {
                                    if let directions = data["directions"] as? NSArray {
                                        self.directions = directions as! [String]
                                    }
                                    if let ingredients = data["ingredients"] as? NSArray {
                                        self.ingredients = ingredients as! [String]
                                    }
                                    self.infoFullResponce = data
                                }
                                
                                self.ctView.reloadData()
                            }
                        }
                    }
                case .error(let error):
                    print(error!)
                }
            }
        }
    }
    func getProductByRecipeData() {
        //http://{{server}}/v1/core/product-by-recipe
        let  requestPath =  Constants.productByRecipe
        if let recipesId = self.info?["_id"] as? String {
            let params : [String : String] = ["recipeId":recipesId]
            NetworkManager.shared.postJSONResponse(path: requestPath,parameters:params,isLoder: false) { (value, status) in
                switch status {
                case .success:
                    if let valueData  = value as? NSDictionary {
                        if let code = valueData["code"] as? Int {
                            if code == 201 {
                                if let data = valueData["data"] as? NSArray {
                                    self.itemArray.removeAllObjects()
                                    for ids in data {
                                        if let idsDict = ids as? [String:Any] {
                                            let categoryModel = CategoryDetail()
                                            if let selectedQuanity = idsDict["selectedQuanity"] as? String {
                                                categoryModel.count = Int(selectedQuanity) ?? 0
                                            }else {
                                                categoryModel.count = 0
                                            }
                                            if let isLiked = idsDict["isLiked"] as? Bool {
                                                categoryModel.isLiked = isLiked
                                                
                                            }
                                            if let product = idsDict["product"] as? [String:Any] {
                                                categoryModel.id = product["_id"] as! String
                                                categoryModel.name.update(other: product)
                                                self.itemArray.add(categoryModel)
                                            }
                                        }
                                        
                                    }
                                }
                                self.ctView.reloadData()
                            }
                            
                        }
                    }
                case .error(let error):
                    print(error!)
                }
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openSearchViewControllers(_ sender: Any) {
        let searchViewController : SearchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if let recipesId = self.info?["_id"] as? String {
            PresentingCoordinator.shared().openShareDailog(productId: recipesId,type: "recipe")
        }
    }
    @IBAction func printAction(_ sender: Any) {
        let info = UIPrintInfo(dictionary:nil)
            info.outputType = UIPrintInfo.OutputType.general
            info.jobName = "Printing"
            let vc = UIPrintInteractionController.shared
            vc.printInfo = info

            vc.printingItem = UIImage.image(fromView: self.ctView) // your view here

            vc.present(from: self.view.frame, in: self.ctView, animated: true, completionHandler: nil)

    }
}
extension UIImage {

    /// Get image from given view
    ///
    /// - Parameter view: the view
    /// - Returns: UIImage
    public class func image(fromView view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
extension RecipeDetailViewController {
    func setFont() {
        if self.view.frame.size.width < 375 {
            self.middleBtnConst.constant =  95
        }else if self.view.frame.size.width == 375 {
            self.middleBtnConst.constant =  120
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
    @IBAction func selectLocationAction(_ sender: Any) {
        let objLocation : PickIUpViewController = PickIUpViewController(nibName: "PickIUpViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(objLocation, animated: true)
        
    }
    func updateLocation() {
        if  let info =    ApplicationStates.getLocationInformation() as? NSDictionary{
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
//MARK: UICollectionViewDataSource
extension RecipeDetailViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.infoFullResponce == nil {
            return 0
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return self.ingredients.count
        }
        else if section == 2{
            return self.directions.count
        }
        else if section == 3{
            return self.itemArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        var h : CGFloat = 0.0;
        if section == 1 {
            if self.ingredients.count > 0 {
                h = 20
            }
        }
        if section == 2 {
            if self.directions.count > 0 {
                h = 35
            }
        }
        if section == 3 {
            if self.itemArray.count > 0 {
                h = 50
            }
        }
        let w = self.view.frame.size.width
        let size = CGSize(width: w, height: h)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter){
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
            return headerView
        } else {
            if indexPath.section == 1  || indexPath.section == 2 || indexPath.section == 3 {
                let titleHeader : titleHeaderCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "titleHeaderCollectionViewCell", for: indexPath) as! titleHeaderCollectionViewCell
                titleHeader.lblTitle.font = UIFont(name: "SegoeUI-Bold", size: 12)
                titleHeader.lblTitle.textColor = UIColor.black
                titleHeader.lblTitle.textAlignment = .left
                titleHeader.backgroundColor = UIColor.clear

                if indexPath.section == 1  {
                    titleHeader.lblTitle.text = "Ingredients"
                }else if indexPath.section == 2  {
                    titleHeader.lblTitle.text = "Directions"
                }
                else if indexPath.section == 3  {
                    titleHeader.lblTitle.text = "Ingredients from the recipe"
                    titleHeader.lblTitle.font = UIFont(name: "SegoeUI-Bold", size: 20)
                    titleHeader.lblTitle.textColor = UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1)
                }
                // Customize headerView here
                return titleHeader
            }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let titlefont = UIFont(name: "SegoeUI", size: 22)!
            let despfont = UIFont(name: "SegoeUI", size: 12)!
            let cell : gridFristCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridFristCell", for: indexPath as IndexPath) as! gridFristCell
            if let dict = self.infoFullResponce {
                let title  = dict["title"] as! String + "\n"
                let prep : String = self.infoFullResponce?["prep"] as? String ?? ""
                let cook : String = self.infoFullResponce?["cook"] as? String ?? ""
                let aditional : String = self.infoFullResponce?["additional"] as? String ?? ""
                let total : String = self.infoFullResponce?["total"] as? String ?? ""
                let servings : String = self.infoFullResponce?["servings"] as? String ?? ""
                let yield : String = self.infoFullResponce?["yield"] as? String ?? ""
                
                let desp  = dict["description"] as! String + "\n\nPrep:\(prep)\nCook:\(cook)\nAdditional: \(aditional)\nTotal: \(total)\nServings: \(servings)\nYield: \(yield)"
                
                let attrString = NSMutableAttributedString(string: title,
                                                           attributes: [NSAttributedString.Key.font: titlefont]);
                
                attrString.append(NSMutableAttributedString(string: desp,
                                                            attributes: [NSAttributedString.Key.font: despfont]));
                
                let range = ((title + desp)  as NSString).range(of: desp)
                let colr = UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1)
                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: colr, range: range)
                
                cell.lblTitle.attributedText = attrString
                if let imagePath = dict["defaultImage"] as? String {
                    let imageUrl = NetworkManager.shared.baseImageURL + imagePath.replacingOccurrences(of: " ", with: "%20")
                    let url = URL(string:imageUrl )
                    cell.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
                }
            }else {
                cell.lblTitle.text = ""
            }
            //        cell.lblTitle.backgroundColor = UIColor.red
            //        cell.backgroundColor = UIColor.green
            
            return cell
            
        }else if indexPath.section == 3 {
            if self.gridType == true {
                let cell : categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! categoryCell
                cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
                cell.likeRemoveDeleagte = self
                return cell
            }else {
                let cell : categoryNormal = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryNormal", for: indexPath as IndexPath) as! categoryNormal
                cell.likeRemoveDeleagte = self
                cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
                return cell
            }
        }
        else {
            let cell : gridDetailsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridDetailsCell", for: indexPath as IndexPath) as! gridDetailsCell
            if indexPath.section == 1{
                cell.lblTitle.text = self.ingredients[indexPath.row]
            }else {
                let str = self.directions[indexPath.row]
                let step = "Step \(indexPath.row + 1)\n"
                cell.lblTitle.text = step + str + "\n"
            }
            cell.lblTitle.font = UIFont(name: "SegoeUI", size: 12)!
            cell.lblTitle.textColor = UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1)
            return cell;
        }
    }
}
extension RecipeDetailViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        if indexPath.section == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let productDetilsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetilsVC") as! ProductDetilsVC
            let  categoryDetail : CategoryDetail = itemArray[indexPath.row] as! CategoryDetail
            productDetilsVC.productId = categoryDetail.id
            self.navigationController?.pushViewController(productDetilsVC, animated: true)
        }
    }
}
extension RecipeDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let despfont = UIFont(name: "SegoeUI", size: 12)!
        
        if indexPath.section == 0 {
            if let dict = self.infoFullResponce {
                var infoT  = dict["title"] as! String + " \n "
                let prep : String = self.infoFullResponce?["prep"] as? String ?? ""
                let cook : String = self.infoFullResponce?["cook"] as? String ?? ""
                let aditional : String = self.infoFullResponce?["additional"] as? String ?? ""
                let total : String = self.infoFullResponce?["total"] as? String ?? ""
                let servings : String = self.infoFullResponce?["servings"] as? String ?? ""
                let yield : String = self.infoFullResponce?["yield"] as? String ?? ""
                
                let desp  = dict["description"] as! String + "\n\nPrep:\(prep)\nCook:\(cook)\nAdditional: \(aditional)\nTotal: \(total)\nServings: \(servings)\nYield: \(yield)"
                
                infoT = infoT + infoT + desp
                let hs = infoT.heightWithConstrainedWidthSlooff(width: self.view.frame.size.width - 30, font: despfont)
                return CGSize(width: self.view.frame.size.width , height:hs + 245 )
            }
        }else if indexPath.section == 1 {
            let infoT  = self.ingredients[indexPath.row]
            let hs = infoT.heightWithConstrainedWidthSlooff(width: self.view.frame.size.width - 30, font: despfont)
            return CGSize(width: self.view.frame.size.width , height:hs)
        }
        else if indexPath.section == 2 {
            let step = "Step \(indexPath.row + 1)\n"
            let infoT  = step + self.directions[indexPath.row] + "\n"
            let hs = infoT.heightWithConstrainedWidthSlooff(width: self.view.frame.size.width - 30, font: despfont)
            return CGSize(width: self.view.frame.size.width , height:hs+5)
        }
        else if indexPath.section == 3 {
            if self.gridType == true {
                return CGSize(width: self.view.frame.size.width/2 - 7 , height:240)
            }else {
                return CGSize(width: self.view.frame.size.width , height:100)
            }
        }
        return CGSize(width: self.view.frame.size.width , height:0)
    }
}
extension String {
    
    func heightWithConstrainedWidthSlooff(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
}
extension RecipeDetailViewController : LikeCellRemoveNormalDelegate,LikeCellRemoveDelegate {
    func openLoginView() {
        PresentingCoordinator.shared().openLoginPage()
    }
    func openLoginViewNormal() {
        PresentingCoordinator.shared().openLoginPage()
    }
    
    func isLikeRemoved(index: Int) {
        //Do Nothing
    }
    func isLikeRemovedNormal(index: Int) {
        //Do Nothing
    }
}
