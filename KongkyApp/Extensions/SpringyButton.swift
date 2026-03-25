//
//  SpringyButton.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 25/03/26.
//

import SwiftUI

struct SpringyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Scales down to 0.96x when pressed
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            // A bouncy spring animation
            .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0), value: configuration.isPressed)
    }
}
