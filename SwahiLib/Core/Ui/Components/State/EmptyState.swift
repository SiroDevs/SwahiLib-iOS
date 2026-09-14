//
//  EmptyState.swift
//  SwahiLib
//
//  Created by @sirodevs on 04/05/2025.
//

import SwiftUI

struct EmptyState: View {
    var title: String = "Hamna chochote huku"
    var message: String? = nil
    var systemImage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 80))
                    .foregroundColor(.primary1.opacity(0.5))
            } else {
                Image(.emptyIcon)
                    .resizable()
                    .frame(width: 200, height: 200)
            }

            Text(title)
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary1)
                .padding(.horizontal)

            if let message {
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.onSurface.opacity(0.6))
                    .padding(.horizontal, 32)
            }
        }
        .padding()
    }
}

#Preview {
    EmptyState()
}
