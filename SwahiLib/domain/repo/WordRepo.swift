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
    
    func fetchRemoteData() async throws {
        let pageSize = 2000
        let totalCount = 16641
        let pageCount = (totalCount + pageSize - 1) / pageSize
        
        let allWords: [CDWord] = try await withThrowingTaskGroup(of: [CDWord].self) { group in
            for pageIndex in 0..<pageCount {
                group.addTask { [pageSize] in
                    let offset = pageIndex * pageSize
                    let wordDTOs: [WordDTO] = try await self.supabase.client
                        .from("words")
                        .select()
                        .range(from: offset, to: offset + pageSize - 1)
                        .execute()
                        .value
                    
                    return wordDTOs.map { dto in
                        let cdWord = CDWord(context: self.wordData.bgContext)
                        MapDtoToCd.mapToCd(dto, cdWord)
                        return cdWord
                    }
                }
            }
            
            var allResults: [CDWord] = []
            for try await batch in group {
                allResults.append(contentsOf: batch)
            }
            
            return allResults
        }
        
        print("✅ \(allWords.count) words fetched")
        
        try await wordData.saveWords(allWords)
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
