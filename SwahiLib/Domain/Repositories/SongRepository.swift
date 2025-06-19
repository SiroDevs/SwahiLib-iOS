//
//  SongRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol SongRepositoryProtocol {
    func fetchRemoteSongs(for bookId: String) async throws -> SongResponse
    func fetchLocalSongs() -> [Song]
    func saveSongsLocally(_ songs: [Song])
    func updateSong(_ song: Song)
}

class SongRepository: SongRepositoryProtocol {
    func updateSong(_ song: Song) {
        songData.updateSong(song)
    }
    
    private let apiService: ApiServiceProtocol
    private let songData: SongDataManager
    
    init(apiService: ApiServiceProtocol, songData: SongDataManager) {
        self.apiService = apiService
        self.songData = songData
    }
    
    func fetchRemoteSongs(for booksIds: String) async throws -> SongResponse {
        return try await apiService.fetch(endpoint: .songsByBook(booksIds))
    }
    
    func fetchLocalSongs() -> [Song] {
        let songs = songData.fetchSongs()
        return songs.sorted { $0.songId < $1.songId }
    }
    
    func saveSongsLocally(_ songs: [Song]) {
        songData.saveSongs(songs)
    }
}
