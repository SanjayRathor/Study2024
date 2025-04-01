//
//  Previous.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/6/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation
class Previous {

private var _order_id: String?
private var _shop_name : String?
private var _total : String?
private var _logo : String?



var order_id : String{
    return _order_id!
}


var shop_name : String{
    return _shop_name!
    
    
}


    var logo : String{
        return _logo!
    }
    init(order_id : String  , shop_name : String ,   logo : String) {
    
    self._order_id = order_id
    self._shop_name = shop_name
        self._logo = logo 
}
}

