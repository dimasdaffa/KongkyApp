//
//  ProfileView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Layer 0: Premium Soft Background
                Color.themeSurface.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        
                        profileHeader
                        
                        statsRow
                        
                        menuSection
                        
                        logoutSection
                        
                        // Extra breathing room at the bottom
                        Color.clear.frame(height: 40)
                    }
                    .padding(.top, 24)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Subviews (Broken down for clean code & compiler speed)
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Image with a subtle glow
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: 110, height: 110)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    )
                    .shadow(color: Color.themePrimary.opacity(0.15), radius: 20, x: 0, y: 10)
                
                // Verified / Pro Badge
//                Image(systemName: "checkmark.seal.fill")
//                    .font(.title2)
//                    .foregroundColor(.themePrimary)
//                    .background(Circle().fill(Color.white))
//                    .offset(x: -4, y: -4)
            }
            
            VStack(spacing: 4) {
                Text("Alex Morgan")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(.themeText)
                
                Text("alex@example.com")
                    .font(.subheadline)
                    .foregroundColor(.themeTextVariant)
            }
            
            // Session Pill
            Text("MORNING SESSION")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.themePrimary)
                .tracking(1)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.themePrimary.opacity(0.1))
                .cornerRadius(20)
        }
    }
    
    private var statsRow: some View {
        HStack(spacing: 40) {
            VStack(spacing: 4) {
                Text("12")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeText)
                Text("Joined")
                    .font(.caption)
                    .foregroundColor(.themeTextVariant)
            }
            
            // A tiny dot to separate the stats visually
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 4, height: 4)
            
            VStack(spacing: 4) {
                Text("3")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.themeText)
                Text("Hosted")
                    .font(.caption)
                    .foregroundColor(.themeTextVariant)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
    }
    
    private var menuSection: some View {
        VStack(spacing: 4) {
            NavigationLink(destination: MyActivitiesView()) {
                ProfileMenuRow(icon: "ticket.fill", title: "My Activities")
            }
            .buttonStyle(PlainButtonStyle())
            
            // "Ghost Line" instead of a harsh Divider
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            NavigationLink(destination: SavedEventsView()) {
                ProfileMenuRow(icon: "heart.fill", title: "Saved Events")
            }
            .buttonStyle(PlainButtonStyle())
            
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            NavigationLink(destination: SettingsView()) {
                ProfileMenuRow(icon: "gearshape.fill", title: "Settings")
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(24)
        .padding(.horizontal, 20)
        .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
    }
    
    private var logoutSection: some View {
        Button(action: {
            // Trigger logout logic
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                }
                
                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
        }
        .buttonStyle(SpringyButtonStyle()) // Using our custom spring bounce!
        .padding(.horizontal, 20)
    }
}

// MARK: - Reusable Row Component
struct ProfileMenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Icon placed inside a soft tinted circle for a premium look
            ZStack {
                Circle()
                    .fill(Color.themePrimary.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.themePrimary)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.themeText)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.themeTextVariant)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        // We use a clear background so the whole row is clickable within the NavigationLink
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
}
