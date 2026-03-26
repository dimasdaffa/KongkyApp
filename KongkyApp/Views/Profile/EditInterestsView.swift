//
//  EditInterestsView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI

struct EditInterestsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let allCategories: [(name: String, icon: String)] = [
        ("Board Game", "dice.fill"),
        ("Tea Time", "cup.and.saucer.fill"),
        ("Sport", "basketball.fill"),
        ("Watch Party", "popcorn.fill"),
        ("Share Meal", "fork.knife"),
        ("Music", "music.note")
    ]
    
    @State private var selectedCategories: Set<String> = ["Board Game", "Sport", "Tea Time"]
    
    // NEW: Toast & Success States
    @State private var isSaved = false
    @State private var showToast = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.themeSurface.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Update your favorite activities to refresh your recommended feed.")
                        .font(.subheadline)
                        .foregroundColor(.themeTextVariant)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(allCategories, id: \.name) { item in
                            let isSelected = selectedCategories.contains(item.name)
                            
                            Button(action: {
                                if isSelected {
                                    selectedCategories.remove(item.name)
                                } else {
                                    selectedCategories.insert(item.name)
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }) {
                                VStack(spacing: 16) {
                                    Circle()
                                        .fill(isSelected ? Color.white.opacity(0.2) : Color(.systemGray6))
                                        .frame(width: 56, height: 56)
                                        .overlay(
                                            Image(systemName: item.icon)
                                                .font(.title2)
                                                .foregroundColor(isSelected ? .white : .themeText)
                                        )
                                    
                                    Text(item.name)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(isSelected ? .white : .themeText)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .background(isSelected ? Color.themePrimary : Color.white)
                                .cornerRadius(24)
                                .shadow(color: Color.black.opacity(0.03), radius: 15, x: 0, y: 8)
                                .scaleEffect(isSelected ? 0.96 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Color.clear.frame(height: 120)
                }
            }
            
            // --- STICKY BOTTOM ACTION AREA ---
            VStack(spacing: 16) {
                Button(action: {
                    if !isSaved {
                        saveInterests()
                    }
                }) {
                    HStack {
                        if isSaved {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Image(systemName: "checkmark")
                        }
                        Text(isSaved ? "Changes Saved" : "Save Changes")
                    }
                    .font(.headline)
                    .foregroundColor(isSaved ? .themeTextVariant : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    // Swap to disabled/gray states based on selection and success
                    .background(selectedCategories.isEmpty ? Color.gray.opacity(0.5) : (isSaved ? Color(.systemGray5) : Color.themePrimary))
                    .cornerRadius(30)
                    .shadow(color: (selectedCategories.isEmpty || isSaved) ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
                }
                .buttonStyle(SpringyButtonStyle())
                .disabled(selectedCategories.isEmpty || isSaved)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 24)
            .background(
                LinearGradient(colors: [Color.themeSurface.opacity(0), Color.themeSurface], startPoint: .top, endPoint: .bottom)
            )
            
            // NEW: TOP TOAST NOTIFICATION
            if showToast {
                toastNotification
            }
        }
        .navigationTitle("My Interests")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    
    private var toastNotification: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.title3)
                    .foregroundColor(.themePrimary)
                
                Text("Interests successfully updated!")
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
    
    func saveInterests() {
        // Trigger vibration
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Trigger animations
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isSaved = true
            showToast = true
        }
        
        // Wait 2 seconds, hide toast, then dismiss
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
    NavigationView {
        EditInterestsView()
    }
}
