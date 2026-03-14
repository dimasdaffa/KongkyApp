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
                ForEach(0..<event.mainSlotsFilled, id: \.self) { _ in
                    Text("Participant Name")
                }
            }
            
            if event.queueCount > 0 {
                Section(header: Text("Mingling / Queue (\(event.queueCount))")) {
                    ForEach(0..<event.queueCount, id: \.self) { _ in
                        Text("Queue Member")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Participants")
    }
}

