//
//  LoginViewModel.swift
//  SwiftUIApplication
//
//  Created by Sanjay Singh Rathor on 10/11/20.
//

import Foundation
import SwiftUI
import Combine

class LoginViewModel : ObservableObject {
    let willChanage  = PassthroughSubject<Void, Never>()
    
    var userName:String = ""
    var password:String = ""
    
}

extension LoginViewModel {
    func login() {
        
    }
}


