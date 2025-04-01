//
//  Entity.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 24/09/23.
//

import Foundation

struct Event: Identifiable {
    var id: UUID = .init()
    var title: String
    var description: String
    var date: Date
}
