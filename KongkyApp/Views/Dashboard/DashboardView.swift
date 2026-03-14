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
    
    let categories = ["All", "Movie", "Sports", "Board Game"]
    
    var body: some View {
        NavigationView {
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
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search...", text: $searchText)
                    }
                    .padding(14)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(25)
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == category ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                                    .foregroundColor(selectedCategory == category ? .black : .gray)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        selectedCategory = category
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 20) {
                        ForEach(viewModel.events) { event in
                            NavigationLink(destination: ActivityDetailView(event: event)) {
                                DashboardEventCard(event: event)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    DashboardView()
}
