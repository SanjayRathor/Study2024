//
//  TeamsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 24/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

protocol TeamsViewControllerDelegate: class {
    func teamButtonTapped(teamId: Int, teamName: String, imageURL: String, teamType:Int)
}

class TeamsViewController: UIViewController {
    var delegate: TeamsViewControllerDelegate?
    
    var teams:[AnyObject]?
    var teamType:Int = 0;
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        //self.tableView.register(PickerTableViewCell.self, forCellReuseIdentifier: "PickerTableViewCell")
    }
    
}

extension TeamsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
        cell.backgroundColor = UIColor.clear
        
        if let followed = teams?[indexPath.row]  as? Team {
            cell.name.text = followed.name
            let url = URL(string: (followed.teamLogo))
            cell.thumb.kf.setImage(with: url, placeholder:UIImage.init(named: "team"))
            
        }
        
        if let followed = teams?[indexPath.row]  as? Followed {
            cell.name.text = followed.name
            let url = URL(string: (followed.imagePath ?? ""))
            cell.thumb.kf.setImage(with: url, placeholder:UIImage.init(named: "team"))
            
        }
    
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        if let followed = teams?[indexPath.row] as? Team {
            self.delegate?.teamButtonTapped(teamId: followed.id, teamName: followed.name, imageURL: followed.teamLogo, teamType: teamType)
            
        }
        
        if let followed = teams?[indexPath.row] as? Followed {
            self.delegate?.teamButtonTapped(teamId: followed.id, teamName: followed.name, imageURL: followed.imagePath ?? "", teamType: teamType)
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

