//
//  EventService.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import Foundation
import FirebaseFirestore

class EventService: EventServiceProtocol {
    
    private let db = Firestore.firestore()
    
    private let collectionName = "activities"
    
    // MARK: - Fetch Events (Real-time Listener)
    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        db.collection(collectionName).addSnapshotListener { snapshot, error in
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
    
    func addEvent(_ event: Event) {
        do {
            let _ = try db.collection(collectionName).addDocument(from: event)
        } catch {
            print("EventService: Error adding event: \(error)")
        }
    }
    
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
