//
//  CurrentUser.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import Foundation
import FirebaseAuth

// OOP CONCEPT: "Facade Pattern"
// A facade is a simple interface that hides complex internals.
// Instead of `Auth.auth().currentUser?.email ?? ""`, just use
// `CurrentUser.email`. Same result, much cleaner

struct CurrentUser {
    
    /// The current user's email, or empty string if not logged in.
    static var email: String {
        Auth.auth().currentUser?.email ?? ""
    }
    
    /// The current user's display name, or "Kongky User" as fallback.
    static var displayName: String {
        Auth.auth().currentUser?.displayName ?? "Kongky User"
    }
    
    /// Quick check: is anyone logged in right now?
    static var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
}
