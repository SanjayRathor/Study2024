//
//  EventUseCases.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 24/09/23.
//

import Foundation

//protocol PayInstallmentUseCase {
//  func payInstallment(loanId:String, installmentAmount:Int, results: @escaping FetchLoanResult)
//struct EventUseCases:PayInstallmentUseCase
//}

struct EventUseCases: EventRepository {
    
    var repo: EventRepository
    func getEvents() -> [Event] {
        return repo.getEvents()
    }
    
    func createEvent(event: Event) -> Event? {
        return repo.createEvent(event: event)
    }
}
