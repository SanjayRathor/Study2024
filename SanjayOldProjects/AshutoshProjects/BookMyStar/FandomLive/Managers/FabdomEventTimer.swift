//
//  FabdomEventTimer.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 20/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import Foundation


struct FLEventModel {
    var daysString = ""
    var hourString = ""
    var menutesString = ""
    var secondsString = ""
    
    init(days:String, hour:String, menutes:String, seconds:String) {
        daysString = days
        hourString = hour
        menutesString = menutes
        secondsString = seconds
    }
}


class FabdomEventTimer {
    
    public var didTimeUpdateCallback: ((FLEventModel)->())?
    
    var timeEnd : Date?
    var  timer:Timer?
    convenience init?(eventDate:String) {
        self.init()
        timeEnd = Date(timeInterval: eventDate.toDate(format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince(Date()), since: Date())
        
         let notificationCenter = NotificationCenter.default
           notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
          notificationCenter.addObserver(self, selector: #selector(appMovedToforeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        updateView()
        
    }
    deinit {
        self.releaseTimer()
        
    }
    
    func updateView() {
        setTimeLeft()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setTimeLeft), userInfo: nil, repeats: true)
    }
    
    @objc func setTimeLeft() {
        let timeNow = Date()
        
        if timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
            let interval = timeEnd?.timeIntervalSince(timeNow)
            let days =  (interval! / (60*60*24)).rounded(.down)
            let daysRemainder = interval?.truncatingRemainder(dividingBy: 60*60*24)
            let hours = (daysRemainder! / (60 * 60)).rounded(.down)
            let hoursRemainder = daysRemainder?.truncatingRemainder(dividingBy: 60 * 60).rounded(.down)
            let minites  = (hoursRemainder! / 60).rounded(.down)
            let minitesRemainder = hoursRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            let scondes = minitesRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 2
            
            let daysString = formatter.string(from: NSNumber(value:days))!
            let hourString = formatter.string(from: NSNumber(value:hours))!
            let menutesString = formatter.string(from: NSNumber(value:minites))!
            let secondsString = formatter.string(from: NSNumber(value:scondes!))!
            
            didTimeUpdateCallback?(FLEventModel.init(days: daysString, hour: hourString, menutes: menutesString, seconds: secondsString))
            
        }
    }
    
    func releaseTimer () {
        if let isValid = timer?.isValid, isValid == true {
            timer?.invalidate()
            timer = nil;
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appMovedToBackground() {
        releaseTimer()
    }
    @objc func appMovedToforeground() {
        updateView()
    }
}
