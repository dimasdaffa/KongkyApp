//
//  MainTabView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct MainTabView: View {
    @Binding var isAuthenticated: Bool
    @State private var selectedTab = 0 // Create tab landing and set the initial value
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            EventView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
                .tag(1)
            
            
            ProfileView(isAuthenticated: $isAuthenticated, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .fontDesign(.rounded)
        .tint(.themePrimary)
    }
}

#Preview {
    MainTabView(isAuthenticated: .constant(true))
}
