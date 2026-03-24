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
        ScrollView {
            // Filter the array to ONLY show saved events
            let savedEvents = viewModel.events.filter { $0.isSaved }
            
            if savedEvents.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No saved events yet.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Hit the heart icon on activities you like to save them for later!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 80)
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(savedEvents) { event in
                        NavigationLink(destination: ActivityDetailView(event: event)) {
                            DashboardEventCard(event: event)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Saved Events")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .toolbar(.hidden, for: .tabBar) // Hide bottom tab bar
    }
}

#Preview {
    NavigationView {
        SavedEventsView()
    }
}
