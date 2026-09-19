//
//  SectionHeader.swift
//  SwahiLib
//
//  Created by @sirodevs on 19/09/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let count: Int

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.onPrimaryContainer.opacity(0.7))

            Spacer()

            Text("\(count)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.primary2)
                )
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(Color.onPrimaryContainer.opacity(0.08))
    }
}

#Preview {
    SectionHeader(title: "Matokeo", count: 128)
}
