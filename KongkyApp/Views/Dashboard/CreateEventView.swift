//
//  CreateEventView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI
import PhotosUI
import MapKit
import FirebaseAuth

struct CreateEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    
    // Form State
    @State private var title = ""
    @State private var description = ""
    @State private var locationText = ""
    
    @State private var selectedDate = Date()
    // NEW: Split into Start and End time
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Date().addingTimeInterval(3600) // Defaults to 1 hour later
    
    @State private var cost = ""
    @State private var category = "Board Game"
    @State private var maxCapacity = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var previewImage: UIImage? = nil
    
    @State private var mapPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.2300, longitude: 106.8075),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    ))
    @State private var selectedCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -6.2300, longitude: 106.8075)
    
    @State private var isCreated = false
    @State private var showToast = false
    
    // Validation Check
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !locationText.trimmingCharacters(in: .whitespaces).isEmpty &&
        !cost.isEmpty &&
        !maxCapacity.isEmpty
    }
    
    let categories = ["Board Game", "Tea Time", "Sport", "Watch Party", "Share Meal", "Other"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
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
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.themePrimary)
                }
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
            
            // --- NEW: FULL WIDTH DATE PICKER ---
            VStack(alignment: .leading, spacing: 8) {
                Text("DATE")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                    .tracking(1)
                
                HStack {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                        .accentColor(.themePrimary)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.themePrimary.opacity(0.05))
                .cornerRadius(16)
            }
            
            // --- NEW: SPLIT TIME PICKERS ---
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("START TIME")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.themeTextVariant)
                        .tracking(1)
                    
                    HStack {
                        DatePicker("", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .accentColor(.themePrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("END TIME")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.themeTextVariant)
                        .tracking(1)
                    
                    HStack {
                        DatePicker("", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .accentColor(.themePrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
                }
            }
            
            // --- UPDATED: STRICT NUMBER FILTERING ---
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("CAPACITY")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.themeTextVariant)
                        .tracking(1)
                    TextField("Max pax", text: $maxCapacity)
                        .keyboardType(.numberPad)
                    // Filters out letters
                        .onChange(of: maxCapacity) { _, newValue in
                            maxCapacity = newValue.filter { "0123456789".contains($0) }
                        }
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
                    // Filters out letters
                        .onChange(of: cost) { _, newValue in
                            cost = newValue.filter { "0123456789".contains($0) }
                        }
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
                if isFormValid && !isCreated {
                    saveEvent()
                }
            }) {
                HStack {
                    if isCreated {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    Text(isCreated ? "Activity Created" : "Create Activity")
                }
                .font(.headline)
                .foregroundColor(isCreated ? .themeTextVariant : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                // Use gray if invalid, success color if created, or primary blue if ready
                .background(!isFormValid ? Color.gray.opacity(0.5) : (isCreated ? Color(.systemGray5) : Color.themePrimary))
                .cornerRadius(30)
                .shadow(color: (!isFormValid || isCreated) ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
            }
            .buttonStyle(SpringyButtonStyle())
            // Lock the button until form is valid
            .disabled(!isFormValid || isCreated)
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
            
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(2)
    }
    
    // MARK: - Actions
    
    func saveEvent() {
        let costInt = Int(cost) ?? 0
        let capacityInt = Int(maxCapacity) ?? 5
        
        let df = DateFormatter()
        df.dateFormat = "MMM dd"
        let formattedDate = df.string(from: selectedDate)
        
        let tf = DateFormatter()
        tf.dateFormat = "HH:mm"
        let startString = tf.string(from: selectedStartTime)
        let endString = tf.string(from: selectedEndTime)
        let formattedTime = "\(startString) - \(endString)" // Creates "19:00 - 21:00"
        
        let currentUserEmail = Auth.auth().currentUser?.email ?? ""
        let newEvent = Event(
            title: title.isEmpty ? "Untitled Event" : title,
            description: description,
            location: locationText,
            date: formattedDate,
            time: formattedTime,
            cost: costInt,
            organizerName: Auth.auth().currentUser?.displayName ?? "Kongky User",
            organizerEmail: Auth.auth().currentUser?.email ?? "",
            category: category,
            maxCapacity: capacityInt,
            participantEmails: [currentUserEmail]
        )
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        /* viewModel.events.insert(newEvent, at: 0)*/ // Dummy
        viewModel.addEvent(event: newEvent)
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isCreated = true
            showToast = true
        }
        
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
    CreateEventView(viewModel: HomeViewModel())
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
