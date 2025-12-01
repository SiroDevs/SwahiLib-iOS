//
//  VerticalLetters.swift
//  SwahiLib
//
//  Created by @sirodevs on 13/08/2025.
//

import SwiftUI

struct VerticalLetters: View {
    let selectedLetter: String?
    let onLetterSelected: (String) -> Void
    
    private let letters: [String] = (65...90)
        .map { String(UnicodeScalar($0)!) }
        .filter { $0 != "Q" && $0 != "X" }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(letters, id: \.self) { letter in
                    LetterItem(
                        letter: letter,
                        isSelected: selectedLetter == letter,
                        onTap: { onLetterSelected(letter) }
                    )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading, 15)
        }
    }
}

struct LetterItem: View {
    let letter: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(letter)
                .font(.system(size: 40, weight: .bold))
                .frame(width: 60, height: 60)
                .background(isSelected ? .primary2 : .white)
                .foregroundColor(isSelected ? .white : .primary2)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary2.opacity(isSelected ? 0 : 0.5), lineWidth: 1)
                )
                .shadow(radius: 3)
        }
    }
}

#Preview {
    HStack(alignment: .top, spacing: 10) {
        VerticalLetters(
            selectedLetter: "A",
            onLetterSelected: { letter in
                //
            }
        )
        .frame(width: 60)
//        VStack {
//            WordsList(
//                words: Word.sampleWords
//            )
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
