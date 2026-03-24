//
//  RegisterView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI

struct RegisterView: View {
    @Binding var isAuthenticated: Bool
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 30) {
            
            // --- HEADER ---
            VStack(alignment: .leading, spacing: 8) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Join Kongky to meet people and join activities around you.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 40)
            
            // --- REGISTRATION FORM ---
            VStack(spacing: 16) {
                TextField("Full Name", text: $fullName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(14)
                
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
            
            // --- MAIN SIGN UP BUTTON ---
            Button(action: {
                // TODO: Add Firebase Auth registration here!
                
                withAnimation {
                    isAuthenticated = true
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        // Apple automatically adds the `< Back` button here!
    }
}

#Preview {
    RegisterView(isAuthenticated: .constant(false))
}
