//
//  WordRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol WordRepositoryProtocol {
    func fetchRemoteWords(for bookId: String) async throws -> WordResponse
    func fetchLocalWords() -> [Word]
    func saveWordsLocally(_ words: [Word])
    func updateWord(_ word: Word)
}

class WordRepository: WordRepositoryProtocol {
    func updateWord(_ word: Word) {
        wordData.updateWord(word)
    }
    
    private let apiService: ApiServiceProtocol
    private let wordData: WordDataManager
    
    init(apiService: ApiServiceProtocol, wordData: WordDataManager) {
        self.apiService = apiService
        self.wordData = wordData
    }
    
    func fetchRemoteWords(for booksIds: String) async throws -> WordResponse {
        return try await apiService.fetch(endpoint: .wordsByBook(booksIds))
    }
    
    func fetchLocalWords() -> [Word] {
        let words = wordData.fetchWords()
        return words.sorted { $0.wordId < $1.wordId }
    }
    
    func saveWordsLocally(_ words: [Word]) {
        wordData.saveWords(words)
    }
}
