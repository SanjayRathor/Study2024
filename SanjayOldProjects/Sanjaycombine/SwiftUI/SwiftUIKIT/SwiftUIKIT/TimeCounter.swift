//
//  TimeCounter.swift
//  SwitUIApp
//
//  Created by Sanjay Singh Rathor on 31/10/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import Foundation
import Combine

class TimeCounter: ObservableObject {
    let objectWillChange = PassthroughSubject<TimeCounter, Never>()
    var timer: Timer?
    var counter = 0
    
    init() {
        timer = Timer.scheduledTimer(timeInterval:1, target: self, selector:#selector(updateCounter), userInfo: nil, repeats:true)
    }
    
    @objc func updateCounter() {
        counter += 1
        objectWillChange.send(self)
        
    }
    
    func killTimer() {
        timer?.invalidate()
        timer = nil
    }    
    
}
