//
//  Cart.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/1/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation

class Cart {
    
    
    private var _meal_id: String?
    private var _meal_name : String?
    private var _qty : String?
    private var _price : String?
    
    
    
    
    var meal_id : String{
        return _meal_id!
    }
    var price : String{
        return _price!
    }
    
    var meal_name : String{
        return _meal_name!
        
        
    }
    var qty : String{
        return _qty!
    }
    
    
    init(meal_id : String , qty : String , meal_name : String , price : String) {
        
        self._meal_name = meal_name
        self._qty = qty
        self._meal_id = meal_id
        self._price = price
        
    }
    

    
}
