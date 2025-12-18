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
            ForEach(Array(idioms)) { idiom in
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
            ForEach(Array(proverbs)) { proverb in
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
            ForEach(Array(sayings)) { saying in
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
            ForEach(Array(words)) { word in
                NavigationLink {
                    WordView(deepLinked: false, word: word)
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
