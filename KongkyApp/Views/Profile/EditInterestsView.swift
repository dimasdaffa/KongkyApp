//
//  EditInterestsView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI

struct EditInterestsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let allCategories = [
        "Board Game", "Tea Time", "Sport", "Watch Party",
        "Share Meal", "Music"
    ]
    
    @State private var selectedCategories: Set<String> = ["Board Game", "Sport"]
    
    let columns = [
        GridItem(.adaptive(minimum: 170, maximum: 180), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ScrollView(showsIndicators: false) {
                
                Text("Update your favorite activities to refresh your recommended feed.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allCategories, id: \.self) { category in
                        
                        let isSelected = selectedCategories.contains(category)
                        
                        Button(action: {
                            if isSelected {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            Text(category)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(isSelected ? Color.blue : Color(.tertiarySystemFill))
                                .foregroundColor(isSelected ? .white : .primary)
                                .cornerRadius(14)
                                .scaleEffect(isSelected ? 1.05 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            // --- SAVE BUTTON ---
            VStack {
                Button(action: {
                    // TODO: Later, save this updated Set to Firebase User Document
                    print("Updated interests to: \(selectedCategories)")
                    
                    // Close the page and go back to settings
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedCategories.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                        .cornerRadius(14)
                }
                .disabled(selectedCategories.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 0, y: -5)
        }
        .navigationTitle("My Interests")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        EditInterestsView()
    }
}
