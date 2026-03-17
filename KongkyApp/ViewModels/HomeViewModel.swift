//
//  HomeViewModel.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import Foundation
import Combine
//import FirebaseFirestore
//import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = true
    
    // 1. Initialize the Firebase Database
    // private var db = Firestore.firestore()
    
    init() {
        // Load dummy data immediately so the screen isn't empty
        loadDummyData()
        
        // Then try to fetch the real data from the cloud!
        // fetchEvents()
    }
    
    // ---------------------------------------------------------
    // READ (Real-time Listener)
    // ---------------------------------------------------------
    func fetchEvents() {
        /*
        // This listens to the "activities" table in Firestore
        db.collection("activities").addSnapshotListener { (querySnapshot, error) in
            // Turn off the loading skeleton
            self.isLoading = false
            
            guard let documents = querySnapshot?.documents else {
                print("No documents or offline: \(String(describing: error))")
                return // If it fails (like no internet), the dummy data stays on screen!
            }
            
            // Convert Firebase JSON into our Swift Event structs
            let fetchedEvents = documents.compactMap { document -> Event? in
                try? document.data(as: Event.self)
            }
            
            // If we actually have data in Firebase, replace the dummy data!
            if !fetchedEvents.isEmpty {
                self.events = fetchedEvents
            }
        }
        */
    }
    
    // ---------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------
    func addEvent(event: Event) {
        /*
        do {
            // This automatically converts the Swift struct to JSON and saves it!
            let _ = try db.collection("activities").addDocument(from: event)
        } catch {
            print("Error adding event to Firebase: \(error)")
        }
        */
    }
    
    // ---------------------------------------------------------
    // UPDATE
    // ---------------------------------------------------------
    func updateEvent(event: Event) {
        /*
        let documentId = event.id
        
        do {
            try db.collection("activities").document(documentId).setData(from: event)
        } catch {
            print("Error updating event in Firebase: \(error)")
        }
        */
    }
    
    // ---------------------------------------------------------
    // DELETE
    // ---------------------------------------------------------
    func deleteEvent(event: Event) {
        /*
        let documentId = event.id
        
        db.collection("activities").document(documentId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            }
        }
        */
    }
    
    // ---------------------------------------------------------
    // DUMMY DATA
    // ---------------------------------------------------------
    func loadDummyData() {
        self.isLoading = true
        
        let event1 = Event(id: "dummy1", title: "Board Game DND", description: "The most unforgettable night you could have...", location: "Thamrin Nine Pantry", date: "Jun 16", time: "19:00 - 21:00", cost: 20000, organizerName: "Christoffer Wong", category: "Board Game", timeframe: "This Week", maxCapacity: 5, joinedParticipants: 8)
        let event2 = Event(id: "dummy2", title: "Sunday Morning Futsal", description: "Let's sweat it out this weekend!", location: "Kuningan Arena", date: "Jun 18", time: "08:00 - 10:00", cost: 50000, organizerName: "Alex", category: "Sport", timeframe: "Next Week", maxCapacity: 10, joinedParticipants: 3)
        let event3 = Event(id: "dummy3", title: "Iftar Gathering", description: "Lunch together at the famous local spot.", location: "Sederhana Sudirman", date: "Jun 20", time: "16:00 - 19:00", cost: 35000, organizerName: "Dimas Daffa", category: "Share Meal", timeframe: "Completed", maxCapacity: 4, joinedParticipants: 4)
        
        // We delay it by 1 second just to let the skeleton animation show briefly
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Only apply dummy data if Firebase hasn't already loaded real data
            if self.events.isEmpty {
                self.events = [event1, event2, event3]
            }
            // Turn off loading skeletons
            self.isLoading = false
        }
    }
}
