//
//  Meals.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/28/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation


class Meals {
    
    
    private var _meal_id: String?
    private var _logo : String?
    private var _meal_name : String?
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
    var Logo : String{
        return _logo!
    }
    
    
    init(meal_id : String , Logo : String , meal_name : String , price : String) {
        
        self._meal_name = meal_name
        self._logo = Logo
        self._meal_id = meal_id
        self._price = price
        
    }
    
    
    
    
}
