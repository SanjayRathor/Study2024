//
//  SettingViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/27/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tableFooterView: UIView?

    /// A simple data structure to populate the table view.
    struct PreviewDetail {
        let title: String
        let preferredHeight: Double
    }
    
    let sampleData = [
        PreviewDetail(title: "الملف الشخصي", preferredHeight: 160.0),
        PreviewDetail(title: "الطلبات السابقة", preferredHeight: 320.0),
        PreviewDetail(title: "تغير كلمة المرور", preferredHeight: 0.0), // 0.0 to get the default height.
        PreviewDetail(title: "عن التطبيق", preferredHeight: 160.0),
        PreviewDetail(title: "الدعم", preferredHeight: 320.0),
        PreviewDetail(title: "مشاركة التطبيق", preferredHeight: 320.0),
        
        PreviewDetail(title: "تسجيل الخروج", preferredHeight: 0.0), // 0.0 to get the default height.
    ]
    
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = nil


        // Do any additional setup after loading the view, typically from a nib.
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()  // it's just 1 line, awesome!

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
     
      

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
   
        
        return sampleData.count
        
    }
    
    @objc func registerDriver(sender: UIButton!) {
        
        performSegue(withIdentifier: "support", sender: self)
        print("Hello");
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section == 0 else { return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
        let DoneBut: UIButton = UIButton(frame: CGRect(10, 10, 300, 44))
        DoneBut.setTitle("تسجيل كمندوب؟", for: [])
        DoneBut.backgroundColor = UIColor.lightGray
        DoneBut.cornerRadius = 10
        DoneBut.center = footerView.center

        DoneBut.shadow = true
        DoneBut.addTarget(self, action:#selector(registerDriver(sender:)), for: .touchUpInside)
        footerView.addSubview(DoneBut)
        return footerView;
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func myAction(_ sender : AnyObject) {
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
 
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            
            let previewDetail = sampleData[indexPath.row]
            cell!.textLabel!.text = previewDetail.title
            cell!.textLabel?.textAlignment = .right
            
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)!
        
        
        
        if currentCell.textLabel!.text == "الملف الشخصي" {
            print("go to الملف الشخصي")
            UserDataSingleton.sharedDataContainer.previous = nil
            performSegue(withIdentifier: "personal", sender: self)

        } else {
        
                if currentCell.textLabel!.text == "مشاركة التطبيق" {
                    print("go to  ")
                    
                    let activityVC = UIActivityViewController(activityItems: ["هذا تطبيق جاي افضل تطبيق توصيل عرفناة، جرب استخدمه وماراح تندم ابدااا https://itunes.apple.com/us/app/جاي/id1191494032?ls=1&mt=8"], applicationActivities: nil)
                    
                    activityVC.popoverPresentationController?.sourceView = self.view
                    
                    self.present(activityVC, animated: true, completion: nil)
                  
                }
            if currentCell.textLabel!.text == "الطلبات السابقة" {
                print("go to الطلبات السابقة")
                UserDataSingleton.sharedDataContainer.previous = nil
                performSegue(withIdentifier: "previous", sender: self)
            } else {
                if currentCell.textLabel!.text == "تغير كلمة المرور" {
                    print("go to تغير كلمة المرور")
                    UserDataSingleton.sharedDataContainer.previous = nil
                    performSegue(withIdentifier: "password", sender: self)

                }else {
                    if currentCell.textLabel!.text == "عن التطبيق" {
                        UserDataSingleton.sharedDataContainer.previous = nil
                        performSegue(withIdentifier: "about", sender: self)

                        print("go toعن التطبيق ")
                    } else {
                        UserDataSingleton.sharedDataContainer.previous = nil
                        if currentCell.textLabel!.text == "الدعم" {
                            UserDataSingleton.sharedDataContainer.previous = nil
                            performSegue(withIdentifier: "support", sender: self)

                            print("go to الدعم")
                        } else {
                            UserDataSingleton.sharedDataContainer.previous = nil
                            if currentCell.textLabel!.text == "تسجيل الخروج" {
                                print("go to اتسجيل الخروجة")
                                
                                let alert = UIAlertController(title: "تسجيل خروج", message: "متاكد؟", preferredStyle: .alert)
                                
                                let action = UIAlertAction(title: "متاكد", style: .default, handler: { action in
                                    
                                    UserDataSingleton.sharedDataContainer.is_guest = "guest"
                                    UserDataSingleton.sharedDataContainer.user_id = ""
                                    
                                    self.performSegue(withIdentifier: "welcome", sender: self)
                                    
                                    })
                                
                                
                                let stay = UIAlertAction(title: "لا", style: .cancel, handler: nil)
                                alert.addAction(action)
                                alert.addAction(stay)
                                
                                self.present(alert, animated: true, completion: nil)

                                
                                
                                
                                
                            }
                        }
                    }


        }
}

}
}
   
    @IBAction func dismissTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    }

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
