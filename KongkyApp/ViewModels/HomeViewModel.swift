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
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadDummyData()
            self.isLoading = false
        }
    }
    
    func loadDummyData() {
        let event1 = Event(
            title: "Board Game DND",
            description: "The most unforgettable night you could have in your life is available on Thamrin Nine. From party to strategic game, experience the whole new excitement, carefully handled by us, Jr. Learners",
            location: "Thamrin Nine Pantry",
            date: "Jun 16",
            time: "19:00 - 21:00",
            cost: 20000,
            organizerName: "Christoffer Wong",
            category: "Board Game",
            timeframe: "This Week",
            maxCapacity: 5,
            joinedParticipants: 8,
        )
        
        let event2 = Event(
            title: "Sunday Morning Futsal",
            description: "Let's sweat it out this weekend!",
            location: "Kuningan Arena",
            date: "Jun 24",
            time: "08:00 - 10:00",
            cost: 50000,
            organizerName: "Budi Santoso",
            category: "Sport",
            timeframe: "Next Week",
            maxCapacity: 5,
            joinedParticipants: 8,
        )
        
        let event3 = Event(
            title: "Iftar Gathering",
            description: "Lunch together at the famous local spot.",
            location: "Sederhana Sudirman",
            date: "Jun 02",
            time: "16:00 - 19:00",
            cost: 35000,
            organizerName: "Dimas Daffa",
            category: "Share Meal",
            timeframe: "Completed",
            maxCapacity: 30,
            joinedParticipants: 8
        )
        
        let event4 = Event(
            title: "Pantry Tea Time",
            description: "Chill afternoon catch-up over tea and snacks. Everyone welcome!",
            location: "Common Room, Floor 3",
            date: "Jun 28",
            time: "15:00 - 18:00",
            cost: 15000,
            organizerName: "Alex Margarita",
            category: "Tea Time",
            timeframe: "This Week",
            maxCapacity: 8,
            joinedParticipants: 3
        )

        self.events = [event1, event2, event3, event4]
        
    }
}
