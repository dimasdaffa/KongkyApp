//
//  AuthService.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import Foundation
import FirebaseAuth

class AuthService: AuthServiceProtocol {
    
    var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // MARK: - Listen to Auth State
    func listenToAuthState(completion: @escaping (FirebaseAuth.User?) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            completion(user)
        }
    }
    
    // MARK: - Register
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
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
