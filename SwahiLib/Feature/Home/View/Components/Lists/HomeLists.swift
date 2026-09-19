//
//  HomeLists.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/08/2025.
//

import SwiftUI

struct IdiomsList: View {
    let idioms: [Idiom]
    var isProUser: Bool = true
    var onUpgrade: () -> Void = {}
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(idioms.enumerated()), id: \.element.rid) { index, idiom in
                NavigationLink {
                    IdiomView(idiom: idiom)
                } label: {
                    IdiomItem(idiom: idiom)
                }

                if !isProUser && index == 2 && idioms.count > 3 {
                    UpgradeBanner1(onUpgrade: onUpgrade)
                }
            }
        }
    }
}

struct ProverbsList: View {
    let proverbs: [Proverb]
    var isProUser: Bool = true
    var onUpgrade: () -> Void = {}

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(proverbs.enumerated()), id: \.element.rid) { index, proverb in
                NavigationLink {
                    ProverbView(proverb: proverb)
                } label: {
                    ProverbItem(proverb: proverb)
                }

                if !isProUser && index == 2 && proverbs.count > 3 {
                    UpgradeBanner1(onUpgrade: onUpgrade)
                }
            }
        }
    }
}

struct SayingsList: View {
    let sayings: [Saying]
    var isProUser: Bool = true
    var onUpgrade: () -> Void = {}

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(sayings.enumerated()), id: \.element.rid) { index, saying in
                NavigationLink {
                    SayingView(saying: saying)
                } label: {
                    SayingItem(saying: saying)
                }

                if !isProUser && index == 2 && sayings.count > 3 {
                    UpgradeBanner1(onUpgrade: onUpgrade)
                }
            }
        }
    }
}

struct WordsList: View {
    let words: [Word]
    var isProUser: Bool = true
    var onUpgrade: () -> Void = {}

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(words.enumerated()), id: \.element.rid) { index, word in
                NavigationLink {
                    WordView(deepLinked: false, word: word)
                } label: {
                    WordItem(word: word)
                }

                if !isProUser && index == 2 && words.count > 3 {
                    UpgradeBanner1(onUpgrade: onUpgrade)
                }
            }
        }
    }
}

#Preview {
    WordsList(
        words: Word.sampleWords,
        isProUser: false
    )
    .padding()
}
