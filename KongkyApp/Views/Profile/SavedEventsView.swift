//
//  SavedEventsView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI

struct SavedEventsView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            // Layer 0: Premium Soft Background
            Color.themeSurface.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                let savedEvents = viewModel.events.filter { $0.isSaved }
                
                VStack(spacing: 0) {
                    
                    // --- NEW: HIG COMPLIANT STATS ROW ---
                    statsHeader(count: savedEvents.count)
                    
                    // --- CONTENT ---
                    if savedEvents.isEmpty {
                        emptyStateView
                    } else {
                        LazyVStack(spacing: 20) {
                            ForEach(savedEvents) { event in
                                NavigationLink(destination: ActivityDetailView(event: event)) {
                                    DashboardEventCard(event: event)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        // THE FIX: Apple HIG standard Large Title!
        .navigationTitle("Saved Events")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.hidden, for: .tabBar) // Hide bottom tab bar
    }
    
    // MARK: - Subviews
    
    private func statsHeader(count: Int) -> some View {
        HStack(alignment: .lastTextBaseline) {
            
            Text("YOUR COLLECTION")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.themeTextVariant)
                .tracking(1.5) // Editorial letter spacing
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(count)")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(.themePrimary)
                
                Text("ITEMS")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 24)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 40))
                .foregroundColor(.themeTextVariant)
            
            Text("No saved events yet.")
                .font(.headline)
                .foregroundColor(.themeText)
            
            Text("Hit the heart icon on activities you like to save them for later!")
                .font(.subheadline)
                .foregroundColor(.themeTextVariant)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 80)
    }
}

#Preview {
    NavigationView {
        SavedEventsView()
    }
}
