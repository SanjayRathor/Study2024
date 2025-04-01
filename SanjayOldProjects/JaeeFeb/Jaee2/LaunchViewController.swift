//
//  LaunchViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/9/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Permission
import CoreLocation
import RQShineLabel
import ViewAnimator
import WhatsNew
import SwiftVideoBackground

class LaunchViewController:  UIViewController {
    


    @IBOutlet weak var backgroundVideo: BackgroundVideo!
    
    
    
    
    
    
    var shineLabel = RQShineLabel()
    var timer = Timer()
    var textArray = ["آهلا بك في جاي، تو مانور التطبيق", "جمعنا لك كل المتاجر والمطاعم في مكان واحد. كل الي تبية وآكثر تحصلة هندنا","Welcome to Jaee :)"]
    var currentCount = 0
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // whats new
       
        // whats new
        
        
        //
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        backgroundVideo.frame = CGRect(x:0, y:0, width: width, height: height)
        backgroundVideo.createBackgroundVideo(name: "Jaee", type: "mp4", alpha: 0.3)
        //
        self.shineLabel = RQShineLabel(frame: CGRect(x: 16, y: 16, width: 298, height: 300))
        self.shineLabel.numberOfLines = 0;
        self.shineLabel.text = "هلا هلا هلا "
        self.shineLabel.backgroundColor = UIColor.clear
        self.shineLabel.font = UIFont(name: "DIN Bold", size: 29.0)
        self.shineLabel.center = self.view.center;
        self.view.addSubview(self.shineLabel)
        scheduledTimerWithTimeInterval()

        whatsNewPop()

    }
    
    func whatsNewPop()  {
        
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if WhatsNew.shouldPresent() {
            let whatsNew = WhatsNewViewController(items: [
                WhatsNewItem.image(title: "اطلب آي شيء من آي مكان", subtitle: "الآن تقدر تطلب من المنتجات الغير متواجدة في التطبيق فقط اضغط على إضافة منتج", image: #imageLiteral(resourceName: "lgoJaee")),
                WhatsNewItem.image(title: "تصنيف المتاجر حسب الطلب الآكثر", subtitle: "ترتيب المتاجر في التطبيق يعتمد على شهرة المحل. يعني الآول هو الآفضل 😎", image: #imageLiteral(resourceName: "lgoJaee")),
                WhatsNewItem.image(title: "آقسام غير الآكل", subtitle: "تطبيق جاي الآن يوصل لك من البقالة آو الصيدلية.. او حتى محلات الملابس", image: #imageLiteral(resourceName: "lgoJaee")),
                WhatsNewItem.text(title: "تابعنا على التواصل الآجتماعي", subtitle: "إذا تبي تعرف الجديد تابعنا علي الإنستقرام وتويتر @GetJaee"),
                ])
            whatsNew.titleText = "وش الجديد في جاي"
            whatsNew.itemSubtitleColor = .darkGray
            whatsNew.buttonText = "متابعة"
            whatsNew.presentationOption = .majorVersion
            present(whatsNew, animated: true, completion: nil)
        }
    

        
 
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "name")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        
        self.shineLabel.shine()

        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
        }else{
            let controller = UIAlertController(title: "  التطبيق يتطلب انترنت 😁", message: "بعد اذنك نبي انترنت علشان نشغل لك التطبيق. تآكد من الواي فاي واتصال الشبكه لا هنت", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "تاكد", style: .cancel, handler: nil)
            
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
  

    @IBAction func tomainTapped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            
            self.performSegue(withIdentifier: "tomain", sender: self)
        }else{
            let controller = UIAlertController(title: "  التطبيق يتطلب انترنت 😁", message: "بعد اذنك نبي انترنت علشان نشغل لك التطبيق. تآكد من الواي فاي واتصال الشبكه لا هنت", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "متاكد", style: .cancel, handler: nil)
            
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
            view.animateRandom()

        }
        
        
        
    }
    @objc func updateCounting(){
        if (self.shineLabel.isVisible) {
            self.shineLabel.fadeOut(completion: {
                let textIndex = self.currentCount % self.textArray.count
                let text = self.textArray[textIndex]
                self.shineLabel.text = text
                self.currentCount += 1
               
                })
                self.shineLabel.shine()
            
        } else {
            self.shineLabel.shine()
        }
        
    }
    
    
    @IBAction func screenTapped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
           
            self.performSegue(withIdentifier: "tomain", sender: self)
        }else{
            let controller = UIAlertController(title: "  التطبيق يتطلب انترنت 😁", message: "بعد اذنك نبي انترنت علشان نشغل لك التطبيق. تآكد من الواي فاي واتصال الشبكه لا هنت", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "متاكد", style: .cancel, handler: nil)
            
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
            view.animateRandom()
            
        }
        
        
        
    }
  
    
}



