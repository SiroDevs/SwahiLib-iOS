//
//  ScrollToTopButton.swift
//  SwahiLib
//
//  Created by @sirodevs on 01/12/2025.
//

import SwiftUI

struct ScrollToTopButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.up.circle")
                .font(.system(size: 44))
                .foregroundColor(.white)
                .background(
                    Circle()
                        .fill(Color.primary2)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
