//
//  SearchBar.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/07/2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Tafuta kwenye Kamusi ..."
    var isListening: Bool = false
    var onSearch: (String) -> Void
    var onClear: (() -> Void)? = nil
    var onVoiceSearch: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.onPrimaryContainer.opacity(0.7))

            TextField(isListening ? "Sema unachotafuta ..." : placeholder, text: $text)
                .onChange(of: text) { newValue in
                    onSearch(newValue)
                }

            if !text.isEmpty {
                Button {
                    text = ""
                    onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.onPrimaryContainer)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Futa")
            }

            if let onVoiceSearch {
                Button(action: onVoiceSearch) {
                    Image(systemName: isListening ? "mic.fill" : "mic")
                        .foregroundColor(isListening ? .red : .onPrimaryContainer)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Tafuta kwa Sauti")
            }
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
