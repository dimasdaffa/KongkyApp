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
        VStack(spacing: 0) { // Spacing 0 ensures the image touches the white card body perfectly
            
            // 1. TOP IMAGE AREA
            ZStack(alignment: .top) {
                if let imageURLString = event.imageURL, let url = URL(string: imageURLString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            // Shows a spinner while downloading
                            ProgressView()
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipped()
                        case .failure:
                            // Fallback if the link is broken
                            Rectangle()
                                .fill(Color(.systemGray4))
                                .frame(height: 180)
                                .overlay(Image(systemName: "photo.badge.exclamationmark").foregroundColor(.gray))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .id(url)
                } else {
                    // Fallback for older activities that don't have an image
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 180)
                }
                
                // Top Overlay elements (Category Pill & Heart)
                HStack(alignment: .top) {
                    // Category Pill
                    HStack(spacing: 4) {
                        Image(systemName: event.iconName)
                            .foregroundColor(.themePrimary)
                        Text(event.category.uppercased())
                    }
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    // .thickMaterial gives that beautiful iOS frosted glass effect!
                    .background(.thickMaterial)
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    // Heart Button
                    Button(action: {
                        isSaved.toggle()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(isSaved ? .red : .white)
                        // We add padding to ensure the touch target is large enough (HIG Standard: 44x44)
                            .padding(8)
                        //                            .background(Color.black.opacity(0.3)) // Subtle dark background so it's visible on white images
                        //                            .clipShape(Circle())
                    }
                }
                .padding(16)
            }
            
            // 2. BOTTOM CONTENT AREA
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(event.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeText) // Using your custom soft-black!
                    .lineLimit(1)
                
                // Location
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(event.location)
                }
                .font(.subheadline)
                .foregroundColor(.themeTextVariant)
                
                // Bottom Row: Price, Date, Avatars
                HStack(alignment: .bottom) {
                    // Price Area - Styled exactly like your design!
                    HStack(alignment: .bottom, spacing: 4) {
                        if event.currentIndividualPrice == 0 {
                            Text("Free")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.themePrimary)
                        } else {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(event.formatPrice(event.currentIndividualPrice))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themePrimary)
                                Text("IDR")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themePrimary)
                            }
                            Text("/ pax")
                                .font(.caption)
                                .foregroundColor(.themeTextVariant)
                                .padding(.bottom, 2)
                        }
                    }
                    
                    Spacer()
                    
                    // Date
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(event.date.replacingOccurrences(of: "\n", with: " "))
                    }
                    .font(.caption)
                    .foregroundColor(.themeTextVariant)
                    
                    Spacer()
                    
                    // Avatars (The "Halo" effect)
                    HStack(spacing: -8) { // Negative spacing overlaps them
                        let displayCount = min(event.joinedParticipants, 3) // Show max 3 circles
                        
                        if displayCount > 0 {
                            ForEach(0..<displayCount, id: \.self) { index in
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 28, height: 28)
                                // DESIGN.md implementation: The 2px halo using the card background color!
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            }
                        }
                        
                        // Remaining count indicator
                        if event.joinedParticipants > 3 {
                            Text("+\(event.joinedParticipants - 3)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.themeTextVariant)
                                .padding(.leading, 6)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.white) // Layer 2 from DESIGN.md
        }
        .cornerRadius(20) // Soft, large corners
        // DESIGN.md implementation: Ambient shadow with 32 blur, 8 Y-offset, 6% opacity
        .shadow(color: Color.themeText.opacity(0.06), radius: 32, x: 0, y: 8)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .onAppear {
            isSaved = event.isSavedBy(email: "")
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
        participants: (0..<9).map { EventParticipant(email: "user\($0)@test.com", name: "User \($0)") } // Should show 3 circles and "+6"
    ))
    .padding()
}
