//
//  ParentalComponents.swift
//  SwahiLib
//
//  Created by @sirodevs on 15/11/2025.
//

import SwiftUI

struct ParentalNumberCard: View {
    let value: Int
    
    var body: some View {
        Text("\(value)")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

struct ParentalShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(animatableData * .pi * 4) * 10
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
