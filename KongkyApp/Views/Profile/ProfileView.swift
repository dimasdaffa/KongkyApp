//
//  ProfileView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("Alex")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("alex@example.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 0) {
                        ProfileRow(icon: "ticket.fill", title: "My Activities")
                        Divider()
                        ProfileRow(icon: "heart.fill", title: "Saved Events")
                        Divider()
                        ProfileRow(icon: "gearshape.fill", title: "Settings")
                        Divider()
                        
                        ProfileRow(icon: "arrow.right.square.fill", title: "Log Out", isDestructive: true)
                    }
                    .background(Color.white)
                    .cornerRadius(14)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    Spacer()
                }
            }
            // A slightly gray background makes the white menu card "pop"
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isDestructive ? .red : .gray)
                .frame(width: 30)
            
            Text(title)
                .font(.body)
                .foregroundColor(isDestructive ? .red : .primary)
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
                .font(.footnote)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
}
