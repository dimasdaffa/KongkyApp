//
//  LoadingView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    
    var message: String = "Loading..."
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // THE SPINNING LOGO
                ZStack {
                    // Background track circle
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                        .frame(width: 80, height: 80)
                    
                    // The spinning black segment
                    Circle()
                        .trim(from: 0, to: 0.7) // Only draws 70% of the circle
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                rotation = 360
                            }
                        }
                    
                    // Our App Logo in the middle
                    Text("K")
                        .font(.system(size: 32, weight: .bold))
                }
                
                Text(message)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .tracking(2)
            }
        }
    }
}

#Preview {
    LoadingView(message: "Warming things up...")
}
