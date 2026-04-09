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
    @Published var userSession: FirebaseAuth.User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // The service that handles all authentication operations
    // TYPE = protocol (AuthServiceProtocol), not the class (AuthService)
    private let authService: AuthServiceProtocol
    
    // ---------------------------------------------------------
    // DEPENDENCY INJECTION
    // ---------------------------------------------------------
    // Default = AuthService() (real Firebase)
    // For tests/previews, pass in a MockAuthService
    // ---------------------------------------------------------
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        
        // Listen for auth state changes (remembers login across app restarts!)
        authService.listenToAuthState { [weak self] user in
            self?.userSession = user
        }
    }
    
    // MARK: - Sign Up
    func register(email: String, password: String, fullName: String, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        self.errorMessage = nil
        
        authService.register(email: email, password: password, fullName: fullName) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                // `switch` on Result is a clean way to handle success/failure
                switch result {
                case .success(let user):
                    self?.userSession = user
                    completion(true)
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Log In
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        self.errorMessage = nil
        
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    // userSession is already updated by the auth state listener
                    completion(true)
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Login Error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Log Out
    func signOut() {
        do {
            try authService.signOut()
            self.errorMessage = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            self.errorMessage = "Failed to sign out. Please try again."
        }
    }
}
