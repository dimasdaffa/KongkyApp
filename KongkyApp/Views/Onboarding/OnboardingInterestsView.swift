//
//  OnboardingInterestsView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI

// A simple struct to pair the category names with their icons
struct InterestItem: Hashable {
    let name: String
    let icon: String
}

struct OnboardingInterestsView: View {
    @Binding var isAuthenticated: Bool
    // Mapping categories to SF Symbols matching the design
    let allCategories: [InterestItem] = [
        InterestItem(name: "Board Game", icon: "dice.fill"),
        InterestItem(name: "Tea Time", icon: "cup.and.saucer.fill"),
        InterestItem(name: "Sport", icon: "basketball.fill"),
        InterestItem(name: "Watch Party", icon: "popcorn.fill"),
        InterestItem(name: "Share Meal", icon: "fork.knife"),
        InterestItem(name: "Music", icon: "music.note")
    ]
    
    @State private var selectedCategories: Set<String> = []
    @State private var navigateToHome = false
    
    // 2-column grid
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.themeSurface.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // --- 1. HEADER ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What are you into?")
                            .font(.system(size: 34, weight: .heavy, design: .default))
                            .foregroundColor(.themeText)
                        
                        Text("Pick your favorite activities to find the best local hangouts and split costs easily.")
                            .font(.subheadline)
                            .foregroundColor(.themeTextVariant)
                            .lineSpacing(4)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    
                    // --- 2. INTERACTIVE GRID ---
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
                                    // The Circle Icon Container
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
                    
                    // --- 3. FEATURED ACTIVITY BANNER ---
                    ZStack(alignment: .bottomLeading) {
                        // Placeholder for the featured image
                        Rectangle()
                            .fill(Color(.systemGray4))
                            .frame(height: 140)
                            .overlay(
                                // A subtle gradient to make the white pill pop if the image is bright
                                LinearGradient(colors: [.clear, .black.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                            )
                        
                        Text("FEATURED ACTIVITY")
                            .font(.caption2)
                            .fontWeight(.heavy)
                            .foregroundColor(.themePrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(16)
                    }
                    .cornerRadius(24)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    Color.clear.frame(height: 140) // Breathing room for the sticky bottom bar
                }
            }
            
            // --- 4. STICKY BOTTOM ACTION AREA ---
            VStack(spacing: 16) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    navigateToHome = true
                }) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(selectedCategories.isEmpty ? Color.gray.opacity(0.5) : Color.themePrimary)
                    .cornerRadius(30)
                    .shadow(color: selectedCategories.isEmpty ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
                }
                .buttonStyle(SpringyButtonStyle())
                .disabled(selectedCategories.isEmpty)
                
                Text("YOU CAN CHANGE THESE PREFERENCES LATER IN SETTINGS")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.themeTextVariant)
                    .tracking(0.5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 24)
            .background(
                LinearGradient(colors: [Color.themeSurface.opacity(0), Color.themeSurface], startPoint: .top, endPoint: .bottom)
            )
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            MainTabView(isAuthenticated: $isAuthenticated)
        }
    }
}
    
    #Preview {
        OnboardingInterestsView(isAuthenticated: .constant(true)) 
    }
