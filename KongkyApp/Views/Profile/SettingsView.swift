//
//  SettingsView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @State private var username = "Alex"
    @State private var session = "Morning"
    @State private var email = "alex@example.com"
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var profileImage: UIImage? = nil
    
    let sessions = ["Morning", "Afternoon"]
    
    var body: some View {
        Form {
            
            Section {
                HStack {
                    Spacer() // Centers the content
                    
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        VStack(spacing: 12) {
                            // If they selected an image, show it
                            if let profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                            // Otherwise, show the default gray placeholder
                            else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color(.systemGray4))
                            }
                            
                            Text("Edit picture")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    // Triggers when a photo is selected
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                profileImage = UIImage(data: data)
                            }
                        }
                    }
                    
                    Spacer() // Centers the content
                }
                .padding(.vertical, 10)
            }
            // Removes the white background block, making the avatar float!
            .listRowBackground(Color.clear)
            
            
            // 1. PROFILE INFO SECTION
            Section(header: Text("Profile Information")) {
                HStack {
                    Text("Name")
                        .frame(width: 80, alignment: .leading)
                    TextField("Username", text: $username)
                        .foregroundColor(.secondary)
                }
                
                Picker("Session", selection: $session) {
                    ForEach(sessions, id: \.self) { s in
                        Text(s)
                    }
                }
                
                HStack {
                    Text("Email")
                        .frame(width: 80, alignment: .leading)
                    TextField("Email", text: $email)
                        .foregroundColor(.gray)
                        .disabled(true) // Usually disabled in standard settings
                }
            }
            
            // 2. SECURITY SECTION
            Section(header: Text("Security")) {
                SecureField("Current Password", text: $currentPassword)
                SecureField("New Password", text: $newPassword)
                
                Button(action: {
                    print("Password update clicked")
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Update Password")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .disabled(currentPassword.isEmpty || newPassword.isEmpty)
            }
            
            // 3. DANGER ZONE
            Section {
                Button(action: {
                    print("Delete account clicked")
                }) {
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
