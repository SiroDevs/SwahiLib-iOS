//
//  HomeLists.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/08/2025.
//

import SwiftUI

struct IdiomsList: View {
    let idioms: [Idiom]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(idioms.enumerated()), id: \.element.id) { index, idiom in
                NavigationLink {
                    IdiomView(idiom: idiom)
                } label: {
                    IdiomItem(idiom: idiom)
                }
            }
        }
    }
}

struct ProverbsList: View {
    let proverbs: [Proverb]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(proverbs.enumerated()), id: \.element.id) { index, proverb in
                NavigationLink {
                    ProverbView(proverb: proverb)
                } label: {
                    ProverbItem(proverb: proverb)
                }
            }
        }
    }
}

struct SayingsList: View {
    let sayings: [Saying]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(sayings.enumerated()), id: \.element.id) { index, saying in
                NavigationLink {
                    SayingView(saying: saying)
                } label: {
                    SayingItem(saying: saying)
                }
            }
        }
    }
}

struct WordsList: View {
    let words: [Word]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(words.enumerated()), id: \.element.id) { index, word in
                NavigationLink {
                    WordView(word: word, deepLinked: false)
                } label: {
                    WordItem(word: word)
                }
            }
        }
    }
}

#Preview {
    WordsList(
        words: Word.sampleWords
    )
    .padding()
}
