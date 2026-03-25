//
//  ParticipantListView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct ParticipantsListView: View {
    let event: Event
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // --- 1. MAIN SLOTS SECTION ---
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Header
                    HStack(spacing: 8) {
                        Text("Main Slots")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.themeText)
                        
                        Text("(\(event.mainSlotsFilled)/\(event.maxCapacity))")
                            .font(.headline)
                            .foregroundColor(.themePrimary)
                    }
                    .padding(.horizontal, 20)
                    
                    // Container for Main Participants
                    VStack(spacing: 12) {
                        ForEach(0..<event.mainSlotsFilled, id: \.self) { index in
                            // Logic to make the first person the Organizer
                            let isOrganizer = index == 0
                            let roleText = isOrganizer ? "Organizer" : (index % 2 == 0 ? "Morning Session" : "Afternoon Session")
                            
                            ParticipantMainRow(
                                name: "Participant \(index + 1)",
                                role: roleText,
                                isOrganizer: isOrganizer
                            )
                        }
                    }
                    .padding(16)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(24)
                    .padding(.horizontal, 20)
                }
                
                // --- 2. QUEUE SECTION (Only shows if there's a queue) ---
                if event.queueCount > 0 {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Header
                        HStack(spacing: 8) {
                            Text("Mingling / Queue")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.themeText)
                            
                            Text("(\(event.queueCount))")
                                .font(.headline)
                                .foregroundColor(.themeTextVariant)
                        }
                        .padding(.horizontal, 20)
                        
                        // Queue Items
                        VStack(spacing: 12) {
                            ForEach(0..<event.queueCount, id: \.self) { index in
                                let sessionText = index % 2 == 0 ? "Afternoon Session" : "Morning Session"
                                
                                ParticipantQueueRow(
                                    name: "Queue Member \(index + 1)",
                                    session: sessionText
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // --- 3. INVITE MORE FRIENDS CTA ---
                VStack(alignment: .leading, spacing: 16) {
                    Text("Invite more friends?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("More friends mean better splits and a livelier crowd.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                    
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        HStack {
                            Text("Share Event")
                                .fontWeight(.bold)
                            Image(systemName: "square.and.arrow.up")
                        }
                        .foregroundColor(.themePrimary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(30)
                    }
                    .padding(.top, 8)
                }
                .padding(32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [.themePrimary, Color(red: 0, green: 112/255, blue: 235/255)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(32)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
        }
        .background(Color.themeSurface.ignoresSafeArea()) // Layer 0 Background
        .navigationTitle("Participants")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// The white card used in the "Main Slots" section
struct ParticipantMainRow: View {
    let name: String
    let role: String
    let isOrganizer: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Picture Placeholder
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.themePrimary.opacity(0.15))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.themePrimary)
                    )
                
                // Organizer Star Badge
                if isOrganizer {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.orange)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: 4, y: 4)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.themeText)
                
                Text(role)
                    .font(.subheadline)
                    .foregroundColor(.themeTextVariant)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
    }
}

// The grayed-out card used in the "Queue" section
struct ParticipantQueueRow: View {
    let name: String
    let session: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Picture Placeholder
            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.themeText)
                
                Text(session)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1) // Adds that slight letter spacing
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.6))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        ParticipantsListView(event: Event(
            title: "Board Game Night",
            description: "Dummy desc",
            location: "Thamrin Nine",
            date: "12 Dec",
            time: "19:00",
            cost: 20000,
            organizerName: "Alex",
            category: "Board Game",
            maxCapacity: 5,
            joinedParticipants: 8
        ))
    }
}

