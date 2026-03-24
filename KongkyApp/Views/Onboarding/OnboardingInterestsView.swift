//
//  OnboardingInterestsView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI

struct OnboardingInterestsView: View {
    // The list of all possible interests
    let allCategories = [
        "Board Game", "Tea Time", "Sport", "Watch Party",
        "Share Meal", "Music"
    ]
    
    // A Set to track what the user has tapped
    @State private var selectedCategories: Set<String> = []
    
    @State private var navigateToHome = false
    
    // Apple's native grid layout!
    let columns = [
        GridItem(.adaptive(minimum: 170, maximum: 180), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("What are you into?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Pick your favorite activities so we can recommend the best events for you.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(.top, 40)
            .padding(.horizontal)
            .padding(.bottom, 24)
            
            // --- THE INTERACTIVE GRID ---
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allCategories, id: \.self) { category in
                        
                        let isSelected = selectedCategories.contains(category)
                        
                        Button(action: {
                            // Toggle logic: If it's there, remove it. If not, add it.
                            if isSelected {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                            // Add a tiny haptic tap when they click
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            Text(category)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                            // Change colors based on whether it's selected
                                .background(isSelected ? Color.blue : Color(.tertiarySystemFill))
                                .foregroundColor(isSelected ? .white : .primary)
                                .cornerRadius(14)
                            // A fun, subtle bounce effect when selected
                                .scaleEffect(isSelected ? 1.05 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            // --- STICKY BOTTOM BUTTON ---
            VStack {
                Button(action: {
                    navigateToHome = true
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    // If they haven't picked anything, gray it out!
                        .background(selectedCategories.isEmpty ? Color.gray.opacity(0.5) : Color.primary)
                        .cornerRadius(14)
                }
                // Disable the button until they pick at least one thing
                .disabled(selectedCategories.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 0, y: -5)
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            MainTabView()
        }
    }
}
    
    #Preview {
        OnboardingInterestsView()
    }
