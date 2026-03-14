//
//  HomeView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.events) { event in
                        NavigationLink(destination: ActivityDetailView(event: event)) {
                            
                            EventRowView(event: event)
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("All Events")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView()
}
