//
//  LoginView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 24/03/26.
//

import SwiftUI

enum AuthField {
    case fullName, email, password
}

struct LoginView: View {
    @FocusState private var focusedField: AuthField?
    @Binding var isAuthenticated: Bool
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Layer 0 Background
                Color.themeSurface.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        
                        // --- 1. LOGO & HEADER ---
                        VStack(spacing: 16) {
                            Image("KongkyLogo") // Add Asset project logo
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                            
                            VStack(spacing: 8) {
                                Text("Welcome")
                                    .font(.system(size: 32, weight: .heavy, design: .default))
                                    .foregroundColor(.themeText)
                                
                                Text("Sign in to discover your next activity.")
                                    .font(.subheadline)
                                    .foregroundColor(.themeTextVariant)
                            }
                        }
                        .padding(.top, 40)
                        
                        // --- 2. MAIN FORM CARD ---
                        VStack(spacing: 24) {
                            
                            // Email Field
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
                                    // Keyboard Focus Logic
                                        .focused($focusedField, equals: .email)
                                        .submitLabel(.next)
                                        .onSubmit { focusedField = .password }
                                }
                                .padding(16)
                                .background(Color(.systemGray6).opacity(0.6))
                                .cornerRadius(16)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.themeTextVariant)
                                
                                // NEW: Passing focus state down
                                AuthPasswordToggleField(
                                    placeholder: "••••••••",
                                    text: $password,
                                    focusedField: $focusedField,
                                    fieldType: .password,
                                    submitAction: {
                                        if !email.isEmpty && !password.isEmpty {
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            withAnimation { isAuthenticated = true }
                                        }
                                    }
                                )
                            }
                            
                            // Forgot Password Link
                            HStack {
                                Spacer()
                                NavigationLink(destination: ForgotPasswordView()) {
                                    Text("Forgot Password?")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.themePrimary)
                                }
                            }
                            .padding(.top, -8)
                            
                            // Login Button
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                withAnimation {
                                    isAuthenticated = true
                                }
                            }) {
                                HStack {
                                    Text("Log In")
                                    Image(systemName: "arrow.right")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(email.isEmpty || password.isEmpty ? Color.gray.opacity(0.5) : Color.themePrimary)
                                .cornerRadius(30)
                                .shadow(color: email.isEmpty || password.isEmpty ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
                            }
                            .buttonStyle(SpringyButtonStyle())
                            .disabled(email.isEmpty || password.isEmpty)
                            
                            // OR CONTINUE WITH Divider
                            HStack(spacing: 16) {
                                Rectangle().fill(Color(.systemGray5)).frame(height: 1)
                                Text("OR CONTINUE WITH")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.themeTextVariant)
                                    .tracking(1)
                                Rectangle().fill(Color(.systemGray5)).frame(height: 1)
                            }
                            .padding(.vertical, 8)
                            
                            // Social Login Buttons
                            HStack(spacing: 16) {
                                Button(action: { UIImpactFeedbackGenerator(style: .light).impactOccurred() }) {
                                    HStack {
                                        Text("G").font(.headline).fontWeight(.black)
                                        Text("Google").font(.subheadline).fontWeight(.semibold)
                                    }
                                    .foregroundColor(.themeText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray5), lineWidth: 1))
                                }
                                .buttonStyle(SpringyButtonStyle())
                                
                                Button(action: { UIImpactFeedbackGenerator(style: .light).impactOccurred() }) {
                                    HStack {
                                        Image(systemName: "applelogo").font(.headline)
                                        Text("Apple").font(.subheadline).fontWeight(.semibold)
                                    }
                                    .foregroundColor(.themeText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray5), lineWidth: 1))
                                }
                                .buttonStyle(SpringyButtonStyle())
                            }
                        }
                        .padding(32)
                        .background(Color.white)
                        .cornerRadius(32)
                        .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
                        
                        Spacer()
                        
                        // --- 3. SIGN UP LINK ---
                        NavigationLink(destination: RegisterView(isAuthenticated: $isAuthenticated)) {
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(.themeTextVariant)
                                Text("Sign Up")
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
    }
}

// MARK: - Reusable Custom Auth Password Field
struct AuthPasswordToggleField: View {
    var placeholder: String
    @Binding var text: String
    var focusedField: FocusState<AuthField?>.Binding
    var fieldType: AuthField
    var submitAction: () -> Void
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.themeTextVariant)
                .frame(width: 20)
            
            if isVisible {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: fieldType)
                    .submitLabel(.go)
                    .onSubmit(submitAction)
            } else {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: fieldType)
                    .submitLabel(.go)
                    .onSubmit(submitAction)
            }
            
            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.themeTextVariant)
            }
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.6))
        .cornerRadius(16)
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false))
}
