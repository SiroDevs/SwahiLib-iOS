//
//  WordRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol WordRepositoryProtocol {
    func fetchRemoteData() async throws -> Word
    func fetchLocalData() -> [Word]
    func saveData(_ words: [Word])
    func updateWord(_ word: Word)
}

class WordRepository: WordRepositoryProtocol {
    func updateWord(_ word: Word) {
        wordData.updateWord(word)
    }
    
    private let supabase: SupabaseServiceProtocol
    private let wordData: WordDataManager
    
    init(supabase: SupabaseServiceProtocol, wordData: WordDataManager) {
        self.supabase = supabase
        self.wordData = wordData
    }
    
    func fetchRemoteData() async throws -> Word {
        return try await apiService.fetch(endpoint: 'words')
    }
    
    func fetchLocalData() -> [Word] {
        let words = wordData.fetchWords()
        return words.sorted { $0.id < $1.id }
    }
    
    func saveData(_ words: [Word]) {
        wordData.saveWords(words)
    }
}
