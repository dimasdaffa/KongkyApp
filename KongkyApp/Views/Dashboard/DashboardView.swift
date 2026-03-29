//
//  DashboardView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "Recommended"
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCreateForm = false
    
    // Computes the greeting strictly based on WIB time
    private var dynamicGreeting: String {
        var calendar = Calendar.current
        
        // Force the timezone to WIB (Asia/Jakarta)
        if let wibTimeZone = TimeZone(identifier: "Asia/Jakarta") {
            calendar.timeZone = wibTimeZone
        }
        
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good Morning,"
        case 12..<18:
            return "Good Afternoon,"
        default:
            return "Good Evening,"
        }
    }
    
    let categories = ["Recommended", "Movie", "Sports", "Board Game"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // Base background color (Layer 0)
                Color.themeSurface.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // 1. CUSTOM TOP NAV BAR
                        HStack {
                            Text("Kongky")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.themePrimary)
                            
                            Spacer()
                            
                            Button(action: { /* Notification action */ }) {
                                Image(systemName: "bell")
                                    .font(.title3)
                                    .foregroundColor(.themePrimary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // 2. GREETING
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dynamicGreeting)
                                .font(.subheadline)
                                .foregroundColor(.themeTextVariant)
                            Text(Auth.auth().currentUser?.displayName ?? "Alex Testing")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.themeText)
                        }
                        .padding(.horizontal, 20)
                        
                        // 3. SEARCH BAR
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Find your next hang out...", text: $searchText)
                        }
                        .padding(16)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // 4. CATEGORY PILLS (Chips)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { category in
                                    let isSelected = selectedCategory == category
                                    
                                    Text(category)
                                        .font(.subheadline)
                                        .fontWeight(isSelected ? .semibold : .regular)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(isSelected ? Color.themePrimary : Color(.systemGray6))
                                        .foregroundColor(isSelected ? .white : .themeTextVariant)
                                        .cornerRadius(40)
                                        .onTapGesture {
                                            selectedCategory = category
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // 5. SECTION HEADER
                        HStack {
                            Text("Happening Soon")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.themeText)
                            Spacer()
                            Button("View all") { /* View all action */ }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.themePrimary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // 6. EVENT CARDS LIST
                        VStack(spacing: 8) { // Less spacing here because the card has internal padding/shadows
                            if viewModel.isLoading {
                                ForEach(0..<3, id: \.self) { _ in
                                    DashboardCardSkeleton()
                                        .padding(.horizontal, 20)
                                }
                            } else {
                                // Real filtering logic
                                let filteredEvents = viewModel.events.filter { event in
                                    let matchesCategory = selectedCategory == "Recommended" || event.category == selectedCategory
                                    let matchesSearch = searchText.isEmpty || event.title.localizedCaseInsensitiveContains(searchText)
                                    return matchesCategory && matchesSearch
                                }
                                
                                ForEach(filteredEvents) { event in
                                    NavigationLink(destination: ActivityDetailView(event: event)) {
                                        DashboardEventCard(event: event)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
                
                // 7. FLOATING ACTION BUTTON (FAB)
                Button(action: {
                    showCreateForm = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.themePrimary)
                        .cornerRadius(18)
                        .shadow(color: Color.themePrimary.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 24)
                .padding(.bottom, 24)
            }
            .sheet(isPresented: $showCreateForm) {
                CreateEventView(viewModel: viewModel)
            }
            .navigationBarHidden(true) // We are using our custom top bar now
        }
    }
}

#Preview {
    DashboardView()
}
