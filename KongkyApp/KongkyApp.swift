//
//  KongkyAppApp.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct KongkyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 1. Tracks if the splash animation is done
    @State private var splashFinished = false
    
    // 2. Tracks if the user is logged in
    @State private var isAuthenticated = false
    
    var body: some Scene {
        WindowGroup {
            // The ultimate routing logic!
            if !splashFinished {
                // Show Splash first
                SplashView(isActive: $splashFinished)
            } else if !isAuthenticated {
                // If splash is done but they aren't logged in, show Auth!
                LoginView(isAuthenticated: $isAuthenticated)
            } else {
                // If they are logged in, send them into the app!
                OnboardingInterestsView()
            }
        }
    }
}
