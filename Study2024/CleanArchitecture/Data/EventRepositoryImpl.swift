//
//  EventRepositoryImpl.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 24/09/23.
//

import Foundation

struct EventRepositoryImpl: EventRepository{
    var dataSource: EventRepository
    func getEvents() -> [Event] {
        return dataSource.getEvents()
    }
    
    func createEvent(event: Event) -> Event? {
        return dataSource.createEvent(event: event)
    }
    
}
