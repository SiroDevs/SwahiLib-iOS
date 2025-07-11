//
//  WordsList.swift
//  SwahiLib
//
//  Created by Siro Daves on 11/07/2025.
//

import SwiftUI

struct WordsList: View {
    let words: [Word]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(words.enumerated()), id: \.element.id) { index, word in
                    NavigationLink {
//                        PresenterView(song: song)
                    } label: {
                        SearchSongItem(
                            song: song,
                            height: 50,
                            isSelected: false,
                            isSearching: false
                        )
                    }

                    if index < songs.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .background(Color.white)
    }
}
