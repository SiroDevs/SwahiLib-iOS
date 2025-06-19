//
//  SearchSongItem.swift
//  SwahiLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct SearchSongItem: View {
    let song: Song
    let height: CGFloat
    let isSelected: Bool
    let isSearching: Bool

    private var verses: [String] {
        song.content.components(separatedBy: "##")
    }

    private var hasChorus: Bool {
        song.content.contains("CHORUS")
    }

    private var chorusText: String {
        hasChorus ? "Chorus" : ""
    }

    private var versesText: String {
        let count = verses.count
        let base = hasChorus ? "\(count - 1) V" : "\(count) V"
        return count == 1 ? base : "\(base)s"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .center) {
                Text(songItemTitle(number: song.songNo, title: song.title))
                    .font(.title3)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .lineLimit(1)

                Spacer()

                TagItem(tagText: versesText, height: height)

                if hasChorus {
                    TagItem(tagText: chorusText, height: height)
                }

                Image(systemName: song.liked ? "heart.fill" : "heart")
                    .foregroundColor(.primary)
            }

            Text(refineContent(txt: verses.first ?? ""))
                .lineLimit(2)
                .foregroundColor(.black)
                .font(.body)

            if isSearching {
                TagItem(tagText: "Book \(song.book)", height: height)
            }
        }
        .padding(3)
        .background(isSelected ? .primary1 : Color.clear)
        .contentShape(Rectangle())
    }
}

#Preview {
    SearchSongItem(
        song: Song(
            book: 1,
            songId: 1,
            songNo: 1,
            title: "Amazing Grace",
            alias: "",
            content: "Amazing grace how sweet the sound",
            views: 1200,
            likes: 300,
            liked: true,
            created: "2024-01-01"
        ),
        height: 30,
        isSelected: false,
        isSearching: true,
    )
    .padding()
}
