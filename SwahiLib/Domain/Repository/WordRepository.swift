//
//  WordRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol WordRepositoryProtocol {
    func fetchRemoteData() async throws -> [Word]
    func fetchLocalData() -> [Word]
    func getWordsByTitles(titles: [String]) -> [Word]
    func saveWord(_ word: Word)
    func updateWord(_ word: Word)
}

class WordRepository: WordRepositoryProtocol {
    private let supabase: SupabaseServiceProtocol
    private let wordData: WordDataManager
    
    init(supabase: SupabaseServiceProtocol, wordData: WordDataManager) {
        self.supabase = supabase
        self.wordData = wordData
    }
    
    func fetchRemoteData() async throws -> [Word] {
        var offset = 0
        let pageSize = 2000
        var allWords: [Word] = []
        
        do {
            while true {
                print("📥 Fetching words from \(offset) to \(offset + pageSize - 1)")

                let wordDTOs: [WordDTO] = try await supabase.client
                    .from("words")
                    .select()
                    .range(from: offset, to: offset + pageSize - 1)
                    .execute()
                    .value

                if wordDTOs.isEmpty {
                    break
                }

                let mappedBatch = wordDTOs.map { MapDtoToEntity.mapToEntity($0) }
                allWords.append(contentsOf: mappedBatch)

                if wordDTOs.count < pageSize {
                    break // last batch
                }

                offset += pageSize
            }

            print("✅ Total words fetched: \(allWords.count)")
            return allWords

        } catch {
            print("❌ Failed to fetch words: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchLocalData() -> [Word] {
        let words = wordData.fetchWords()
        return words.sorted { $0.id < $1.id }
    }
    
    func saveWord(_ word: Word) {
        wordData.saveWord(word)
    }
    
    func updateWord(_ word: Word) {
        wordData.updateWord(word)
    }
    
    func getWordsByTitles(titles: [String]) -> [Word] {
        let words = wordData.getWordsByTitles(titles: titles)
        return words.sorted { $0.id < $1.id }
    }

}
