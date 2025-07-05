//
//  WordRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol WordRepositoryProtocol {
    func fetchRemoteData() async throws -> [Word]
    func saveRemoteData(_ words: [Word])
    func fetchLocalData() -> [Word]
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
    
    func fetchRemoteData() async throws -> [Word] {
        do {
            let wordsDtos: [WordDTO] = try await supabase.client
                .from("words")
                .select()
                .execute()
                .value
            
            let words: [Word] = wordsDtos.map { MapDtoToEntity.mapToEntity($0) }
            print("✅ Words fetched: \(words.count)")
            return words
        } catch {
            print("❌ Failed to fetch words: \(error.localizedDescription)")
            throw error
        }
    }
    
    func saveRemoteData(_ words: [Word]) {
        wordData.saveWords(words)
    }
    
    func fetchLocalData() -> [Word] {
        let words = wordData.fetchWords()
        return words.sorted { $0.id < $1.id }
    }
    
}
