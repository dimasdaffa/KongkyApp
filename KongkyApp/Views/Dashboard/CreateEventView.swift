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
    
    @State private var selectedDate = Date()
    // Split into Start and End time
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
    @State private var isUploading = false
    
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
    
    // ---------------------------------------------------------
    // REFACTORED: Uses StyledTextField and CategoryPicker
    // from Components/EventFormFields.swift
    // Before: ~60 lines of hand-written UI code
    // After:  ~15 lines using reusable components
    // ---------------------------------------------------------
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Basic Info")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.themeText)
            
            // Reusable component! Same styling as EditEventView automatically.
            StyledTextField(label: "ACTIVITY TITLE", placeholder: "What are we doing?", text: $title)
            
            // Reusable category picker with haptic feedback built in
            CategoryPicker(selectedCategory: $category, categories: categories)
            
            // Multiline text field for descriptions
            StyledTextField(label: "DESCRIPTION", placeholder: "Tell everyone more about the vibe...", text: $description, isMultiline: true)
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
            
            // Reusable number-only fields (numbersOnly: true auto-strips letters)
            HStack(spacing: 16) {
                StyledTextField(label: "CAPACITY", placeholder: "Max pax", text: $maxCapacity, keyboardType: .numberPad, numbersOnly: true)
                StyledTextField(label: "TOTAL COST (IDR)", placeholder: "E.g. 50000", text: $cost, keyboardType: .numberPad, numbersOnly: true)
            }
        }
    }
    
    private var stickyCreateButton: some View {
        VStack {
            Button(action: {
                if isFormValid && !isCreated {
                    isUploading = true
                    saveEvent()
                }
            }) {
                HStack {
                    if isUploading {
                        ProgressView().tint(.white)
                        Text("Uploading...")
                    } else if isCreated {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Activity Created")
                    } else {
                        Text("Create Activity")
                    }
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
            .disabled(!isFormValid || isCreated || isUploading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(.ultraThinMaterial)
    }
    
    // Replaced 28 lines of toast UI with the reusable ToastView component!
    private var toastNotification: some View {
        ToastView(icon: "sparkles", message: "Activity successfully created!")
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
        let formattedTime = "\(startString) - \(endString)"
        let currentUserEmail = CurrentUser.email
        let currentUserName = CurrentUser.displayName
        let newEvent = Event(
            title: title.isEmpty ? "Untitled Event" : title,
            description: description,
            location: locationText,
            date: formattedDate,
            time: formattedTime,
            cost: costInt,
            organizerName: CurrentUser.displayName,
            organizerEmail: CurrentUser.email,
            category: category,
            maxCapacity: capacityInt,
            participants: [EventParticipant(email: currentUserEmail, name: currentUserName)]
        )
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        viewModel.addEvent(event: newEvent, image: previewImage){
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            // Animation after upload finish
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isUploading = false
                isCreated = true
                showToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 03)){
                    showToast = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
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

