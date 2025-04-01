//
//  SREventSectionHeader.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 11/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SREventSectionHeader: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet override var textLabel: UILabel? {
        get { return _textLabel }
        set { _textLabel = newValue }
    }
    private var _textLabel: UILabel?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
