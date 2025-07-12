//
//  SearchBar.swift
//  SwahiLib
//
//  Created by Siro Daves on 12/07/2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: (String) -> Void
    var onClear: (() -> Void)? = nil

    var body: some View {
        HStack {
            TextField("Tafuta ...", text: $text)
                .padding(.horizontal)
                .onChange(of: text) { newValue in
                    onSearch(newValue)
                }

            Button(action: {
                text = ""
                onSearch("")
                onClear?()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.primary1)
                    .imageScale(.large)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.accent1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary1, lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
}
