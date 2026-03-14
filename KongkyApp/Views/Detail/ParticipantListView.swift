//
//  ParticipantListView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct ParticipantsListView: View {
    let event: Event
    
    var body: some View {
        List {
            Section(header: Text("Main Slots (\(event.mainSlotsFilled)/\(event.maxCapacity))")) {
                ForEach(0..<event.mainSlotsFilled, id: \.self) { index in
                    // We pass a dynamically generated name and a flag to style it
                    ParticipantRow(name: "Participant \(index + 1)", isQueue: false)
                }
            }
            
            // QUEUE SECTION (Only shows if there are people in the queue)
            if event.queueCount > 0 {
                Section(header: Text("Mingling / Queue (\(event.queueCount))")) {
                    ForEach(0..<event.queueCount, id: \.self) { index in
                        // We set isQueue to true so we can gray out their styling a bit
                        ParticipantRow(name: "Queue Member \(index + 1)", isQueue: true)
                    }
                }
            }
        }
        .navigationTitle("Participants")
    }
}

struct ParticipantRow: View {
    let name: String
    let isQueue: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // 1. PROFILE AVATAR
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isQueue ? .gray.opacity(0.5) : .blue.opacity(0.7))
            
            // 2. NAME
            Text(name)
                .font(.body)
                .fontWeight(isQueue ? .regular : .semibold)
                .foregroundColor(isQueue ? .gray : .primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        ParticipantsListView(event: Event(
            title: "Board Game Night",
            description: "Dummy desc",
            location: "Thamrin Nine",
            date: "12 Dec",
            time: "19:00",
            cost: 20000,
            organizerName: "Alex",
            category: "Board Game",
            maxCapacity: 5,
            joinedParticipants: 8 
        ))
    }
}

