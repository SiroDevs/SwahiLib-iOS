//
//  SayingItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/07/2025.
//

import SwiftUI

struct SayingItem: View {
    var saying: Saying
    var timestamp: String? = nil

    var body: some View {
        EntryCard(accent: EntryAccent.saying, liked: saying.liked) {
            EntryTitleRow(title: saying.title, liked: saying.liked)
            EntryMeaningText(text: entryMeaning(saying.meaning))
            EntryTimestamp(text: timestamp)
        }
    }
}
