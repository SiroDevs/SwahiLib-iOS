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
                    .padding(10)
                    .background(.accent1)
                    .cornerRadius(8)
                    .padding(10)
                    .onChange(of: searchText) { newValue in
//                        viewModel.searchSongs(searchText: newValue)
                    }


                CustomTabTitlesView(selectedTab: selectedTab, onSelect: { book in
                    
                } )
                
                Spacer()
//                SongsListView(songs: viewModel.filtered)
            }
            .padding(.vertical)
            .navigationTitle("SwahiLib - Kamusi ya Kiswahili")
        }
    }
}

#Preview {
    HomeView()
}
