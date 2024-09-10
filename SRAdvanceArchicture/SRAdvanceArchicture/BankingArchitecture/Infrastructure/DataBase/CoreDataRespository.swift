//
//  CoreDataRespository.swift
//  SRAdvanceArchicture
//
//  Created by Sanjay Rathor on 14/04/24.
//

import Foundation
import UIKit

protocol CoreDataRespository {
   func getDataFromDataBase() ->String
}

class CoreDataBase:CoreDataRespository {
    func getDataFromDataBase() -> String {
        return "This is the data from the database!!!"
    }
}
