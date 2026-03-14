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
    let availableSeats: Int
    let category: String
    
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
    
}
