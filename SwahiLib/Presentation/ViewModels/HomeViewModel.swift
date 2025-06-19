//
//  HomeViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var songs: [Song] = []
    @Published var likes: [Song] = []
    @Published var filtered: [Song] = []
    @Published var uiState: ViewUiState = .idle
    @Published var selectedBook: Int = 0

    private let prefsRepo: PrefsRepository
    private let bookRepo: BookRepositoryProtocol
    private let songRepo: SongRepositoryProtocol

    init(
        prefsRepo: PrefsRepository,
        bookRepo: BookRepositoryProtocol,
        songRepo: SongRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.bookRepo = bookRepo
        self.songRepo = songRepo
    }
    
    func fetchData() {
        self.uiState = .loading("Fetching data ...")

        Task {
            await MainActor.run {
                self.books = bookRepo.fetchLocalBooks()
                self.songs = songRepo.fetchLocalSongs()
                self.uiState = .fetched
            }
        }
    }
    
    func filterSongs(book: Int) {
        self.uiState = .filtering

        Task {
            await MainActor.run {
                self.filtered = songs.filter { $0.book == book }
                self.likes = songs.filter { $0.liked }
                self.uiState = .filtered
            }
        }
    }
    
    func searchSongs(searchText: String) {
        if searchText.isEmpty {
            filtered = songs.filter { $0.book == books[selectedBook].bookNo }
        } else {
            filtered = songs.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

}
