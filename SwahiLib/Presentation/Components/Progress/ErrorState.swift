//
//  ErrorState.swift
//  SwahiLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct ErrorState: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .foregroundColor(.red)

            Text("Lo! Jamani!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Text(message)
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary1)
                .padding(.horizontal)

            Button(action: retryAction) {
                Text("Retry")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    ErrorState(
        message: "Kuna shida kaka. Tafadhali jaribu tena.",
        retryAction: { print("Retry tapped") }
    )
}
