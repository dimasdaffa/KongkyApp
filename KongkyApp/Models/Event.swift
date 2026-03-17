//
//  Event.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import Foundation
//import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    var id: String = UUID().uuidString //need to change if firebase

    
    var title: String
    var description: String
    var location: String
    var date: String
    var time: String
    var cost: Int
    var organizerName: String
    var organizerSession: String = "Afternoon Session"
    var category: String
    var timeframe: String = "This Week"
    var maxCapacity: Int
    var joinedParticipants: Int = 0
    var imageURL: String?
    
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
    
    // Helper to format 50000 into "50k" just like your design!
    func formatPrice(_ amount: Int) -> String {
        if amount >= 1000 {
            return "\(amount / 1000)k"
        }
        return "\(amount)"
    }
}
