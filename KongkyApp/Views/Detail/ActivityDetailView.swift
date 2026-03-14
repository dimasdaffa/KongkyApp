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
                        }
                        Spacer()
                    }
                    .padding().background(Color.white).cornerRadius(14).shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    NavigationLink(destination: ParticipantsListView(event: event)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Participants").font(.headline).foregroundColor(.primary)
                                Text("\(event.mainSlotsFilled)/\(event.maxCapacity) Slots Filled • \(event.queueCount) Mingling").font(.caption).foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("\(event.joinedParticipants) Joined").font(.subheadline).fontWeight(.bold).foregroundColor(.blue)
                            
                            Image(systemName: "chevron.right").foregroundColor(.gray.opacity(0.5)).font(.footnote)
                        }
                        .padding().background(Color.white).cornerRadius(14).shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Details").font(.headline).padding(.bottom, 4)
                        DetailRow(title: "Cost", value: "Rp \(event.cost) / pax")
                        Divider()
                        DetailRow(title: "Date", value: event.date.replacingOccurrences(of: "\n", with: " "))
                        Divider()
                        DetailRow(title: "Time", value: event.time)
                        Divider()
                        DetailRow(title: "Place", value: event.location)
                    }
                    .padding().background(Color.white).cornerRadius(14).shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    Color.clear.frame(height: 100)
                }
                .padding()
            }
            
            // 2. THE STICKY JOIN BUTTON AREA (UPDATED FOR GLASSMORPHISM)
            VStack {
                Button(action: {
                    // Action for joining activity
                    showJoinAlert = true
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
