//
//  EventServiceProtocol.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import Foundation

protocol EventServiceProtocol {
    
    /// Fetch all events from the database in real-time.
    /// The completion handler fires every time data changes.
    func fetchEvents(completion: @escaping ([Event]) -> Void)
    
    /// Add a new event to the database.
    func addEvent(_ event: Event)
    
    /// Update an existing event in the database.
    func updateEvent(_ event: Event)
    
    /// Delete an event from the database.
    func deleteEvent(_ event: Event)
}
