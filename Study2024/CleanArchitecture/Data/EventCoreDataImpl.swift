//
//  EventCoreDataImpl.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 24/09/23.
//

import Foundation
import Foundation
import CoreData

struct EventCoreDataImpl: EventRepository {
    func getEvents() -> [Event] {
        return []
    }
    
    func createEvent(event: Event) -> Event? {
        return nil
    }
    
 /*   private let coreDataContext = PersistenceController.shared.context
    
    func getEvents() -> [Event] {
        let request: NSFetchRequest<EventMO> = EventMO.fetchRequest()
        do {
            let EventsMO = try coreDataContext.fetch(request)
            return EventsMO.map({ item in
                Event(
                    title: item.title ?? "",
                    description: item.desc ?? "",
                    date: item.date ?? Date()
                )
            })
            
        } catch {
          print("Error: \(error.localizedDescription)")
          return []
        }
    }
    
    func createEvent(event: Event) -> Event? {
        let newEventMO = EventMO(context: coreDataContext)
        newEventMO.title = event.title
        newEventMO.desc = event.description
        newEventMO.date = event.date
        
        do {
          try coreDataContext.save()

          return event
        } catch {
          print("Failed creating new event")
          print("Error: \(error.localizedDescription)")

          return nil
        }
    }
  */
}
