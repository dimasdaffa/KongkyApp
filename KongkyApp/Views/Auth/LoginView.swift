//
//  LoginView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI

struct LoginView: View {
    // This tells the main app to move to the next screen
    @Binding var isAuthenticated: Bool
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Spacer()
                
                // --- HEADER ---
                VStack(spacing: 12) {
                    // Your Ghost Logo Placeholder
                    ZStack {
                        Circle().fill(Color.primary).frame(width: 80, height: 80)
                        Text("K").font(.system(size: 40, weight: .bold)).foregroundColor(Color(.systemBackground))
                    }
                    
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Sign in to discover your next activity.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // --- EMAIL & PASSWORD FORM ---
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)
                }
                .padding(.horizontal)
                
                // --- MAIN LOGIN BUTTON ---
                Button(action: {
                    // TODO: Add Firebase Auth login here later!
                    
                    // For now, just skip to the app!
                    withAnimation {
                        isAuthenticated = true
                    }
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(14)
                }
                .padding(.horizontal)
                
                // --- OR DIVIDER ---
                HStack {
                    VStack { Divider() }
                    Text("or continue with").font(.footnote).foregroundColor(.secondary).padding(.horizontal, 8)
                    VStack { Divider() }
                }
                .padding(.horizontal, 30)
                
                // --- SOCIAL LOGIN BUTTONS ---
                VStack(spacing: 16) {
                    // Apple Button
                    Button(action: { print("Apple Login Clicked") }) {
                        HStack {
                            Image(systemName: "applelogo").font(.title3)
                            Text("Continue with Apple").fontWeight(.semibold)
                        }
                        .foregroundColor(Color(.systemBackground))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.primary)
                        .cornerRadius(14)
                    }
                    
                    // Google Button (Standard UI styling for Google)
                    Button(action: { print("Google Login Clicked") }) {
                        HStack {
                            // Using a standard "G" since SF Symbols doesn't have a Google logo
                            Text("G").font(.title3).fontWeight(.black)
                            Text("Continue with Google").fontWeight(.semibold)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.secondarySystemBackground))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // --- SIGN UP LINK ---
                NavigationLink(destination: RegisterView(isAuthenticated: $isAuthenticated)) {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.secondary)
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .font(.subheadline)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false))
}
