//
//  SearchViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 16/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var lastCount = 0;
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tbView: UITableView!
    var itemArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.estimatedRowHeight = 50
        tbView.keyboardDismissMode = .onDrag

        txtSearch.delegate = self
        let nibhView = UINib(nibName: "searchTableViewCell", bundle: nil)
        self.tbView.register(nibhView, forCellReuseIdentifier: "searchTableViewCell")
        self.tbView.delegate = self
        self.tbView.dataSource = self
        txtSearch.becomeFirstResponder()
        self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    func setPlacehoder() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "SegoeUI-SemiLightItalic", size: 15)! // Note the !
        ]
        txtSearch.attributedPlaceholder = NSAttributedString(string: "search", attributes:attributes)
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        txtSearch.resignFirstResponder()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let countTxt = textField.text?.count {
            if countTxt == 0 {
                lastCount = 0
                self.itemArray.removeAllObjects()
                self.tbView.reloadData()
            }
            if countTxt > 2 {
                var diff = countTxt - lastCount
                if diff < 0 {
                    diff = -diff;
                }
                if diff == 3 {
                    lastCount = countTxt
                    self.fetchSerachInformation(isLoder: false)
                }
            }
        }
    }
    func fetchSerachInformation(isLoder:Bool) {
        if var seach = self.txtSearch.text {
            if seach.isEmpty {
                alert(Constants.appName, message: "Please enter some text", view: self)
                return
            }
            seach =  seach.replacingOccurrences(of: " ", with: "%20")
            let  requestPath =  "\(Constants.getProducts)?query=\(seach)&autoComplete=true"
            NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:isLoder) { (value, status) in
                switch status {
                case .success:
                    if let valueData  = value as? NSDictionary {
                        if let success = valueData["success"] as? Int {
                            if success == 1 {
                                self.itemArray.removeAllObjects()
                                if let data = valueData["data"]  as? NSDictionary {
                                    if let foundProducts  = data["productNames"]  as? NSArray {
                                        self.itemArray.addObjects(from: foundProducts as! [Any])
                                    }
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
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.fetchSerachInformation(isLoder: false)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length == 1 && newString == " " {
            return false
        }
        return true
    }
}
extension SearchViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : searchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! searchTableViewCell
        if let dict = self.itemArray[indexPath.row] as? NSDictionary {
            if let ss = dict["title"] as? String {
                cell.infoLbl.text = ss
            }else {
                cell.infoLbl.text = dict["name"] as? String
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = self.itemArray[indexPath.row] as? NSDictionary {
            var idCat = ""
            var catName = ""
            var catType = 1
            if let type = dict["type"] as? String {
                if type == "product" {
                    catType = 1
                }else {
                    catType = 2
                }
            }
            if let ss = dict["title"] as? String {
                catName = ss
            }else {
                catName = dict["name"] as? String ?? ""
            }
            if let _id = dict["_id"] as? String {
                idCat = _id;
            }
            if idCat != "" {
                if catType == 1 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let productDetilsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetilsVC") as! ProductDetilsVC
                    productDetilsVC.productId = idCat
                    self.navigationController?.pushViewController(productDetilsVC, animated: true)
                }else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                    categoryViewController.categoryID = idCat
                    categoryViewController.categoryType = catType
                    categoryViewController.catName = catName
                    self.navigationController?.pushViewController(categoryViewController, animated: true)
                }
            }
        }
    }
}

extension SearchViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
