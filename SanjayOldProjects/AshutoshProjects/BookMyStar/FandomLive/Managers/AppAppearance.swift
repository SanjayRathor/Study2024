

import UIKit


func applyAppAppearance() {
    
    UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.black

    
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.normal)

    let barButton = UIBarButtonItem.appearance()
    barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
    barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
    barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
    barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .selected)
    barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .focused)
    //let appearanceProxy = UINavigationBar.appearance()
    barButton.tintColor = UIColor.darkGray
}

//let ggDarkGreen = "ggDarkGreen"
//let ggGreen = "ggGreen"
//
//func applyAppAppearance() {
//  styleNavBar()
//  styleTabBar()
//  styleTabBarItem()
//  styleTintColor()
//}
//

//private func styleNavBar() {
//  let appearanceProxy = UINavigationBar.appearance()
//    if #available(iOS 11.0, *) {
//        appearanceProxy.barTintColor = UIColor(named: ggDarkGreen)
//    } else {
//        // Fallback on earlier versions
//    }
//  
//  appearanceProxy.titleTextAttributes = [
//    NSAttributedString.Key.foregroundColor: UIColor.white,
//  ]
//  
//    if #available(iOS 11.0, *) {
//        appearanceProxy.largeTitleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//        ]
//    } else {
//        // Fallback on earlier versions
//    }
//}
//
//private func styleTabBar() {
//  let appearanceProxy = UITabBar.appearance()
//    if #available(iOS 11.0, *) {
//        appearanceProxy.barTintColor = UIColor(named: ggDarkGreen)
//    } else {
//        // Fallback on earlier versions
//    }
//}
//
//private func styleTintColor() {
//  let appearanceProxy = UIView.appearance()
//    if #available(iOS 11.0, *) {
//        appearanceProxy.tintColor = UIColor(named: ggGreen)
//    } else {
//        // Fallback on earlier versions
//    }
//}
//
//private func styleTabBarItem() {
//  let appearanceProxy = UITabBarItem.appearance()
//    appearanceProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
//    if #available(iOS 11.0, *) {
//        appearanceProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: ggGreen)!], for: UIControl.State())
//    } else {
//        // Fallback on earlier versions
//    }
//}
