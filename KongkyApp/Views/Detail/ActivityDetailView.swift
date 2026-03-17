//
//  ActivityDetailView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct ActivityDetailView: View {
    let event: Event
    
    @State private var showJoinAlert = false
    
    var body: some View {
        // We use a ZStack and align the sticky button area to the BOTTOM
        // so the main content can scroll UNDERNEATH it, creating a true glass effect.
        ZStack(alignment: .bottom) {
            
            // 1. THE MAIN SCROLLABLE CONTENT
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // (Image placeholder section...)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 250)
                        .cornerRadius(14)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: event.iconName).font(.title2)
                            Text(event.title).font(.title2).fontWeight(.bold)
                        }
                        
                        Text(event.description).font(.body).foregroundColor(.gray).lineSpacing(4)
                    }
                    .padding().frame(maxWidth: .infinity, alignment: .leading).background(Color.white).cornerRadius(14).shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    HStack(spacing: 12) {
                        Circle().fill(Color.gray.opacity(0.4)).frame(width: 50, height: 50).overlay(Image(systemName: "person.fill").foregroundColor(.white))
                        
                        VStack(alignment: .leading) {
                            Text("Event by").font(.caption).foregroundColor(.gray)
                            Text(event.organizerName).font(.headline)
                            Text(event.organizerSession)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .padding().background(Color.white).cornerRadius(14).shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                // ---------------------------------------------------------
                // 1. PARTICIPANTS VISUALIZER CARD (Now Clickable & Fixed!)
                // ---------------------------------------------------------
                NavigationLink(destination: ParticipantsListView(event: event)) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // The Pill Header & Chevron
                        HStack {
                            Label("Participants", systemImage: "person.2")
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(20)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            // Visual hint that this card is clickable
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        HStack {
                            // The Overlapping Circles (Limited to 4 circles max to prevent squishing)
                            let displayCount = min(event.maxCapacity, 4)
                            HStack(spacing: -12) { // Slightly tighter overlap
                                ForEach(0..<displayCount, id: \.self) { index in
                                    Circle()
                                        .fill(index < event.mainSlotsFilled ? Color.gray.opacity(0.3) : Color.white)
                                        .frame(width: 38, height: 38) // Slightly smaller circles
                                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                }
                                
                                // If capacity is larger than 4, show a +X indicator
                                if event.maxCapacity > 4 {
                                    Circle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 38, height: 38)
                                        .overlay(
                                            Text("+\(event.maxCapacity - 4)")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        )
                                }
                            }
                            
                            Spacer(minLength: 12)
                            
                            // The Call to Action Text
                            let availableSeats = event.maxCapacity - event.mainSlotsFilled
                            if availableSeats > 0 {
                                // Grouped in a VStack so it aligns nicely
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(availableSeats) more seats available,")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    Text("book now!")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                // MAGIC FIX: Tells SwiftUI this text MUST have enough room!
                                .layoutPriority(1) 
                            } else {
                                Text("Fully booked!")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .layoutPriority(1)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle()) // Keeps text from turning blue like a standard link
                
                // ---------------------------------------------------------
                // 2. PRICING & DETAILS CARD (Location restored!)
                // ---------------------------------------------------------
                VStack(alignment: .leading, spacing: 16) {
                    
                    Label("Details", systemImage: "square.grid.2x2")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Individual Price").font(.headline)
                            if event.mainSlotsFilled < event.maxCapacity {
                                HStack(spacing: 2) {
                                    Text("Invite more to become \(event.formatPrice(event.nextIndividualPrice)) / pax")
                                        .font(.caption).italic().foregroundColor(.gray)
                                    Image(systemName: "arrow.down.right")
                                        .font(.caption2).foregroundColor(.gray)
                                }
                            }
                        }
                        Spacer()
                        Text("\(event.formatPrice(event.currentIndividualPrice)) IDR / pax")
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total Price").font(.headline)
                        Spacer()
                        Text("\(event.formatPrice(event.cost)) IDR").foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Date").font(.headline)
                        Spacer()
                        Text(event.date).foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // --- RESTORED LOCATION ROW ---
                    HStack {
                        Text("Location").font(.headline)
                        Spacer()
                        Text(event.location).foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                    
                    Color.clear.frame(height: 100)
                }
                .padding()
            }
            
            // 2. THE STICKY JOIN BUTTON AREA
            VStack {
                Button(action: {
                    // Action for joining activity
                    showJoinAlert = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    Text("Join Activity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.green.opacity(0.9), .green.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    // A frosted glass material blur directly behind the gradient
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
                        )
                        .cornerRadius(14)
                }
            }
            .padding()
            .background(.thinMaterial) // Apple built-in frosted glass effect
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
        }
        .navigationTitle("Activity Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar) // Remove Tab Bar on Page
        .alert(isPresented: $showJoinAlert) {
            Alert(
                title: Text("Success!"),
                message: Text("You have successfully joined \(event.title)."),
                dismissButton: .default(Text("Awesome"))
            )
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title).fontWeight(.semibold)
            Spacer()
            Text(value).foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationView {
        ActivityDetailView(event: Event(
            title: "Bukber Bersama",
            description: "Lunch together at the famous local spot. Don't forget to bring your appetite!",
            location: "Sederhana Sudirman",
            date: "Jun 20",
            time: "12:00 - 13:00",
            cost: 35000,
            organizerName: "Dimas Daffa",
            category: "Share Meal",
            maxCapacity: 5,
            joinedParticipants: 8
        ))
    }
}
