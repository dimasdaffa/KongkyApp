//
//  MyActivitiesView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI

struct MyActivitiesView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    // Controls which tab is active
    @State private var selectedTab = "Joined"
    let tabs = ["Joined", "Created"]
    
    var body: some View {
        VStack {
            // 1. SEGMENTED CONTROL (The Tabs)
            Picker("Activity Type", selection: $selectedTab) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)
                }
            }
            // This modifier turns a standard dropdown into the classic iOS pill-toggle
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // 2. THE LIST OF ACTIVITIES
            List {
                // FILTER LOGIC:
                // We pretend "Alex" is our logged-in user.
                // If Created -> Show only Alex's events. If Joined -> Show others.
                let filteredEvents = selectedTab == "Created"
                    ? viewModel.events.filter { $0.organizerName == "Alex" }
                    : viewModel.events.filter { $0.organizerName != "Alex" }
                
                if filteredEvents.isEmpty {
                    Text("No activities found.")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(filteredEvents) { event in
                        EventRowView(event: event)
                            .padding(.vertical, 4)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            // --- HIG NATIVE SWIPE ACTIONS ---
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                
                                if selectedTab == "Created" {
                                    // 1. DELETE BUTTON (Defaults to Red)
                                    Button(role: .destructive) {
                                        deleteEvent(event: event)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    // 2. EDIT BUTTON (We make it Blue)
                                    Button {
                                        print("Edit clicked for \(event.title)")
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                    
                                } else {
                                    // 3. LEAVE BUTTON (For joined events)
                                    Button(role: .destructive) {
                                        deleteEvent(event: event)
                                    } label: {
                                        Label("Leave", systemImage: "rectangle.portrait.and.arrow.right")
                                    }
                                }
                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("My Activities")
        .navigationBarTitleDisplayMode(.inline)
        //Hide the main bottom tab bar when deep in a profile menu!
        .toolbar(.hidden, for: .tabBar)
    }
    
    func deleteEvent(event: Event) {
        if let index = viewModel.events.firstIndex(where: { $0.id == event.id }) {
            viewModel.events.remove(at: index)
        }
    }
}

#Preview {
    NavigationView {
        MyActivitiesView()
    }
}
