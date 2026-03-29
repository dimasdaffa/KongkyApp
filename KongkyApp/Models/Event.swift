//
//  Event.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var location: String
    var date: String
    var time: String
    var cost: Int
    var organizerName: String
    var organizerEmail: String? = nil
    var savedBy: [String]? = []
    var organizerSession: String = "Afternoon Session"
    var category: String
    var timeframe: String = "This Week"
    var maxCapacity: Int
    var imageURL: String?
    var participants: [EventParticipant] = []
    
    var joinedParticipants: Int {
        return participants.count
    }
    
    var coordinate: CLLocationCoordinate2D {
        if location.localizedCaseInsensitiveContains("Senopati") {
            return CLLocationCoordinate2D(latitude: -6.2300, longitude: 106.8075)
        } else if location.localizedCaseInsensitiveContains("Thamrin") {
            return CLLocationCoordinate2D(latitude: -6.1965, longitude: 106.8226)
        } else if location.localizedCaseInsensitiveContains("Kuningan") {
            return CLLocationCoordinate2D(latitude: -6.2230, longitude: 106.8327)
        } else {
            // Default fallback: Central Jakarta
            return CLLocationCoordinate2D(latitude: -6.2000, longitude: 106.8166)
        }
    }
    
    // How many of the main slots are taken (Will never exceed maxCapacity)
    var mainSlotsFilled: Int {
        return min(joinedParticipants, maxCapacity)
    }
    
    // How many people are in the mingling/queue section (If negative, returns 0)
    var queueCount: Int {
        return max(0, joinedParticipants - maxCapacity)
    }
    
    // Computed property for the icon (Not saved in database, just calculated locally)
    var iconName: String {
        switch category {
        case "Board Game": return "dice.fill"
        case "Sport": return "figure.run"
        case "Share Meal": return "fork.knife"
        case "Tea Time": return "cup.and.saucer.fill"
        case "Watch Party": return "popcorn.fill"
        case "Photography": return "camera.fill"
        case "Music": return "music.note"
        case "Networking": return "person.3.fill"
        default: return "star.fill"
        }
    }
    
    // Calculates current price per person (prevents dividing by 0 if no one joined yet)
    var currentIndividualPrice: Int {
        let activeParticipants = max(1, mainSlotsFilled)
        return cost / activeParticipants
    }
    
    // Calculates what the price will drop to if one more person joins
    var nextIndividualPrice: Int {
        let nextSlots = min(maxCapacity, mainSlotsFilled + 1)
        return cost / max(1, nextSlots)
    }
    
    // Helper to format 50000 into "50k"
    func formatPrice(_ amount: Int) -> String {
        if amount == 0 { return "Free" }
        if amount >= 1000 {
            return "\(amount / 1000)k"
        }
        return "\(amount)"
    }
    
    // MARK: - Save Logic
    mutating func toggleSaved(for email: String) {
        if savedBy == nil { savedBy = [] }
        if savedBy!.contains(email) {
            savedBy!.removeAll { $0 == email } // Un-save
        } else {
            savedBy!.append(email) // Save
        }
    }
    
    func isSavedBy(email: String) -> Bool {
        return savedBy?.contains(email) ?? false
    }
    
    // MARK: - Join Logic
    mutating func toggleJoin(email: String, name: String) {
            if let index = participants.firstIndex(where: { $0.email == email }) {
                participants.remove(at: index) // Leave
            } else {
                participants.append(EventParticipant(email: email, name: name)) // Join
            }
        }
    
    func isJoinedBy(email: String) -> Bool {
            return participants.contains(where: { $0.email == email })
        }
}
