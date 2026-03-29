//
//  EventService.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import Foundation
import FirebaseFirestore

class EventService: EventServiceProtocol {
    
    // The Firebase database reference — only this file knows about it!
    private let db = Firestore.firestore()
    
    // The collection name in Firestore (like a table name in SQL)
    private let collectionName = "activities"
    
    // MARK: - Fetch Events (Real-time Listener)
    // ---------------------------------------------------------
    // This uses Firestore's `addSnapshotListener` which gives
    // us REAL-TIME updates. Every time someone adds/edits/deletes
    // an event in Firebase, this callback fires automatically.
    // ---------------------------------------------------------
    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        db.collection(collectionName).addSnapshotListener { snapshot, error in
            // If something went wrong (e.g., no internet), print it
            guard let documents = snapshot?.documents else {
                print("EventService: No documents or error: \(String(describing: error))")
                completion([])
                return
            }
            
            // Convert each Firebase document into our Swift Event struct
            // `compactMap` skips any documents that fail to decode
            let events = documents.compactMap { document -> Event? in
                try? document.data(as: Event.self)
            }
            
            completion(events)
        }
    }
    
    // MARK: - Add Event
    // ---------------------------------------------------------
    // `addDocument(from:)` automatically converts our Codable
    // Event struct into JSON and saves it to Firestore.
    // Firebase generates a unique ID for us.
    // ---------------------------------------------------------
    func addEvent(_ event: Event) {
        do {
            let _ = try db.collection(collectionName).addDocument(from: event)
        } catch {
            print("EventService: Error adding event: \(error)")
        }
    }
    
    // MARK: - Update Event
    // ---------------------------------------------------------
    // `setData(from:)` replaces the entire document with the
    // updated Event struct. We need the document ID to know
    // WHICH document to update.
    // ---------------------------------------------------------
    func updateEvent(_ event: Event) {
        guard let documentId = event.id else {
            print("EventService: Cannot update — event has no ID")
            return
        }
        
        do {
            try db.collection(collectionName).document(documentId).setData(from: event)
        } catch {
            print("EventService: Error updating event: \(error)")
        }
    }
    
    // MARK: - Delete Event
    // ---------------------------------------------------------
    // Removes the document from Firestore by its ID.
    // ---------------------------------------------------------
    func deleteEvent(_ event: Event) {
        guard let documentId = event.id else {
            print("EventService: Cannot delete — event has no ID")
            return
        }
        
        db.collection(collectionName).document(documentId).delete { error in
            if let error = error {
                print("EventService: Error deleting event: \(error)")
            }
        }
    }
}
