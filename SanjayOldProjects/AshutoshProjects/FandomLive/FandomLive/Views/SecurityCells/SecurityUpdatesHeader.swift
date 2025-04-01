//
//  SREventSectionHeader.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 11/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SecurityUpdatesHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var colorCircle: UIView!
    static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet override var textLabel: UILabel? {
        get { return _textLabel }
        set {
            _textLabel = newValue
            updateCircle()
        }
    }
    private var _textLabel: UILabel?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateCircle(){
        let number = Int.random(in: 0 ..< 5)
        switch number {
        case 0:
            colorCircle.backgroundColor = UIColor.init(red: 253, green: 122, blue: 202)
            break
        case 1:
            colorCircle.backgroundColor = UIColor.init(red: 123, green: 216, blue: 253)
            break
        case 2:
            colorCircle.backgroundColor = UIColor.init(red: 187, green: 124, blue: 252)
            break
        case 3:
            colorCircle.backgroundColor = UIColor.init(red: 255, green: 208, blue: 84)
            break
        case 4:
            colorCircle.backgroundColor = UIColor.init(red: 253, green: 177, blue: 124)
            break
            
        default:
            colorCircle.backgroundColor = UIColor.init(red: 237, green: 240, blue: 252)
            break
            
        }
        
    }
}
