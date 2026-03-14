//
//  DashboardView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "Recommended"
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var showCreateForm = false
    
    let categories = ["Recommended", "Movie", "Sports", "Board Game"]
    
    var body: some View {
        NavigationStack {
            
            // alignment: .bottomTrailing pushes our floating button to the bottom right
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // HEADER (Removed the + button from here)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome,")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Alex")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // SEARCH BAR
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.gray)
                            TextField("Search...", text: $searchText)
                        }
                        .padding(14).background(Color.gray.opacity(0.1)).cornerRadius(25).padding(.horizontal)
                        
                        // CATEGORY PILLS
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 20).padding(.vertical, 10)
                                        .background(selectedCategory == category ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                                        .foregroundColor(selectedCategory == category ? .black : .gray)
                                        .cornerRadius(20)
                                        .onTapGesture { selectedCategory = category }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // EVENT CARDS
                        VStack(spacing: 20) {
                            // 1. We create a filtered list dynamically
                            let filteredEvents = viewModel.events.filter { event in
                                // Check if it matches the selected category (Assume "Recommended" means "Show All")
                                let matchesCategory = selectedCategory == "Recommended" || event.category == selectedCategory
                                
                                // Check if it matches the search text
                                let matchesSearch = searchText.isEmpty ||
                                event.title.localizedCaseInsensitiveContains(searchText) ||
                                event.location.localizedCaseInsensitiveContains(searchText)
                                
                                return matchesCategory && matchesSearch
                            }
                            
                            // 2. We show an empty state if no events match
                            if filteredEvents.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                    Text("No activities found.")
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 40)
                            } else {
                                // 3. We loop over the FILTERED array, not the main one
                                ForEach(filteredEvents) { event in
                                    NavigationLink(destination: ActivityDetailView(event: event)) {
                                        DashboardEventCard(event: event)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 100)
                }
                
                // 2. THE FLOATING ACTION BUTTON (Foreground layer)
                Button(action: {
                    showCreateForm = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60) // Standard FAB size
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 4)
                }
                .padding(.trailing, 20) // Spacing from the right edge
                .padding(.bottom, 20)   // Spacing from the bottom edge
                
            }
            .sheet(isPresented: $showCreateForm) {
                CreateEventView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    DashboardView()
}
