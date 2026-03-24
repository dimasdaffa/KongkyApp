//
//  DashboardEventCardView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct DashboardEventCard: View {
    let event: Event
    
    @State private var isSaved: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 160)
                    .cornerRadius(14)
                
                // The Heart Button Overlay
                Button(action: {
                    isSaved.toggle()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred() // Haptic tap!
                }) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(isSaved ? .red : .gray)
                        .padding(10)
                        .background(.ultraThinMaterial) // Frosted glass circle
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    Image(systemName: event.iconName)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text(event.title)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Text(event.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            
            HStack {
                // Cost
                HStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.secondary)
                    Text("\(event.cost/1000)k")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                // Date
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text(event.date.replacingOccurrences(of: "\n", with: " "))
                        .font(.footnote)
                        .foregroundColor(.secondary)
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
                                .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                        }
                    }
                }
                
                // 2. If there are more than 4, show the "+X" text!
                if event.joinedParticipants > 4 {
                    Text("+\(event.joinedParticipants - 4)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.leading, 2)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 0, y: 2)
        .onAppear {
                    isSaved = event.isSaved
                }
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
        joinedParticipants: 9, // Should show 4 circles and "+5"
    ))
    .padding()
}
