//
//  SplashView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    @State private var animateLogo = false
    @State private var animateText = false
    
    let appName = Array("Kongky")
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 80, height: 80)
                    Text("K")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(y: animateLogo ? 0 : -50)
                .opacity(animateLogo ? 1 : 0)
                
                HStack(spacing: 4) {
                    ForEach(0..<appName.count, id: \.self) { index in
                        Text(String(appName[index]))
                            .font(.title)
                            .fontWeight(.heavy)
                            .tracking(2)
                            .offset(y: animateText ? 0 : 20)
                            .opacity(animateText ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.1), value: animateText)
                    }
                }
                .onAppear {
                    // Kick off the logo bounce
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                        animateLogo = true
                    }
                    
                    // Stagger text reveal slightly after the logo
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateText = true
                    }
                    
                    // Hide splash after full sequence completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    SplashView(isActive: .constant(false))
}
