//
//  KPConstant.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 11/16/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation

let googleKey = "AIzaSyB19VfnnSKwLQ-qJ7tjuO3w6qymk3ZpfxE"

/// If google key is empty than location fetch via goecode.
var isGooleKeyFound : Bool = {
    return !googleKey.isEmpty
}()
