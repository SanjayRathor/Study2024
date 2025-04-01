//
//  UITableView.swift
//  Cloudy
//
//  Created by Bart Jacobs on 08/05/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import UIKit

protocol ReusableCell {
    
    static var reuseIdentifier: String { get }
    
}

extension ReusableCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableCell { }

extension UITableViewHeaderFooterView: ReusableCell {
    
}


extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        return cell
    }
}

extension UITableView {
    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: self.bounds.size.width-30, height: self.bounds.size.height))
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }
}

extension UICollectionView {
    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        self.isScrollEnabled = false
        self.backgroundView = label
    }
}

extension UITableView {
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


extension UIView {
    func setNoDataMessage(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width/2, height: self.bounds.size.height/2))
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        self.addSubview(label)
        label.frame = CGRect.init(x: 20, y: self.bounds.size.height/2, width: self.bounds.size.width-40, height: 100)
    }
}

