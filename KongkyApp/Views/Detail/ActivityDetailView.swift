//
//  ActivityDetailView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct ActivityDetailView: View {
    let event: Event
    
    @State private var showCancelSheet = false
    @State private var isSaved = false
    @State private var hasJoined = false
    @State private var showToast = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Color.themeSurface.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // --- 1. HERO IMAGE WITH FADE, CATEGORY PILL & HEART ---
                    ZStack(alignment: .top) {
                        
                        // Image Placeholder with the new Fading Gradient!
                        ZStack {
                            Rectangle()
                                .fill(Color(.systemGray4))
                            
                            // This creates the seamless fade into the white card
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.6), .white],
                                startPoint: .center, // Starts fading halfway down
                                endPoint: .bottom
                            )
                        }
                        .frame(height: 340) // Made slightly taller to accommodate the fade
                        
                        // Top Overlay (Pill on left, Heart on right)
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: event.iconName)
                                    .foregroundColor(.themePrimary)
                                    .font(.caption)
                                Text(event.category.uppercased())
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.themeText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(20)
                            
                            Spacer()
                            
                            Button(action: {
                                isSaved.toggle()
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }) {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundColor(isSaved ? .red : .themeTextVariant)
                                    .padding(10)
                                //                                    .background(Color.white)
                                //                                    .clipShape(Circle())
                                //                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    
                    // --- 2. TITLE & DESCRIPTION CARD ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text(event.title)
                            .font(.system(size: 32, weight: .heavy, design: .default))
                            .foregroundColor(.themeText)
                            .padding(.bottom, 4)
                        
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.themeTextVariant)
                            .lineSpacing(6)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding(.top, -60) // Pulled up a bit more to sit perfectly on the fade
                    .padding(.horizontal, 16)
                    .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
                    
                    // --- 3. ORGANIZER ROW ---
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .background(Circle().fill(Color.white))
                                    .offset(x: 16, y: 16)
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ORGANIZER")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.themeTextVariant)
                                .tracking(1)
                            
                            Text(event.organizerName)
                                .font(.headline)
                                .foregroundColor(.themeText)
                            
                            Text(event.organizerSession)
                                .font(.caption)
                                .foregroundColor(.themePrimary)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(Color(.systemGray6).opacity(0.6))
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
                    
                    // --- 4. CAPACITY ROW (NOW CLICKABLE!) ---
                    NavigationLink(destination: ParticipantsListView(event: event)) {
                        HStack {
                            HStack(spacing: -12) {
                                let displayCount = min(event.joinedParticipants, 3)
                                ForEach(0..<displayCount, id: \.self) { _ in
                                    Circle()
                                        .fill(Color(.systemGray3))
                                        .frame(width: 36, height: 36)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                }
                                
                                // Fixed logic to show remaining participants accurately
                                if event.joinedParticipants > 3 {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Text("+\(event.joinedParticipants - 3)")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.themeText)
                                        )
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("CAPACITY")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themeTextVariant)
                                    .tracking(1)
                                
                                let seatsLeft = max(0, event.maxCapacity - event.mainSlotsFilled)
                                Text("\(seatsLeft) more seats")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themeText)
                                
                                
                            }
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(16)
                        .background(Color(.systemGray6).opacity(0.6))
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(PlainButtonStyle()) // Crucial: Stops the text from turning default blue!
                    
                    // --- 5. THE BIG DETAILS CARD ---
                    VStack(alignment: .leading, spacing: 24) {
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("PRICING", systemImage: "banknote")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themePrimary)
                                    .tracking(1)
                                
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("\(event.formatPrice(event.currentIndividualPrice))")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.themePrimary)
                                    Text("IDR / pax")
                                        .font(.caption)
                                        .foregroundColor(.themeTextVariant)
                                }
                                
                                Text("Total: \(event.formatPrice(event.cost)) IDR")
                                    .font(.caption)
                                    .foregroundColor(.themeText)
                                
                                HStack {
                                    Text("Invite more to\nbecome \(event.formatPrice(event.nextIndividualPrice))/pax")
                                        .font(.system(size: 10, weight: .semibold))
                                        .lineLimit(2)
                                    Spacer()
                                    Image(systemName: "arrow.down.right")
                                        .font(.caption2)
                                }
                                .foregroundColor(.themePrimary)
                                .padding(8)
                                .background(Color.themePrimary.opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label("WHEN", systemImage: "calendar")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themePrimary)
                                    .tracking(1)
                                
                                Text(event.date)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themeText)
                                
                                Text("\(event.time) WIB")
                                    .font(.caption)
                                    .foregroundColor(.themeTextVariant)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        }
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 1)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("WHERE", systemImage: "mappin.and.ellipse")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.themePrimary)
                                .tracking(1)
                            
                            Text(event.location)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.themeText)
                            
                            Text("Jl. Senopati No. 42, Kebayoran Baru, Jakarta Selatan")
                                .font(.caption)
                                .foregroundColor(.themeTextVariant)
                                .lineSpacing(4)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color(.systemTeal).opacity(0.3))
                                    .frame(height: 120)
                                    .cornerRadius(12)
                                
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.yellow)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.horizontal, 16)
                    .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
                    
                    Color.clear.frame(height: 100)
                }
            }
            
            // --- 6. STICKY JOIN BUTTON ---
            VStack {
                Button(action: {
                    if !hasJoined {
                        // THE JOIN ACTION
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            hasJoined = true
                            showToast = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showToast = false
                            }
                        }
                    } else {
                        // THE CANCEL ACTION
                        showCancelSheet = true
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }) {
                    HStack {
                        Image(systemName: hasJoined ? "checkmark.circle.fill" : "bolt.fill")
                        Text(hasJoined ? "Seat Secured" : "Join Activity")
                    }
                    .font(.headline)
                    .foregroundColor(hasJoined ? .themeTextVariant : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Group {
                            if hasJoined {
                                Color(.systemGray5)
                            } else {
                                LinearGradient(
                                    colors: [.themePrimary, Color(red: 0, green: 112/255, blue: 235/255)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                        }
                    )
                    .cornerRadius(30)
                    .shadow(color: hasJoined ? .clear : .themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
                }
                .buttonStyle(SpringyButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            .background(.ultraThinMaterial)
            
            .confirmationDialog(
                "Are you sure you want to leave?",
                isPresented: $showCancelSheet,
                titleVisibility: .visible
            ) {
                Button("Leave Activity", role: .destructive) {
                    // This is where the red button lives
                    withAnimation(.spring()) {
                        hasJoined = false
                    }
                }
                // Apple automatically adds a bold "Cancel" button to dismiss the sheet
                Button("Keep My Seat", role: .cancel) {}
            } message: {
                Text("You will give up your spot for \(event.title).")
            }
            
            // --- 7. TOP GLASS TOAST NOTIFICATION ---
            if showToast {
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: "ticket.fill")
                            .font(.title3)
                            .foregroundColor(.themePrimary)
                        
                        Text("You're on the list! See you there.")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.themeText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
                    .padding(.top, 16) // Padding from the top of the screen
                    
                    Spacer() // Pushes the toast to the top
                }
                // Transition handles sliding down from the top and fading in smoothly
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2) // Ensures it sits perfectly above the image and content
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Activity Detail")
                    .font(.headline)
                    .foregroundColor(.themePrimary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.themeTextVariant)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            isSaved = event.isSaved
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
