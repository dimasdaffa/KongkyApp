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
        NavigationStack {
            ZStack {
                // Layer 0: Premium Soft Background
                Color.themeSurface.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // --- 1. HEADER ---
                        VStack(alignment: .leading, spacing: 4) {
                            Text("All Events")
                                .font(.system(size: 34, weight: .heavy, design: .default))
                                .foregroundColor(.themeText)
                            Text("Your upcoming social schedule")
                                .font(.subheadline)
                                .foregroundColor(.themeTextVariant)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 24)
                        
                        // --- 2. THE TIMELINE CONTENT ---
                        if viewModel.isLoading {
                            // Quick loading state
                            Text("Loading schedule...")
                                .foregroundColor(.themeTextVariant)
                                .padding(20)
                        } else {
                            // THIS WEEK
                            let thisWeek = viewModel.events.filter { $0.timeframe == "This Week" }
                            if !thisWeek.isEmpty {
                                TimelineSection(title: "This Week", events: thisWeek, isCompleted: false)
                            }
                            
                            // NEXT WEEK
                            let nextWeek = viewModel.events.filter { $0.timeframe == "Next Week" }
                            if !nextWeek.isEmpty {
                                TimelineSection(title: "Next Week", events: nextWeek, isCompleted: false)
                            }
                            
                            // COMPLETED
                            let completed = viewModel.events.filter { $0.timeframe == "Completed" }
                            if !completed.isEmpty {
                                TimelineSection(title: "Completed", events: completed, isCompleted: true)
                            }
                        }
                        
                        // Extra spacing at the bottom
                        Color.clear.frame(height: 40)
                    }
                }
            }
            .navigationBarHidden(true) // We built our own custom header!
        }
    }
}

// MARK: - Subcomponents

/// Represents an entire section (e.g., "THIS WEEK")
struct TimelineSection: View {
    let title: String
    let events: [Event]
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section Header
            Text(title.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.themeTextVariant)
                .tracking(1.5)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .padding(.top, 12)
            
            // The List of Events
            VStack(spacing: 0) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    // NEW: We now track both the first and last item!
                    let isFirst = index == 0
                    let isLast = index == events.count - 1
                    
                    TimelineRow(event: event, isFirst: isFirst, isLast: isLast, isCompleted: isCompleted)
                }
            }
        }
    }
}
/// The actual row containing the Date Box, the Line, and the Event Card
struct TimelineRow: View {
    let event: Event
    let isFirst: Bool // NEW
    let isLast: Bool
    let isCompleted: Bool
    
    var formattedDate: (month: String, day: String) {
        let cleanDate = event.date.replacingOccurrences(of: "\n", with: " ")
        let parts = cleanDate.components(separatedBy: " ")
        let month = parts.first?.prefix(3).uppercased() ?? "MTH"
        let day = parts.count > 1 ? parts[1] : "00"
        return (String(month), String(day))
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            // --- LEFT COLUMN: DATE PILL & CONNECTING LINE ---
            ZStack(alignment: .top) {
                
                // 1. The Vertical Connecting Line
                Group {
                    if isFirst && isLast {
                        // If it's the ONLY item in the list, no line needed!
                        EmptyView()
                    } else if isLast {
                        // For the last item, fade it out
                        LinearGradient(
                            colors: [Color(.systemGray5), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else {
                        // Standard connecting line
                        Rectangle()
                            .fill(Color(.systemGray5))
                    }
                }
                .frame(width: 2)
                // THE MAGIC FIX: Only push the line down if it's the very first item!
                // Otherwise, start from the absolute top (0) so it connects to the row above.
                .padding(.top, isFirst ? 30 : 0)
                
                // 2. The Date Pill
                VStack(spacing: 2) {
                    Text(formattedDate.month)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isCompleted ? .themeTextVariant : .themePrimary)
                    
                    Text(formattedDate.day)
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundColor(isCompleted ? .themeTextVariant : .themeText)
                }
                .frame(width: 52, height: 56)
                .background(isCompleted ? Color(.systemGray6).opacity(0.5) : Color.white)
                .cornerRadius(16)
                .shadow(color: isCompleted ? .clear : Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
            }
            .frame(width: 52)
            
            // --- RIGHT COLUMN: THE EVENT CARD ---
            NavigationLink(destination: ActivityDetailView(event: event)) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: event.iconName)
                                .font(.subheadline)
                                .foregroundColor(isCompleted ? .themeTextVariant : .themePrimary)
                            
                            Text(event.title)
                                .font(.headline)
                                .foregroundColor(isCompleted ? .themeTextVariant : .themeText)
                                .lineLimit(1)
                        }
                        
                        Text("\(event.location) • \(event.time)")
                            .font(.caption)
                            .foregroundColor(.themeTextVariant)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray4))
                }
                .padding(16)
                .background(isCompleted ? Color(.systemGray6).opacity(0.5) : Color.white)
                .cornerRadius(16)
                .shadow(color: isCompleted ? .clear : Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            // THE SECOND MAGIC FIX: We moved the bottom padding HERE to the right column.
            // This forces the row to be tall, allowing the gray line to stretch all the way down!
            .padding(.bottom, 24)
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    EventView()
}
