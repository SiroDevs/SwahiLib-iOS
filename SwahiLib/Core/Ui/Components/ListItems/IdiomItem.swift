//
//  IdiomItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/07/2025.
//

import SwiftUI

struct IdiomItem: View {
    var idiom: Idiom
    var timestamp: String? = nil

    var body: some View {
        EntryCard(accent: EntryAccent.idiom, liked: idiom.liked) {
            EntryTitleRow(title: idiom.title, liked: idiom.liked)
            EntryMeaningText(text: entryMeaning(idiom.meaning))
            EntryTimestamp(text: timestamp)
        }
    }
}
