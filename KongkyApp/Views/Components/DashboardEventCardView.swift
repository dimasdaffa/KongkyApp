//
//  DashboardEventCardView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct DashboardEventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 160)
                .cornerRadius(14)
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    Image(systemName: event.iconName)
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text(event.title)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Text(event.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            
            HStack {
                // Cost
                HStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.gray)
                    Text("\(event.cost/1000)k")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                // Date
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text(event.date.replacingOccurrences(of: "\n", with: " "))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer()
                                
                HStack(spacing: -8) {
                    // 1. Calculate how many circles to draw (max 4)
                    let displayCount = min(event.joinedParticipants, 4)
                    
                    if displayCount > 0 {
                        ForEach(0..<displayCount, id: \.self) { index in
                            Circle()
                            // Added a fading opacity effect based on the index!
                                .fill(Color.gray.opacity(0.8 - (Double(index) * 0.15)))
                                .frame(width: 24, height: 24)
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        }
                    }
                }
                
                // 2. If there are more than 4, show the "+X" text!
                if event.joinedParticipants > 4 {
                    Text("+\(event.joinedParticipants - 4)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.leading, 2)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    DashboardEventCard(event: Event(
        title: "Board Game Night",
        description: "The most unforgettable night...",
        location: "Thamrin Nine",
        date: "12 Dec",
        time: "19:00",
        cost: 20000,
        organizerName: "Alex",
        category: "Board Game",
        maxCapacity: 5,
        joinedParticipants: 9 // Should show 4 circles and "+5"
    ))
    .padding()
}
