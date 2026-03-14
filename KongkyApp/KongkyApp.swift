//
//  KongkyAppApp.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

@main
struct KongkyApp: App {
    @State private var showMainApp = false
    
    var body: some Scene {
        WindowGroup {
            if showMainApp {
                MainTabView()
            } else {
                SplashView(isActive: $showMainApp)
            }
        }
    }
}
