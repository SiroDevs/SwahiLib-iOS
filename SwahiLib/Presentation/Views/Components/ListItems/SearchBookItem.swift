//
//  SearchBookItem.swift
//  SwahiLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct SearchBookItem: View {
    let text: String
    let isSelected: Bool
    let onPressed: (() -> Void)?

    var body: some View {
        Button(action: {
            onPressed?()
        }) {
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(isSelected ? .primary3 : .primary1)
                .cornerRadius(20)
        }
        .padding(.leading, 5)
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview{
    SearchBookItem(
        text: "Songs of Worship",
        isSelected: true,
        onPressed: { }
    )
}
