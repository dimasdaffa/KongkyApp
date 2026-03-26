//
//  EditEventView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI
import PhotosUI
import MapKit

struct EditEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    
    let event: Event
    
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
    
    // Map State
    @State private var mapPosition: MapCameraPosition = .automatic
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    
    // NEW: Toast & Success State
    @State private var isUpdated = false
    @State private var showToast = false
    
    let categories = ["Board Game", "Tea Time", "Sport", "Watch Party", "Share Meal", "Other"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Layer 0: Base Background
                Color.themeSurface.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        photoUploadSection
                        
                        VStack(alignment: .leading, spacing: 32) {
                            basicInfoSection
                            detailsSection
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
                        
                        Color.clear.frame(height: 120)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                
                stickyUpdateButton
                
                // NEW: The Top Toast Notification
                if showToast {
                    toastNotification
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
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.themePrimary)
                }
            }
            .onAppear {
                title = event.title
                description = event.description
                locationText = event.location
                date = event.date
                time = event.time
                cost = String(event.cost)
                category = event.category
                maxCapacity = String(event.maxCapacity)
                
                selectedCoordinate = event.coordinate
                mapPosition = .region(MKCoordinateRegion(
                    center: event.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                ))
            }
        }
    }
    
    // MARK: - Subviews
    
    private var photoUploadSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            ZStack {
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
                        Text("Change photo")
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
            
            VStack(alignment: .leading, spacing: 8) {
                Text("ACTIVITY TITLE")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
                TextField("What are we doing?", text: $title)
                    .padding(16)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
            }
            
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
            
            VStack(alignment: .leading, spacing: 8) {
                Text("DESCRIPTION")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
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
            
            VStack(alignment: .leading, spacing: 8) {
                Text("LOCATION NAME")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
                TextField("E.g. Meeple Cove Cafe", text: $locationText)
                    .padding(16)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
                
                Text("DRAG MAP TO SET EXACT PIN")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                    .padding(.top, 8)
                
                ZStack(alignment: .center) {
                    Map(position: $mapPosition)
                        .frame(height: 180)
                        .cornerRadius(16)
                        .onMapCameraChange(frequency: .onEnd) { context in
                            selectedCoordinate = context.region.center
                        }
                    
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.themePrimary)
                        
                        Ellipse()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: 12, height: 6)
                    }
                    .offset(y: -16)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
            }
            
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
    
    // NEW: Dynamic Button State
    private var stickyUpdateButton: some View {
        VStack {
            Button(action: {
                if !isUpdated {
                    updateEvent()
                }
            }) {
                HStack {
                    if isUpdated {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    Text(isUpdated ? "Activity Updated" : "Update Activity")
                }
                .font(.headline)
                .foregroundColor(isUpdated ? .themeTextVariant : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isUpdated ? Color(.systemGray5) : Color.themePrimary)
                .cornerRadius(30)
                .shadow(color: isUpdated ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
            }
            .buttonStyle(SpringyButtonStyle())
            .disabled(isUpdated)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(.ultraThinMaterial)
    }
    
    // NEW: The Toast View
    private var toastNotification: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.title3)
                    .foregroundColor(.themePrimary)
                
                Text("Activity successfully updated!")
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
            
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(2)
    }
    
    // MARK: - Actions
    
    func updateEvent() {
        var updatedEvent = event
        
        updatedEvent.title = title.isEmpty ? "Untitled Event" : title
        updatedEvent.description = description
        updatedEvent.location = locationText
        updatedEvent.date = date
        updatedEvent.time = time
        updatedEvent.cost = Int(cost) ?? event.cost
        updatedEvent.category = category
        updatedEvent.maxCapacity = Int(maxCapacity) ?? event.maxCapacity
        
        if let index = viewModel.events.firstIndex(where: { $0.id == event.id }) {
            viewModel.events[index] = updatedEvent
        }
        
        // Trigger vibration
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Trigger animations
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isUpdated = true
            showToast = true
        }
        
        // Wait 2 seconds, then dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                presentationMode.wrappedValue.dismiss()
            }
        }
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
