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
    @State private var showMainApp = false
    
    var body: some Scene {
        WindowGroup {
            if showMainApp {
                OnboardingInterestsView()
            } else {
                SplashView(isActive: $showMainApp)
            }
        }
    }
}
