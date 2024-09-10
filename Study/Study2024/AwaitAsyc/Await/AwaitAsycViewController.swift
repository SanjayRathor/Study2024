//
//  AwaitAsycViewController.swift
//  Study2024
//
//  Created by Sanjay Rathor on 20/07/24.
//

import UIKit
import SwiftUI
import Combine

class AwaitAsycViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let kNotesTableViewCell = "NotesTableViewCell"
    var items = [String]()
    var vm = EntryController()
    var cancellable: AnyCancellable?
    public  let nameNotification = Notification.Name("nextNumberNotification")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .singleLine
        let nib = UINib.init(nibName: "NotesTableViewCell", bundle: .main)
        self.tableView.register(nib, forCellReuseIdentifier: kNotesTableViewCell)
        self.tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        cancellable =  vm.$entries
            .receive(on: DispatchQueue.main)
            .sink { newValue in
                self.items.removeAll()
                newValue.forEach { entry in
                    self.items.append(entry.imageName)
                    
                }
                print("Item Count1 => \(newValue.count)")
                print("Item Count => \(self.items.count)")
                self.tableView.reloadData()
            }
        
        receiver()
    }
    
    @IBAction func addDidClicked(_ sender: Any) {
        //vm.next()
        NotificationCenter.default.post(name: nameNotification, object: nil, userInfo: ["name" : "Sanjay"])
    }
    
}
extension AwaitAsycViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
extension AwaitAsycViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kNotesTableViewCell, for: indexPath) as? NotesTableViewCell else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        let item = items[indexPath.row]
        let image = UIImage(systemName: item)
        cell.notesTitleLabel.text = " Image- \(indexPath.row)  "
        
        
        cell.tumbImageView.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
    }
    
    func receiver() {
        if #available(iOS 15, *) {
            let entries = NotificationCenter.default.notifications(named: nameNotification, object: nil)
                .compactMap(\.userInfo)
                .compactMap {userInfo in
                    print("\(userInfo)")
                }
        } else {
            // Fallback on earlier versions
        }
    }
    
}
