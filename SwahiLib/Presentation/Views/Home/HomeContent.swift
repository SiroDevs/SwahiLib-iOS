//
//  HomeContent.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct HomeContent: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText: String = ""
    @State private var selectedTab: HomeTab = .words

    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                TextField("Tafuta ...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .onChange(of: searchText) { newValue in
                        viewModel.searchSongs(searchText: newValue)
                    }

                CustomTabTitlesView(selectedTab: $selectedTab)
                
                Spacer()
//                SongsListView(songs: viewModel.filtered)
            }
            .background(.accent1)
            .padding(.vertical)
        }
    }
}

//struct SongsListView: View {
//    let songs: [Song]
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 0) {
//                ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
//                    NavigationLink {
//                        PresenterView(song: song)
//                    } label: {
//                        SearchSongItem(
//                            song: song,
//                            height: 50,
//                            isSelected: false,
//                            isSearching: false
//                        )
//                    }
//
//                    if index < songs.count - 1 {
//                        Divider()
//                    }
//                }
//            }
//        }
//        .background(Color.white)
//    }
//}
