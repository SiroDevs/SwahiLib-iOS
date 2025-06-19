//
//  Step1ViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class InitViewModel: ObservableObject {
    @Published var books: [Selectable<Book>] = []
    @Published var songs: [Song] = []
    @Published var uiState: ViewUiState = .idle

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
    
    func toggleSelection(for book: Book) {
        guard let index = books.firstIndex(where: { $0.data.id == book.id }) else { return }
        books[index].isSelected.toggle()
    }

    func selectedBooks() -> [Book] {
        books.filter { $0.isSelected }.map { $0.data }
    }

    func selectedBooksIds() -> String {
        books
            .filter { $0.isSelected }
            .map { "\($0.data.bookNo)" }
            .joined(separator: ",")
    }

    func fetchBooks() {
        uiState = .loading("Fetching books ...")

        Task {
            do {
                let resp: BookResponse = try await bookRepo.fetchRemoteBooks()
                let data = resp.data.map { Selectable(data: $0, isSelected: false) }
                await MainActor.run {
                    self.books = data
                    self.uiState = .fetched
                }
            } catch {
                await MainActor.run {
                    self.uiState = .error("Failed to fetch books: \(error)")
                }
            }
        }
    }

    func saveBooks() {
        uiState = .saving("Saving books ...")
        print("Selected books: \(selectedBooks())")
                
        Task {
            self.bookRepo.saveBooksLocally(selectedBooks())
            
            await MainActor.run {
                self.prefsRepo.isDataLoaded = true
                self.uiState = .saved
            }
        }
    }
    
    func fetchSongs() {
        uiState = .loading("Fetching songs ...")

        Task {
            do {
                let resp: SongResponse = try await songRepo.fetchRemoteSongs(for: prefsRepo.selectedBooks)
                await MainActor.run {
                    self.songs = resp.data
                    self.uiState = .fetched
                }
            } catch {
                await MainActor.run {
                    self.uiState = .error("Failed to fetch songs: \(error)")
                }
            }
        }
    }

    func saveSongs() {
        self.uiState = .saving("Saving songs ...")
                
        Task {
            self.songRepo.saveSongsLocally(songs)
            
            await MainActor.run {
                self.prefsRepo.isDataLoaded = true
                self.uiState = .saved
            }
        }
    }
}
