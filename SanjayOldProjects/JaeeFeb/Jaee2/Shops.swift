//
//  Shops.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/28/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation

class Shops {
    private var _familiy_id: String?
    private var _logo : String?
    private var _design: String?
    private var _rate : Int
    private var _shopname : String?
    private var _time : String?
    private var _cat : String?

    var cat : String{
        return _cat!
    }
    var time : String{
        return _time!
    }
    var rate : Int{
        return _rate
    }
    var familiy_id : String{
        return _familiy_id!
    }
    
       var shopname : String{
        return _shopname!
    }
    var Logo : String{
        return _logo!
    }
    
    var design : String {
        return _design!
    }
    
    init(shopname : String , Logo : String , family_id : String, design : String , rate : Int , time : String , cat : String) {
        
        self._shopname = shopname
               self._logo = Logo
        self._familiy_id = family_id
        self._design = design
        self._rate = rate
        self._cat = cat 
        self._time = time
    }
    
}
