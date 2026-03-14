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
    
    init() {
        loadDummyData()
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
            maxCapacity: 5,
            joinedParticipants: 8,
        )
        
        let event2 = Event(
            title: "Sunday Morning Futsal",
            description: "Let's sweat it out this weekend!",
            location: "Kuningan Arena",
            date: "Jun 18",
            time: "08:00 - 10:00",
            cost: 50000,
            organizerName: "Budi Santoso",
            category: "Sport",
            maxCapacity: 5,
            joinedParticipants: 8,
        )
        
        let event3 = Event(
            title: "Iftar Gathering",
            description: "Lunch together at the famous local spot.",
            location: "Sederhana Sudirman",
            date: "Jun 20",
            time: "16:00 - 19:00",
            cost: 35000,
            organizerName: "Dimas Daffa",
            category: "Share Meal",
            maxCapacity: 30,
            joinedParticipants: 8
        )
        
        self.events = [event1, event2, event3]
        
    }
}
