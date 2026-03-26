//
//  ForgotPasswordView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 26/03/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var isSent = false
    @State private var showToast = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Layer 0 Background
            Color.themeSurface.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // --- 1. HEADER ---
                    VStack(spacing: 8) {
                        Text("Reset Password")
                            .font(.system(size: 32, weight: .heavy, design: .default))
                            .foregroundColor(.themeText)
                        
                        Text("Enter your email address and we'll send you a link to reset your password.")
                            .font(.subheadline)
                            .foregroundColor(.themeTextVariant)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
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
                            }
                            .padding(16)
                            .background(Color(.systemGray6).opacity(0.6))
                            .cornerRadius(16)
                        }
                        
                        // Send Reset Link Button
                        Button(action: {
                            if !isSent {
                                sendResetLink()
                            }
                        }) {
                            HStack {
                                if isSent {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                                Text(isSent ? "Link Sent" : "Send Reset Link")
                                if !isSent {
                                    Image(systemName: "paperplane.fill")
                                }
                            }
                            .font(.headline)
                            .foregroundColor(isSent ? .themeTextVariant : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(email.isEmpty ? Color.gray.opacity(0.5) : (isSent ? Color(.systemGray5) : Color.themePrimary))
                            .cornerRadius(30)
                            .shadow(color: (email.isEmpty || isSent) ? .clear : Color.themePrimary.opacity(0.3), radius: 10, x: 0, y: 6)
                        }
                        .buttonStyle(SpringyButtonStyle())
                        .disabled(email.isEmpty || isSent)
                        .padding(.top, 8)
                        
                    }
                    .padding(32)
                    .background(Color.white)
                    .cornerRadius(32)
                    .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
                    
                    Spacer(minLength: 40)
                    
                    // --- 3. BACK TO LOGIN LINK ---
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                                .font(.caption)
                                .foregroundColor(.themeTextVariant)
                            Text("Back to Log In")
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
            
            // --- 4. TOP TOAST NOTIFICATION ---
            if showToast {
                toastNotification
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews & Actions
    
    private var toastNotification: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "envelope.badge.fill")
                    .font(.title3)
                    .foregroundColor(.themePrimary)
                
                Text("Reset link sent to email!")
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
    
    func sendResetLink() {
        // TODO: Add Firebase Auth Password Reset here later!
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isSent = true
            showToast = true
        }
        
        // Hide toast and dismiss page after 2.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
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
    ForgotPasswordView()
}
