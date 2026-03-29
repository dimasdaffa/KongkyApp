//
//  AuthService.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import Foundation
import FirebaseAuth

class AuthService: AuthServiceProtocol {
    
    // MARK: - Current User
    // ---------------------------------------------------------
    // A quick way to check who's currently logged in.
    // Returns nil if nobody is logged in.
    // ---------------------------------------------------------
    var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // MARK: - Listen to Auth State
    // ---------------------------------------------------------
    // Firebase remembers if a user was logged in even after
    // the app closes. This listener fires:
    // 1. When the app starts (tells us if someone is logged in)
    // 2. When someone logs in
    // 3. When someone logs out
    // ---------------------------------------------------------
    func listenToAuthState(completion: @escaping (FirebaseAuth.User?) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            completion(user)
        }
    }
    
    // MARK: - Register
    // ---------------------------------------------------------
    // Creates a new account with email + password, then saves
    // the user's full name into their Firebase profile.
    //
    // We use `Result<User, Error>` so the caller (ViewModel)
    // can easily handle success or failure:
    //   .success(user) → registration worked, here's the user
    //   .failure(error) → something went wrong, here's why
    // ---------------------------------------------------------
    func register(email: String, password: String, fullName: String,
                  completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            // If Firebase returned an error, pass it back
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Save the full name into the user's Firebase profile
            let changeRequest = result?.user.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            changeRequest?.commitChanges { _ in
                DispatchQueue.main.async {
                    // Return the updated user on success
                    if let user = Auth.auth().currentUser {
                        completion(.success(user))
                    }
                }
            }
        }
    }
    
    // MARK: - Login
    // ---------------------------------------------------------
    // Signs in an existing user with their email and password.
    // ---------------------------------------------------------
    func login(email: String, password: String,
               completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let user = result?.user {
                    completion(.success(user))
                }
            }
        }
    }
    
    // MARK: - Sign Out
    // ---------------------------------------------------------
    // Logs out the current user. This is a throwing function
    // because Firebase's signOut() can fail (rare, but possible).
    // ---------------------------------------------------------
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
