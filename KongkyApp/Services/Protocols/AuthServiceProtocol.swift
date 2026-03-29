//
//  AuthServiceProtocol.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    
    /// The currently logged-in user (nil if no one is logged in).
    /// This is a read-only property that any AuthService must provide.
    var currentUser: FirebaseAuth.User? { get }
    
    /// Listen to auth state changes (login/logout).
    /// The callback fires whenever the user logs in or out.
    func listenToAuthState(completion: @escaping (FirebaseAuth.User?) -> Void)
    
    /// Register a new user with email, password, and display name.
    /// Returns success/failure + optional error message via completion.
    func register(email: String, password: String, fullName: String,
                  completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void)
    
    /// Log in an existing user with email and password.
    func login(email: String, password: String,
               completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void)
    
    /// Sign out the current user. Throws if sign-out fails.
    func signOut() throws
}
