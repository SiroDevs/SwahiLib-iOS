//
//  EmptyState.swift
//  SwahiLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct EmptyState: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Image(AppAssets.emptyIcon)
                .resizable()
                .frame(width: 200, height: 200)

            Text("Hamna chochote huku")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary1)
                .padding(.horizontal)

        }
        .padding()
    }
}

#Preview {
    EmptyState()
}
