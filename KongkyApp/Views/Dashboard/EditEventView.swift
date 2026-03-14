//
//  EditEventView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    
    // The event we are currently editing
    let event: Event
    
    // Form State
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var date = ""
    @State private var time = ""
    @State private var cost = ""
    @State private var category = "Board Game"
    @State private var maxCapacity = ""
    
    let categories = ["Board Game", "Tea Time", "Sport", "Watch Party", "Share Meal"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Event Title", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Details")) {
                    TextField("Location", text: $location)
                    TextField("Date", text: $date)
                    TextField("Time", text: $time)
                }
                
                Section(header: Text("Capacity & Cost")) {
                    TextField("Max Capacity", text: $maxCapacity)
                        .keyboardType(.numberPad)
                    TextField("Cost in IDR", text: $cost)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        updateEvent()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                }
            }
            // PRE-FILLS THE FORM
            .onAppear {
                title = event.title
                description = event.description
                location = event.location
                date = event.date
                time = event.time
                cost = String(event.cost)
                category = event.category
                maxCapacity = String(event.maxCapacity)
            }
        }
    }
    
    func updateEvent() {
        let costInt = Int(cost) ?? 0
        let capacityInt = Int(maxCapacity) ?? 5
        
        // 1. Create a fresh Event struct with the updated details
        let updatedEvent = Event(
            title: title.isEmpty ? "Untitled Event" : title,
            description: description,
            location: location,
            date: date,
            time: time,
            cost: costInt,
            organizerName: event.organizerName, // Keep original creator
            category: category,
            maxCapacity: capacityInt,
            joinedParticipants: event.joinedParticipants // Keep current participants
        )
        
        // 2. Find the old event in our ViewModel and replace it!
        if let index = viewModel.events.firstIndex(where: { $0.id == event.id }) {
            viewModel.events[index] = updatedEvent
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditEventView(
        viewModel: HomeViewModel(),
        event: Event(
            title: "Board Game DND",
            description: "The most unforgettable night you could have in your life is available on Thamrin Nine.",
            location: "Thamrin Nine Pantry",
            date: "Jun 16",
            time: "19:00 - 21:00",
            cost: 20000,
            organizerName: "Christoffer Wong",
            category: "Board Game",
            maxCapacity: 5,
            joinedParticipants: 8
        )
    )
}
