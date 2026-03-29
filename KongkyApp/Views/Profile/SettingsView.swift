//
//  SettingsView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    // Kick the user out when they delete their account
    @Binding var isAuthenticated: Bool
    
    @State private var username = ""
    @State private var session = "Afternoon"
    @State private var email = ""
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    
    // Image Picker State
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: UIImage? = nil
    
    // Alert & Toast States
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showDeleteAlert = false
    
    // Error Alert States
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.themeSurface.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    headerSection
                        .padding(.top, 16)
                    
                    profileInfoSection
                    
                    interestsSection
                    
                    securitySection
                    
                    dangerZoneSection
                    
                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.interactively)
            
            // The Top Toast Notification
            if showToast {
                toastNotification
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            // Load the saved session from the device, and name/email from Firebase
            username = Auth.auth().currentUser?.displayName ?? "User Name"
            email = Auth.auth().currentUser?.email ?? "No Email"
            session = UserDefaults.standard.string(forKey: "preferredSession") ?? "Afternoon"
        }
        
        // Danger Zone Confirmation Alert
        .alert("Delete Account?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete Account", role: .destructive) {
                deleteAccountAndData()
            }
        } message: {
            Text("Are you sure you want to permanently delete your account and all activities you have hosted? This action cannot be undone.")
        }
        // Firebase Error Alert
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                ZStack(alignment: .bottomTrailing) {
                    if let profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray3))
                                .frame(width: 100, height: 100)
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    }
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.themePrimary)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -4, y: -4)
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        profileImage = UIImage(data: data)
                    }
                }
            }
            
            VStack(spacing: 4) {
                Text(username)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeText)
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.themeTextVariant)
            }
        }
    }
    
    private var profileInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(spacing: 8) {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(.themePrimary)
                Text("Profile Information")
                    .font(.headline)
                    .foregroundColor(.themeText)
            }
            .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Full Name")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                
                TextField("Your name", text: $username)
                    .padding(16)
                    .background(Color(.systemGray6).opacity(0.6))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email Address")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                
                HStack {
                    Text(email)
                        .foregroundColor(.themeTextVariant)
                    Spacer()
                    Image(systemName: "lock")
                        .foregroundColor(.themeTextVariant)
                        .font(.caption)
                }
                .padding(16)
                .background(Color(.systemGray6).opacity(0.6))
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Academy Session")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                
                HStack(spacing: 12) {
                    sessionButton(title: "Morning", icon: "sun.max", isSelected: session == "Morning")
                    sessionButton(title: "Afternoon", icon: "moon", isSelected: session == "Afternoon")
                }
            }
            
            Button(action: {
                updateProfile()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                    Text("Save Profile")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(username.isEmpty ? Color(.systemGray4) : Color.themePrimary)
                .cornerRadius(12)
            }
            .buttonStyle(SpringyButtonStyle())
            .disabled(username.isEmpty)
            .padding(.top, 8)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 4)
    }
    
    private func sessionButton(title: String, icon: String, isSelected: Bool) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                session = title
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(isSelected ? .themePrimary : .themeTextVariant)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.themePrimary : Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var interestsSection: some View {
        NavigationLink(destination: EditInterestsView()) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "heart")
                        .foregroundColor(.orange)
                        .font(.headline)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Interests")
                        .font(.headline)
                        .foregroundColor(.themeText)
                    Text("Hiking, Board Games, Coffee Tasting")
                        .font(.caption)
                        .foregroundColor(.themeTextVariant)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.systemGray4))
                    .font(.caption)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var securitySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(spacing: 8) {
                Image(systemName: "shield.checkerboard")
                    .foregroundColor(.themePrimary)
                Text("Security")
                    .font(.headline)
                    .foregroundColor(.themeText)
            }
            .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("New Password")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.themeTextVariant)
                
                PasswordToggleField(placeholder: "Min. 8 characters", text: $newPassword)
            }
            
            Button(action: {
                updatePassword()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Update Password")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(newPassword.isEmpty ? Color(.systemGray4) : Color.themePrimary)
                .cornerRadius(12)
            }
            .buttonStyle(SpringyButtonStyle())
            .disabled(newPassword.isEmpty)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 4)
    }
    
    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                Text("Danger Zone")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            Text("Once you delete your account, there is no going back. Please be certain.")
                .font(.subheadline)
                .foregroundColor(.themeTextVariant)
                .lineSpacing(4)
                .padding(.bottom, 8)
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                showDeleteAlert = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Account")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .background(Color(red: 0.72, green: 0.11, blue: 0.11))
                .cornerRadius(12)
            }
            .buttonStyle(SpringyButtonStyle())
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.03))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .foregroundColor(Color.red.opacity(0.3))
        )
    }
    
    private var toastNotification: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.themePrimary)
                
                Text(toastMessage)
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
    
    // MARK: - Firebase & System Actions
    
    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        // 1. Save Session locally to the device
        UserDefaults.standard.set(session, forKey: "preferredSession")
        
        // 2. Save Name to Firebase
        let request = user.createProfileChangeRequest()
        request.displayName = username
        request.commitChanges { error in
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                toastMessage = "Profile successfully updated!"
                showToastSequence()
            }
        }
    }
    
    private func updatePassword() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.updatePassword(to: newPassword) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                if errorMessage.contains("requires recent authentication") {
                    errorMessage = "For security reasons, please log out and log back in before updating your password."
                }
                showErrorAlert = true
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                newPassword = ""
                toastMessage = "Password successfully updated!"
                showToastSequence()
            }
        }
    }
    
    // Helper to fire the toast animation cleanly
    private func showToastSequence() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false
            }
        }
    }
    
    private func deleteAccountAndData() {
        guard let user = Auth.auth().currentUser, let userEmail = user.email else { return }
        let db = Firestore.firestore()
        
        db.collection("activities").whereField("organizerEmail", isEqualTo: userEmail).getDocuments { snapshot, error in
            if let error = error {
                print("Error finding activities to delete: \(error.localizedDescription)")
            }
            
            let batch = db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { batchError in
                if let batchError = batchError {
                    print("Error deleting activities: \(batchError.localizedDescription)")
                }
                
                user.delete { authError in
                    if let authError = authError {
                        errorMessage = authError.localizedDescription
                        if errorMessage.contains("requires recent authentication") {
                            errorMessage = "For security reasons, please log out and log back in before deleting your account."
                        }
                        showErrorAlert = true
                    } else {
                        withAnimation {
                            isAuthenticated = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Reusable Custom Password Field
struct PasswordToggleField: View {
    var placeholder: String
    @Binding var text: String
    @State private var isVisible: Bool = false
    
    var body: some View {
        HStack {
            if isVisible {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            Button(action: {
                isVisible.toggle()
            }) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.themeTextVariant)
            }
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        SettingsView(isAuthenticated: .constant(true))
    }
}
