//
//  WordItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/07/2025.
//

import SwiftUI

struct WordItem: View {
    var word: Word
    var timestamp: String? = nil

    private var meaning: String {
        entryMeaning(word.meaning, includeSecond: true)
    }

    private var english: String {
        let raw: String? = word.english
        return (raw ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var synonyms: [String] {
        word.synonyms
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        EntryCard(accent: EntryAccent.word, liked: word.liked, barHeight: 48) {
            EntryTitleRow(
                title: word.title,
                english: english,
                liked: word.liked,
                lineLimit: 1
            )
            EntryMeaningText(text: meaning)
            SynonymChips(synonyms: synonyms)
            EntryTimestamp(text: timestamp)
        }
    }
}

#Preview {
    VStack {
        ForEach(Word.sampleWords, id: \.rid) { word in
            WordItem(word: word)
        }
    }
    .padding(.vertical)
}
