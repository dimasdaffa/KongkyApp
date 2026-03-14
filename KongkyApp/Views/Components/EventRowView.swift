//
//  EventRowView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: event.iconName)
                        .foregroundColor(.gray)
                    Text(event.title)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Text("\(event.location) | \(event.time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(event.date)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 60, height: 60)
                .background(Color.gray)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    EventRowView(event: Event(
        title: "Iftar Tea",
        description: "Breaking fast together with some nice tea.",
        location: "Thamrin Nine Pantry",
        date: "Jun\n16",
        time: "18:00 - 19:30",
        cost: 50000,
        organizerName: "Dimas",
        availableSeats: 5,
        category: "Tea Time"
    ))
}
