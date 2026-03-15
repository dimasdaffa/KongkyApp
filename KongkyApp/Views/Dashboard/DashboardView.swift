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
            
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
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
                                        .onTapGesture { 
                                            selectedCategory = category 
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // EVENT CARDS
                        VStack(spacing: 20) {
                            
                            // IF LOADING: Show Skeletons
                            if viewModel.isLoading {
                                ForEach(0..<3, id: \.self) { _ in
                                    DashboardCardSkeleton()
                                }
                            } 
                            // ELSE: Show Real Filtered Data
                            else {
                                let filteredEvents = viewModel.events.filter { event in
                                    let matchesCategory = selectedCategory == "Recommended" || event.category == selectedCategory
                                    let matchesSearch = searchText.isEmpty ||
                                                        event.title.localizedCaseInsensitiveContains(searchText) ||
                                                        event.location.localizedCaseInsensitiveContains(searchText)
                                    return matchesCategory && matchesSearch
                                }
                                
                                if filteredEvents.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "magnifyingglass").font(.largeTitle).foregroundColor(.gray)
                                        Text("No activities found.").foregroundColor(.gray)
                                    }
                                    .padding(.top, 40)
                                } else {
                                    ForEach(filteredEvents) { event in
                                        NavigationLink(destination: ActivityDetailView(event: event)) {
                                            DashboardEventCard(event: event)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 100)
                }
                
                // 2. THE FLOATING ACTION BUTTON
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
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                
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
