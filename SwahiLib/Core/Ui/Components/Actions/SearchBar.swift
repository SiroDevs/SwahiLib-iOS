//
//  SearchBar.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/07/2025.
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
                    .foregroundColor(.onPrimaryContainer)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.onPrimaryContainer, lineWidth: 1)
        )
    }
}
