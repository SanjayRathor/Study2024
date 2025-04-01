//
//  CheckOutGridCell.swift
//  TamimiEcom
//
//  Created by Ansh on 10/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
protocol ClickInformationCheckOutGrid:class {
    func clickIndex(indx:Int,cellType:Int,slot:String)
}
class CheckOutGridCell: UICollectionViewCell {
    @IBOutlet weak var lblNoSlotInfo: UILabel!
    weak var delegate:ClickInformationCheckOutGrid?
    var selectedInx = 0
    var cellType = 0
    var infoArray = NSArray.init()
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ctView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.infoArray = NSArray.init()
        self.registerNib()
        ctView.delegate = self
        ctView.dataSource = self
        
    }
    func loadData() {
        if cellType == 0 {
            self.lblNoSlotInfo.isHidden = true
            self.lblNoSlotInfo.text = "Please select strore location"

        }else {
            self.lblNoSlotInfo.text = "Slot is not available, Please select another date"
        }
        self.lblNoSlotInfo.isHidden =  self.infoArray.count == 0 ? false : true
        self.ctView.reloadData()
    }
    func registerNib() {
        let nibCategory = UINib(nibName: "CheckInfoCell", bundle: nil)
        self.ctView.register(nibCategory, forCellWithReuseIdentifier: "CheckInfoCell")
    }
}
//MARK: UICollectionViewDataSource
extension CheckOutGridCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CheckInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckInfoCell", for: indexPath as IndexPath) as! CheckInfoCell
        if cellType == 0 {
            cell.titleLbl.alpha = 1.0;
            if let dict  = self.infoArray.object(at: indexPath.row) as? NSDictionary {
                if let date = dict["date"] as? String {
                cell.titleLbl.text = self.dateType(dateValue: date)
                }
            }
        } else {
            if let dict  = self.infoArray.object(at: indexPath.row) as? NSDictionary {
                cell.titleLbl.alpha = 1.0;
                cell.titleLbl.text = dict["time"] as? String
                if let isBooked = dict["isBooked"] as? Bool {
                    if isBooked  {
                        cell.titleLbl.alpha = 0.5;
                    }
                }
            }
        }
        print(self.selectedInx);
        if indexPath.row == self.selectedInx {
            cell.titleLbl.layer.borderWidth = 0.0;
            cell.backgroundColor = UIColor(displayP3Red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            cell.layer.cornerRadius = 3.0;
            cell.titleLbl.textColor = UIColor.white
        }else {
            cell.titleLbl.layer.borderWidth = 1.0;
            cell.titleLbl.layer.borderColor = UIColor(displayP3Red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0).cgColor
            cell.layer.cornerRadius = 3.0;
            cell.backgroundColor = UIColor.white
            cell.titleLbl.textColor = UIColor(displayP3Red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0)
            
        }
        return cell
    }
    func dateType(dateValue:String) -> String {
        
    let cal = NSCalendar.current
    // start with today
    var date = cal.startOfDay(for: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
        var stringDate = dateFormatter.string(from: date)
        // move back in time by one day:
        if dateValue == stringDate{
            return  "Today"
        }

        date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!
        
         stringDate = dateFormatter.string(from: date)

        if dateValue == stringDate{
            return  "Tomorrow"
        }
        if let  date = dateFormatter.date(from: dateValue) {
            dateFormatter.dateFormat = "EEE, MMM  dd'\(self.dateST(date: date))'"
           return dateFormatter.string(from: date)
        }
        return "....."
    
    }
    func dateST(date:Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        switch day {
        case 11...13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}
extension CheckOutGridCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cellType == 0 {
            self.selectedInx = indexPath.row
            self.loadData()
            self.delegate?.clickIndex(indx: self.selectedInx,cellType:self.cellType,slot: "")
        }else {
            if let dict  = self.infoArray.object(at: indexPath.row) as? NSDictionary {
                if let isBooked = dict["isBooked"] as? Bool {
                    if !isBooked  {
                        self.selectedInx = indexPath.row
                        self.loadData()
                        self.delegate?.clickIndex(indx:
                                                    self.selectedInx,cellType:self.cellType,slot: dict["time"] as? String ?? "")
                    }else {
                        self.delegate?.clickIndex(indx:
                            -1,cellType:self.cellType,slot: "")
                    }
                }
            }
        }
    }
}
extension CheckOutGridCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellType == 0 {
            return CGSize(width: 110 , height:30)
        }else {
            return CGSize(width: 140 , height:30)
        }
        
    }
}

