//
//  ProverbRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//

import Foundation

protocol ProverbRepoProtocol {
    func fetchRemoteData() async throws -> [Proverb]
    func fetchLocalData() -> [Proverb]
    func getProverbsByTitles(titles: [String]) -> [Proverb]
    func saveProverb(_ proverb: Proverb)
    func updateProverb(_ proverb: Proverb)
    func deleteLocalData()
}

class ProverbRepo: ProverbRepoProtocol {
    private let supabase: SupabaseServiceProtocol
    private let proverbData: ProverbDataManager
    
    init(supabase: SupabaseServiceProtocol, proverbData: ProverbDataManager) {
        self.supabase = supabase
        self.proverbData = proverbData
    }
    
    func fetchRemoteData() async throws -> [Proverb] {
        do {
            let proverbsDtos: [ProverbDTO] = try await supabase.client
                .from("proverbs")
                .select()
                .execute()
                .value
            
            let proverbs: [Proverb] = proverbsDtos.map { MapDtoToEntity.mapToEntity($0) }
            print("✅ Proverbs fetched: \(proverbs.count)")
            return proverbs
        } catch {
            print("❌ Failed to fetch proverbs: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchLocalData() -> [Proverb] {
        let proverbs = proverbData.fetchProverbs()
        return proverbs.sorted { $0.id < $1.id }
    }
    
    func saveProverb(_ proverb: Proverb) {
        proverbData.saveProverb(proverb)
    }

    func updateProverb(_ proverb: Proverb) {
        proverbData.updateProverb(proverb)
    }
    
    func getProverbsByTitles(titles: [String]) -> [Proverb] {
        let proverbs = proverbData.getProverbsByTitles(titles: titles)
        return proverbs.sorted { $0.id < $1.id }
    }
    
    func deleteLocalData() {
        proverbData.deleteAllProverbs()
    }
    
}
