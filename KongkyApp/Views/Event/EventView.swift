//
//  HomeView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct EventView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 16) {
                    EventSectionView(
                        title: "This Week",
                        events: viewModel.events.filter { $0.timeframe == "This Week" }
                    )
                    
                    // 2. "Next Week" Section
                    EventSectionView(
                        title: "Next Week",
                        events: viewModel.events.filter { $0.timeframe == "Next Week" }
                    )
                    
                    // 3. "Completed" Section (Notice we pass isCompleted: true)
                    EventSectionView(
                        title: "Completed",
                        events: viewModel.events.filter { $0.timeframe == "Completed" },
                        isCompleted: true
                    )
                }
                .padding()
            }
            .navigationTitle("All Events")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
        }
    }
}

// The Grouped Box
struct EventSectionView: View {
    let title: String
    let events: [Event]
    var isCompleted: Bool = false
    
    var body: some View {
        // Only show the section if there are events in it
        if !events.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                
                // Section Header
                Text(title)
                    .font(.headline)
                    .padding(.leading, 4)
                
                // The White Grouping Box
                VStack(spacing: 0) {
                    ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                        
                        NavigationLink(destination: ActivityDetailView(event: event)) {
                            EventListCell(event: event)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Add a dividing line between items (but not after the very last item)
                        if index < events.count - 1 {
                            Divider()
                                .padding(.leading, 90) // Indents the line past the date box, just like Apple Mail!
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            // MAGIC: If the section is "Completed", we fade the entire block to 50% opacity!
            .opacity(isCompleted ? 0.5 : 1.0)
        }
    }
}

//The inner row (Date on the left)
struct EventListCell: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 16) {
            
            Text(event.date)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 60, height: 60)
                .background(Color.gray)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: event.iconName)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text(event.title)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Text("\(event.location) / \(event.time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    EventView()
}
