//
//  WordRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//

import Foundation

protocol WordRepoProtocol {
    func fetchRemoteData() async throws
    func fetchLocalData() -> [Word]
    func getWordsByTitles(titles: [String]) -> [Word]
    func saveWord(_ word: Word)
    func updateWord(_ word: Word)
    func deleteLocalData()
}

class WordRepo: WordRepoProtocol {
    private let supabase: SupabaseServiceProtocol
    private let wordData: WordDataManager
    
    init(supabase: SupabaseServiceProtocol, wordData: WordDataManager) {
        self.supabase = supabase
        self.wordData = wordData
    }
    
    func fetchRemoteData() async throws -> {
        let pageSize = 2000
        let totalCount = 16641
        
        let pageCount = (totalCount + pageSize - 1) / pageSize
        
        _ = (0..<pageCount).map { $0 * pageSize }
        
        let allPages: [[Word]] = try await withThrowingTaskGroup(of: (Int, [Word]).self) { group in
            for pageIndex in 0..<pageCount {
                group.addTask { [pageSize] in
                    let offset = pageIndex * pageSize
                    let wordDTOs: [WordDTO] = try await self.supabase.client
                        .from("words")
                        .select()
                        .range(from: offset, to: offset + pageSize - 1)
                        .execute()
                        .value
                    
                    let words = wordDTOs.map { MapDtoToEntity.mapToEntity($0) }
                    return (pageIndex, words)
                }
            }
            
            var results = Array(repeating: [Word](), count: pageCount)
            for try await (pageIndex, words) in group {
                results[pageIndex] = words
            }
            
            return results
        }
        
        let allWords = allPages.flatMap { $0 }
        print("✅ Total fetched: \(allWords.count) words")
        await wordData.saveWords(allWords)
        print("✅ Words saved successfully")
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
    
    func deleteLocalData() {
        wordData.deleteAllWords()
    }
    
}
