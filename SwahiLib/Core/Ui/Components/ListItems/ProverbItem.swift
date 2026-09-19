//
//  ProverbItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/07/2025.
//

import SwiftUI

struct ProverbItem: View {
    var proverb: Proverb
    var timestamp: String? = nil

    var body: some View {
        EntryCard(accent: EntryAccent.proverb, liked: proverb.liked) {
            EntryTitleRow(title: proverb.title, liked: proverb.liked)
            EntryMeaningText(text: entryMeaning(proverb.meaning))
            EntryTimestamp(text: timestamp)
        }
    }
}

#Preview {
    ProverbItem(proverb: Proverb.sampleProverbs[0])
        .padding(.vertical)
}
