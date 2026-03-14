//
//  MainTabView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1 // Create tab landing and set the initial value to Dashboard a tag of 1
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            EventView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
                .tag(0)
            
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
}
