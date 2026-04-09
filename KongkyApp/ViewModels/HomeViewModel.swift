//
//  HomeViewModel.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = true
    
    private let eventService: EventServiceProtocol
    
    // ---------------------------------------------------------
    // DEPENDENCY INJECTION via initializer
    // ---------------------------------------------------------
    // Default value = EventService() → uses real Firebase
    // You can also pass in a mock: HomeViewModel(eventService: MockEventService())
    // ---------------------------------------------------------
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
        fetchEvents()
    }
    
    // ---------------------------------------------------------
    // READ
    // ---------------------------------------------------------
    func fetchEvents() {
        eventService.fetchEvents { [weak self] events in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.events = events
            }
        }
    }
    
    // ---------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------
    func addEvent(event: Event) {
        eventService.addEvent(event)
    }
    
    // ---------------------------------------------------------
    // UPDATE
    // ---------------------------------------------------------
    func updateEvent(event: Event) {
        eventService.updateEvent(event)
    }
    
    // ---------------------------------------------------------
    // DELETE
    // ---------------------------------------------------------
    func deleteEvent(event: Event) {
        eventService.deleteEvent(event)
    }
    
    // ---------------------------------------------------------
    // DUMMY DATA
    // ---------------------------------------------------------
    func loadDummyData() {
        self.isLoading = true
        
        let event1 = Event(id: "dummy1", title: "Board Game DND", description: "The most unforgettable night you could have...", location: "Thamrin Nine Pantry", date: "Jun 16", time: "19:00 - 21:00", cost: 20000, organizerName: "Christoffer Wong", category: "Board Game", timeframe: "This Week", maxCapacity: 5, participants: (0..<8).map { EventParticipant(email: "user\($0)@test.com", name: "User \($0)") })
        let event2 = Event(id: "dummy2", title: "Sunday Morning Futsal", description: "Let's sweat it out this weekend!", location: "Kuningan Arena", date: "Jun 18", time: "08:00 - 10:00", cost: 50000, organizerName: "Alex", savedBy: ["user@test.com"], category: "Sport", timeframe: "Next Week", maxCapacity: 10, participants: (0..<3).map { EventParticipant(email: "user\($0)@test.com", name: "User \($0)") })
        let event3 = Event(id: "dummy3", title: "Iftar Gathering", description: "Lunch together at the famous local spot.", location: "Sederhana Sudirman", date: "Jun 20", time: "16:00 - 19:00", cost: 35000, organizerName: "Dimas Daffa", category: "Share Meal", timeframe: "Completed", maxCapacity: 4, participants: (0..<4).map { EventParticipant(email: "user\($0)@test.com", name: "User \($0)") })
        let event4 = Event(id: "dummy4", title: "Monday Supper", description: "Lunch together at the famous local spot.", location: "Sederhana Sudirman", date: "Jun 16", time: "12:00 - 13:00", cost: 35000, organizerName: "Dimas Daffa", category: "Other", timeframe: "This Week", maxCapacity: 4, participants: (0..<4).map { EventParticipant(email: "user\($0)@test.com", name: "User \($0)") })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.events.isEmpty {
                self.events = [event1, event2, event3, event4]
            }
            self.isLoading = false
        }
    }
}
