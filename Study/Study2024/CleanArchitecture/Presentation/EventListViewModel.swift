//
//  ViewModels.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 24/09/23.
//

import Foundation
import SwiftUI

class EventListViewModel: ObservableObject {
    
    var eventUseCases = EventUseCases(repo: EventRepositoryImpl(dataSource: EventCoreDataImpl()))
    
    @Published var events: [Event] = .init()
    @Published var title = "Pet Grooming"
    @Published var description = "A day dedicated to pet grooming"
    @Published var date: Date = .init()
    
    func getEvents() {
        self.events = eventUseCases.getEvents()
    }
    
    func createEvent() {
        let newEvent = Event(title: title, description: description, date: date)
        guard let event = eventUseCases.createEvent(event: newEvent) else {
            return
        }
        
        withAnimation { events.append(event) }
        resetForm()
    }
    
    func resetForm() {
        self.title = ""
        self.description = ""
        self.date = .init()
    }
}
