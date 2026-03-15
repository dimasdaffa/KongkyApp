//
//  Event.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import Foundation

struct Event: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let location: String
    let date: String
    let time: String
    let cost: Int
    let organizerName: String
    var organizerSession: String = "Afternoon Session"
    let category: String
    var timeframe: String = "This Week"
    let maxCapacity: Int
    let joinedParticipants: Int
    
    var iconName: String {
        switch category.lowercased() {
        case "board game":
            return "gamecontroller.fill"
        case "tea time":
            return "cup.and.saucer.fill"
        case "sport":
            return "figure.run"
        case "watch party":
            return "tv.fill"
        case "share meal":
            return "fork.knife"
        default:
            return "star.fill"
        }
    }
    
    // How many of the main slots are taken? (Will never exceed maxCapacity)
    var mainSlotsFilled: Int {
        return min(joinedParticipants, maxCapacity)
    }
    
    // How many people are in the mingling/queue section? (If negative, returns 0)
    var queueCount: Int {
        return max(0, joinedParticipants - maxCapacity)
    }
    
}
