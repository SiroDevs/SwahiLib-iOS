//
//  SynonymItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//
//  Restyled to match Android's core/ui SynonymItem.kt: title on the left
//  in the primary color, a single forward chevron on the right, laid out
//  space-between on a flat card.

import SwiftUI

struct SynonymItem: View {
    var title: String
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary2)

                Spacer()

                Image(systemName: "chevron.forward")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.background1))
        }
        .buttonStyle(.plain)
        .padding(.vertical, 3)
    }
}

#Preview {
    SynonymItem(
        title: "Hata Kidogo",
        onClick: {}
    )
    .padding()
}
