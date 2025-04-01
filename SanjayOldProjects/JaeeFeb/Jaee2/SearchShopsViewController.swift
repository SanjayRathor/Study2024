import UIKit
import Haneke

class SearchShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate , CustomSearchControllerDelegate  {
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    var dataArray = [Shops]()
    var filteredArray = [Shops]()
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    
    override func viewWillAppear(_ animated: Bool) {
   
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
//        loadListOfCountries()
        
        configureCustomSearchController()
    }
    

    // MARK: UITableView Delegate and Datasource functions
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if shouldShowSearchResults {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchShopsTableViewCell
            // set up cells for this view
            let entry = filteredArray[indexPath.row]
            cell.shopName.text = entry.shopname
            print("\(entry.shopname)")
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchShopsTableViewCell
            // set up cells for this view
            let entry = dataArray[indexPath.row]
            
            cell.shopName.text = entry.shopname
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            return cell

            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85.0
    }
    
    
    // MARK: Custom functions
    
//    func loadListOfCountries() {
//
//        let pathToFile = Bundle.main.path(forResource: "countries", ofType: "txt")
//        if let path = pathToFile {
//
//            let countriesString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
//            dataArray = countriesString.components(separatedBy: "\n")
//            tblSearchResults.reloadData()
//        }
//    }
    
    func configureCustomSearchController() {
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tblSearchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.white , searchBarTintColor: UIColor.black)
        
        customSearchController.customSearchBar.placeholder = "Search .. "
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        customSearchController.searchBar.keyboardAppearance = .dark
        customSearchController.customDelegate = self
//
//        addKeyboardButton()
//
//        customSearchController.definesPresentationContext = true
//        customSearchController.isActive = true
        customSearchController.searchBar.becomeFirstResponder()
    }
    
    func addKeyboardButton() {
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.barTintColor = UIColor.black
        
        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: keyboardToolbar.frame.size.width / 2, y: keyboardToolbar.frame.size.height / 2, width: 50, height: 30)
        addButton.addTarget(self, action: #selector(clickMe), for: .touchUpInside)
        let item = UIBarButtonItem(customView: addButton)
        keyboardToolbar.items = [item]
        
        customSearchController.searchBar.inputAccessoryView = keyboardToolbar
    }
    
    @objc func clickMe() {
        
        print("Clicked")
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        print("delegate")
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
//    func didChangeSearchText(_ searchText: String) {
//
//        filteredArray = dataArray.filter({ (country) -> Bool in
//            let countryText: NSString = country as NSString
//
//            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//        })
//
//        tblSearchResults.reloadData()
//    }
    
  
    
    
    func didChangeSearchText(_ searchText: String) {
        filteredArray = dataArray.filter { $0.shopname.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil}

        
        tblSearchResults.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if shouldShowSearchResults {
            
            let meal1 =  filteredArray[indexPath.row]
            guard (filteredArray.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
        } else {
            
            let meal1 =  dataArray[indexPath.row]
            guard (dataArray.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
            
        }
      
    }
    
   
    
    
}


