//
//  AuthViewModel.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 28/03/26.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    // Tracks the current logged-in user
    @Published var userSession: FirebaseAuth.User?
    
    // Tracks loading states for your buttons
    @Published var isLoading = false
    
    // Captures errors (like "Wrong Password" or "Email already in use")
    @Published var errorMessage: String?
    
    init() {
        // If a user closes the app and opens it tomorrow, it remembers they are logged in!
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userSession = user
        }
    }
    
    // MARK: - Sign Up
    func register(email: String, password: String, fullName: String, completion: @escaping (Bool) -> Void) {
            self.isLoading = true
            self.errorMessage = nil
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.errorMessage = error.localizedDescription
                        completion(false)
                    }
                    return
                }
                
                // Save the Full Name directly into their Firebase Profile
                let changeRequest = result?.user.createProfileChangeRequest()
                changeRequest?.displayName = fullName
                changeRequest?.commitChanges { _ in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.userSession = Auth.auth().currentUser // Force refresh to get the name
                        completion(true)
                    }
                }
            }
        }
    
    // MARK: - Log In
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        self.errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Login Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                // Successfully logged in
                completion(true)
            }
        }
    }
    
    // MARK: - Log Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.errorMessage = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            self.errorMessage = "Failed to sign out. Please try again."
        }
    }
}
