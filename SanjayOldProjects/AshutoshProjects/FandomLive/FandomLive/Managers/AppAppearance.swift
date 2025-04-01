

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
    barButton.tintColor = UIColor.white
    
    UINavigationBar.appearance().titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont(name: "Atami-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)]
            
    UITabBarItem.appearance().setTitleTextAttributes(
        [NSAttributedString.Key.font: UIFont(name: "Atami", size: 11)!], for: .normal)

    UITabBarItem.appearance().setTitleTextAttributes(
        [NSAttributedString.Key.font: UIFont(name: "Atami", size: 11)!], for: .selected)
    
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = false
    
    let yourBackImage = UIImage(named: "backButtonImage")
    UINavigationBar.appearance().backIndicatorImage = yourBackImage
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = yourBackImage
    FandomGradient().setGradientColorOnNavigationBar(bar: UINavigationBar.appearance(), direction: .horizontal)
    
   
}

