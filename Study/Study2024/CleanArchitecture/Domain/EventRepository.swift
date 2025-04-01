//
//  EventRepository.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 24/09/23.
//

import Foundation
protocol EventRepository{
    func getEvents() -> [Event]
    func createEvent(event: Event) -> Event?
}
