//
//  RecipeViewController.swift
//  TamimiEcom
//
//  Created by Aravind Kumar on 23/10/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import UIKit
class gridFristCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var widthImageConst: NSLayoutConstraint!
    
}
class gridSecondCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var widthImageConst: NSLayoutConstraint!
}
class RecipeViewController: UIViewController {
    var itemArray : NSMutableArray!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnEx: UIButton!
    @IBOutlet weak var middleBtnConst: NSLayoutConstraint!
    @IBOutlet weak var btnBundleOffer: UIButton!
    @IBOutlet weak var btnWeekOffer: UIButton!
    @IBOutlet weak var ctView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFont()
        self.itemArray = NSMutableArray.init()
        self.ctView.delegate = self
        self.ctView.dataSource =  self
        // Do any additional setup after loading the view.
        self.getAllRecipesData()
    }
    func getAllRecipesData() {
        let  requestPath =  Constants.getAllRecipes
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
                            self.ctView.reloadData()
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
    @IBAction func openSearchViewControllers(_ sender: Any) {
        let searchViewController : SearchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(searchViewController, animated: true)
    }
}
//MARK: UICollectionViewDataSource
extension RecipeViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let titlefont = UIFont(name: "SegoeUI", size: 22)!
        let despfont = UIFont(name: "SegoeUI", size: 12)!
        if indexPath.row % 2 == 0 {
            let cell : gridFristCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridFristCell", for: indexPath as IndexPath) as! gridFristCell
            if indexPath.row % 3 == 0 {
                cell.widthImageConst.constant =  180;
            }else {
                cell.widthImageConst.constant =  120;
            }
            if let dict = self.itemArray[indexPath.row] as? NSDictionary {
                let title  = dict["title"] as! String + "\n"
                let desp  = dict["sortDescription"] as! String
                
                let attrString = NSMutableAttributedString(string: title,
                                                           attributes: [NSAttributedString.Key.font: titlefont]);
                
                attrString.append(NSMutableAttributedString(string: desp,
                                                            attributes: [NSAttributedString.Key.font: despfont]));
                cell.lblTitle.attributedText = attrString
                if let imagePath = dict["defaultImage"] as? String {
                    let imageUrl = NetworkManager.shared.baseImageURL + imagePath.replacingOccurrences(of: " ", with: "%20")
                    let url = URL(string:imageUrl )
                    cell.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
                }
            }else {
                cell.lblTitle.text = ""
            }
            return cell
        }else {
            let cell : gridSecondCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridSecondCell", for: indexPath as IndexPath) as! gridSecondCell
            if indexPath.row % 3 == 0 {
                cell.widthImageConst.constant =  180;
            }else {
                cell.widthImageConst.constant =  120;
            }
            
            if let dict = self.itemArray[indexPath.row] as? NSDictionary {
                let title  = dict["title"] as! String + "\n"
                let desp  = dict["sortDescription"] as! String
                
                let attrString = NSMutableAttributedString(string: title,
                                                           attributes: [NSAttributedString.Key.font: titlefont]);
                
                attrString.append(NSMutableAttributedString(string: desp,
                                                            attributes: [NSAttributedString.Key.font: despfont]));
                cell.lblTitle.attributedText = attrString
                
                if let imagePath = dict["defaultImage"] as? String {
                    let imageUrl = NetworkManager.shared.baseImageURL + imagePath.replacingOccurrences(of: " ", with: "%20")
                    let url = URL(string:imageUrl )
                    cell.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
                }
                
            }else {
                cell.lblTitle.text = ""
            }
            return cell
        }
    }
}
extension RecipeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dict = self.itemArray[indexPath.row] as? NSDictionary {
            let storyboard = UIStoryboard(name: "Recipes", bundle: nil)
            let recipeDetailViewController = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
            recipeDetailViewController.info = dict
            self.navigationController?.pushViewController(recipeDetailViewController, animated: true)
            
        }
    }
}
extension RecipeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height:150)
        
    }
}
extension RecipeViewController {
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
