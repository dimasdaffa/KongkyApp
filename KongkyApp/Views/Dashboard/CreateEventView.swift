//
//  CreateEventView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
    // Environment variable to dismiss this modal (like window.close() in JS)
    @Environment(\.presentationMode) var presentationMode
    // 2. We pass in our ViewModel so we can append the new event to it!
    @ObservedObject var viewModel: HomeViewModel
    
    // 3. Form State (Like v-model in Vue or wire:model in Livewire)
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var date = ""
    @State private var time = ""
    @State private var cost = ""
    @State private var category = "Board Game"
    @State private var maxCapacity = ""
    // Image Picker
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var previewImage: UIImage? = nil
    
    let categories = ["Board Game", "Tea Time", "Sport", "Watch Party", "Share Meal"]
    
    var body: some View {
        NavigationView {
            // SwiftUI's native Form wrapper
            Form {
                
                // --- 3. NEW THUMBNAIL SECTION ---
                Section(header: Text("Event Thumbnail")) {
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        HStack(spacing: 16) {
                            // If they picked an image, show it!
                            if let previewImage {
                                Image(uiImage: previewImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text("Change Photo")
                                    .foregroundColor(.blue)
                            } 
                            // Otherwise, show the default upload icon
                            else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                
                                Text("Select a photo")
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    // When the user picks a photo, this converts it to usable data!
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                previewImage = UIImage(data: data)
                            }
                        }
                    }
                }
                
                Section(header: Text("Basic Info")) {
                    TextField("Event Title", text: $title)
                    // Picker is a native dropdown menu
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Details")) {
                    TextField("Location (e.g., Thamrin Nine)", text: $location)
                    TextField("Date (e.g., Jun 24)", text: $date)
                    TextField("Time (e.g., 19:00 - 21:00)", text: $time)
                }
                
                Section(header: Text("Capacity & Cost")) {
                    // .keyboardType ensures the user only sees the number pad!
                    TextField("Max Capacity (e.g., 5)", text: $maxCapacity)
                        .keyboardType(.numberPad)
                    TextField("Cost in IDR (e.g., 50000)", text: $cost)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Left side: Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
                // Right side: Save Button (Our Controller's Store method)
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEvent()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer() // This pushes the button to the far right!
                    
                    Button("Done") {
                        hideKeyboard()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                }
            }
        }
    }
    
    // THE STORE METHOD
    func saveEvent() {
        // Convert strings to ints (default to 0 if they typed letters by accident)
        let costInt = Int(cost) ?? 0
        let capacityInt = Int(maxCapacity) ?? 5
        
        let newEvent = Event(
            title: title.isEmpty ? "Untitled Event" : title,
            description: description,
            location: location,
            date: date,
            time: time,
            cost: costInt,
            organizerName: "Alex",
            category: category,
            maxCapacity: capacityInt,
            joinedParticipants: 1 // Start with 1 (the creator)
        )
        
        // Push the new event to the top of the array
        viewModel.events.insert(newEvent, at: 0)
        
        // Close the modal
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    CreateEventView(viewModel: HomeViewModel())
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
