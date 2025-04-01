//
//  Model.swift
//  HelloSwiftUI
//
//  Created by Sanjay Singh Rathor on 23/02/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import Foundation
import SwiftUI
struct Model:Identifiable {
    var id = UUID()
    var name:String = ""
    var desc:String = ""
    var thumbImage:String = "error"
}

#if DEBUG
var testData  = [Model(name: "Sanjay", desc: "My Name is Sanjay"),Model(name: "Sanjay", desc: "My Name is Sanjay My Name is Sanjay My Name is SanjayMy Name is SanjayMy Name is SanjayMy Name is SanjayMy Name is SanjayMy Name is SanjayMy Name is Sanjay"),Model(name: "Sanjay", desc: "My Name is Sanjay"),Model(name: "Sanjay", desc: "My Name is Sanjay"),Model(name: "Sanjay", desc: "My Name is Sanjay"),Model(name: "Sanjay", desc: "My Name is Sanjay"),Model(name: "Sanjay", desc: "My Name is Sanjay")]
#endif

