//
//  LoadingThings.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/30/17.
//  Copyright © 2017 Jaee. All rights reserved.
//


import UIKit

class LoadingTableView: UITableView {
    
    let loadingImage = UIImage(named: "logo")
    var loadingImageView: UIImageView
    
    required init(coder aDecoder: NSCoder) {
        loadingImageView = UIImageView(image: loadingImage)
        super.init(coder: aDecoder)!
        addSubview(loadingImageView)
        adjustSizeOfLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        loadingImageView.isHidden = false
        self.bringSubview(toFront: loadingImageView)
        
        startRefreshing()
    }
    
    func hideLoadingIndicator() {
        loadingImageView.isHidden = true
        
        stopRefreshing()
    }
    
    override func reloadData() {
        super.reloadData()
        self.bringSubview(toFront: loadingImageView)
    }
    
    // MARK: private methods
    // Adjust the size so that the indicator is always in the middle of the screen
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizeOfLoadingIndicator()
    }
    
    fileprivate func adjustSizeOfLoadingIndicator() {
        let loadingImageSize = loadingImage?.size
        loadingImageView.frame = CGRect(x: frame.width/2 - loadingImageSize!.width/2, y: frame.height/2-loadingImageSize!.height/2, width: loadingImageSize!.width, height: loadingImageSize!.height)
    }
    
    // Start the rotating animation
    fileprivate func startRefreshing() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.isRemovedOnCompletion = false
        animation.toValue = M_PI * 2.0
        animation.duration = 0.8
        animation.isCumulative = true
        animation.repeatCount = Float.infinity
        loadingImageView.layer.add(animation, forKey: "rotationAnimation")
    }
    
    // Stop the rotating animation
    fileprivate func stopRefreshing() {
        loadingImageView.layer.removeAllAnimations()
    }
}
