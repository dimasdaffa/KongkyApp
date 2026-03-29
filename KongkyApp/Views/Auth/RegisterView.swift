//
//  RegisterView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI

struct RegisterView: View {
    @FocusState private var focusedField: AuthField?
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    
    // Connect the ViewModel
    @StateObject private var authViewModel = AuthViewModel()
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color.themeSurface.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    VStack(spacing: 8) {
                        Image("KongkyLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                        Text("Create Account")
                            .font(.system(size: 32, weight: .heavy, design: .default))
                            .foregroundColor(.themeText)
                        
                        Text("Join Kongky to meet people and join activities around you.")
                            .font(.subheadline)
                            .foregroundColor(.themeTextVariant)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.themeTextVariant)
                            
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.themeTextVariant)
                                    .frame(width: 20)
                                TextField("Alex Morgan", text: $fullName)
                                    .focused($focusedField, equals: .fullName)
                                    .submitLabel(.next)
                                    .onSubmit { focusedField = .email }
                            }
                            .padding(16)
                            .background(Color(.systemGray6).opacity(0.6))
                            .cornerRadius(16)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.themeTextVariant)
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.themeTextVariant)
                                    .frame(width: 20)
                                TextField("alex@example.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($focusedField, equals: .email)
                                    .submitLabel(.next)
                                    .onSubmit { focusedField = .password }
                            }
                            .padding(16)
                            .background(Color(.systemGray6).opacity(0.6))
                            .cornerRadius(16)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.themeTextVariant)
                            
                            AuthPasswordToggleField(
                                placeholder: "Min. 8 characters",
                                text: $password,
                                focusedField: $focusedField,
                                fieldType: .password,
                                submitAction: {
                                    // Keyboard Return Key triggers Firebase Register
                                    if !email.isEmpty && !password.isEmpty && !fullName.isEmpty {
                                        performRegistration()
                                    }
                                }
                            )
                        }
                        
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                        }
                        
                        // Firebase Sign Up Button
                        Button(action: {
                            performRegistration()
                        }) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Sign Up")
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(email.isEmpty || password.isEmpty || fullName.isEmpty || authViewModel.isLoading ? Color.gray.opacity(0.5) : Color.themePrimary)
                            .cornerRadius(30)
                            .shadow(color: email.isEmpty || password.isEmpty || fullName.isEmpty || authViewModel.isLoading ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
                        }
                        .buttonStyle(SpringyButtonStyle())
                        .disabled(email.isEmpty || password.isEmpty || fullName.isEmpty || authViewModel.isLoading)
                        .padding(.top, 8)
                        
                    }
                    .padding(32)
                    .background(Color.white)
                    .cornerRadius(32)
                    .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
                    
                    Spacer(minLength: 40)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(.themeTextVariant)
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(.themePrimary)
                        }
                        .font(.subheadline)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarHidden(true)
    }
    
    private func performRegistration() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            // Pass the fullName variable into the ViewModel
            authViewModel.register(email: email, password: password, fullName: fullName) { success in
                if success {
                    withAnimation { isAuthenticated = true }
                }
            }
        }
}

#Preview {
    RegisterView(isAuthenticated: .constant(false))
}
