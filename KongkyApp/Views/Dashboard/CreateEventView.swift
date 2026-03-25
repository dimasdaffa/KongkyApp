//
//  CreateEventView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI
import PhotosUI
import MapKit

struct CreateEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    
    // Form State
    @State private var title = ""
    @State private var description = ""
    @State private var locationText = ""
    @State private var date = ""
    @State private var time = ""
    @State private var cost = ""
    @State private var category = "Board Game"
    @State private var maxCapacity = ""
    
    // Image Picker
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var previewImage: UIImage? = nil
    
    // Map State (Dummy initial center for Jakarta to act as a placeholder)
    @State private var mapPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.2300, longitude: 106.8075),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    ))
    @State private var selectedCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -6.2300, longitude: 106.8075)
    
    @State private var isCreated = false
    @State private var showToast = false
    
    // Added "Other" to the categories!
    let categories = ["Board Game", "Tea Time", "Sport", "Watch Party", "Share Meal", "Other"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Layer 0: Base Background
                Color.themeSurface.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // 1. Photo Upload (Dashed Border)
                        photoUploadSection
                        
                        // 2. Main Form Card (No dividers, just spacing!)
                        VStack(alignment: .leading, spacing: 32) {
                            basicInfoSection
                            detailsSection
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
                        
                        Color.clear.frame(height: 120) // Breathing room for the sticky button
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                
                // 3. Sticky Bottom Button
                stickyCreateButton
                if showToast {
                    toastNotification
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var photoUploadSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            ZStack {
                // Dashed border background
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]), antialiased: true)
                    .foregroundColor(Color.gray.opacity(0.4))
                    .background(Color.gray.opacity(0.1).cornerRadius(24))
                
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 40))
                            .foregroundColor(.themePrimary)
                        Text("Select a photo")
                            .font(.headline)
                            .foregroundColor(.themePrimary)
                        Text("Recommended: 16:9 ratio")
                            .font(.caption)
                            .foregroundColor(.themeTextVariant)
                    }
                }
            }
            .frame(height: 220)
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    previewImage = UIImage(data: data)
                }
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Basic Info")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.themeText)
            
            // Title Input
            VStack(alignment: .leading, spacing: 8) {
                Text("ACTIVITY TITLE")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
                TextField("What are we doing?", text: $title)
                    .padding(16)
                // The soft tinted background for inputs!
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
            }
            
            // Category Selector (Horizontal scroll for pills)
            VStack(alignment: .leading, spacing: 12) {
                Text("CATEGORY")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { cat in
                            let isSelected = category == cat
                            Button(action: {
                                category = cat
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }) {
                                Text(cat)
                                    .font(.subheadline)
                                    .fontWeight(isSelected ? .semibold : .regular)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(isSelected ? Color.themePrimary : Color(.systemGray6))
                                    .foregroundColor(isSelected ? .white : .themeText)
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
            }
            
            // Description Input (Multiline)
            VStack(alignment: .leading, spacing: 8) {
                Text("DESCRIPTION")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
                // Using axis: .vertical allows the text field to grow automatically!
                TextField("Tell everyone more about the vibe...", text: $description, axis: .vertical)
                    .lineLimit(4...8)
                    .padding(16)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("The Details")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.themeText)
                .padding(.top, 8)
            
            // Map / Location Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("LOCATION NAME")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
                // 1. The user types the human-readable name here (e.g. "Thamrin Nine")
                TextField("E.g. Agora Mall", text: $locationText)
                    .padding(16)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
                
                Text("DRAG MAP TO SET EXACT PIN")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                    .padding(.top, 8)
                
                // 2. The Interactive Map Picker
                ZStack(alignment: .center) {
                    
                    // Notice we REMOVED .disabled(true) so the user can swipe around!
                    Map(position: $mapPosition)
                        .frame(height: 180) // Made it slightly taller so it's easier to drag
                        .cornerRadius(16)
                    // HIG Feature: This listens to the user dragging the map
                        .onMapCameraChange(frequency: .onEnd) { context in
                            // When they let go of the screen, we grab the exact center coordinate!
                            selectedCoordinate = context.region.center
                            
                            // Optional: Print to console so you can see it working!
                            print("User dropped pin at: \(selectedCoordinate.latitude), \(selectedCoordinate.longitude)")
                        }
                    
                    // 3. The Fixed Center Pin
                    // Because this is in a ZStack, it always stays perfectly in the middle of the box while the map moves underneath it!
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.themePrimary)
                        
                        // A tiny shadow dot under the pin to make it look 3D (Digital Concierge vibe!)
                        Ellipse()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: 12, height: 6)
                    }
                    .offset(y: -16) // Lifts the pin up slightly so the "point" is in the exact center
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
            }
            
            // Date & Time Row (Split 50/50)
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("DATE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.themeTextVariant)
                        .tracking(1)
                    TextField("E.g. Jun 24", text: $date)
                        .padding(16)
                        .background(Color.themePrimary.opacity(0.05))
                        .cornerRadius(16)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("TIME")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.themeTextVariant)
                        .tracking(1)
                    TextField("E.g. 19:00", text: $time)
                        .padding(16)
                        .background(Color.themePrimary.opacity(0.05))
                        .cornerRadius(16)
                }
            }
            
            // Capacity & Cost Row
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("CAPACITY")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.themeTextVariant)
                        .tracking(1)
                    TextField("Max pax", text: $maxCapacity)
                        .keyboardType(.numberPad)
                        .padding(16)
                        .background(Color.themePrimary.opacity(0.05))
                        .cornerRadius(16)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("TOTAL COST (IDR)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.themeTextVariant)
                        .tracking(1)
                    TextField("E.g. 50000", text: $cost)
                        .keyboardType(.numberPad)
                        .padding(16)
                        .background(Color.themePrimary.opacity(0.05))
                        .cornerRadius(16)
                }
            }
        }
    }
    
    private var stickyCreateButton: some View {
        VStack {
            Button(action: {
                // Prevent double-tapping while the success animation is playing
                if !isCreated {
                    saveEvent()
                }
            }) {
                HStack {
                    // Show a checkmark when successfully created
                    if isCreated {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    Text(isCreated ? "Activity Created" : "Create Activity")
                }
                .font(.headline)
                .foregroundColor(isCreated ? .themeTextVariant : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                // Swap from Primary Blue to Soft Gray on success
                .background(isCreated ? Color(.systemGray5) : Color.themePrimary)
                .cornerRadius(30)
                // Remove the shadow so it looks pressed into the screen
                .shadow(color: isCreated ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
            }
            .buttonStyle(SpringyButtonStyle())
            .disabled(isCreated)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(.ultraThinMaterial)
    }
    
    private var toastNotification: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.title3)
                    .foregroundColor(.themePrimary)
                
                Text("Activity successfully created!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.themeText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
            .padding(.top, 16)
            
            Spacer() // Pushes the toast to the top
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(2)
    }
    
    // MARK: - Actions
    
    func saveEvent() {
        let costInt = Int(cost) ?? 0
        let capacityInt = Int(maxCapacity) ?? 5
        
        let newEvent = Event(
            title: title.isEmpty ? "Untitled Event" : title,
            description: description,
            location: locationText,
            date: date,
            time: time,
            cost: costInt,
            organizerName: "Alex Morgan",
            category: category,
            maxCapacity: capacityInt,
            joinedParticipants: 1
        )
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Add it to your data
        viewModel.events.insert(newEvent, at: 0)
        
        // Animate the button changing and the toast dropping down
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isCreated = true
            showToast = true
        }
        
        // Wait 2 seconds so the user can enjoy the success state, THEN close the modal!
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false // Slide the toast back up
            }
            
            // Add a tiny micro-delay after the toast disappears before closing the whole page
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                presentationMode.wrappedValue.dismiss()
            }
        }
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
