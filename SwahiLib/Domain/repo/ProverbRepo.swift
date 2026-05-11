//
//  ProverbRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//

import Foundation

protocol ProverbRepoProtocol {
    func fetchRemoteData() async throws
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
    
    func fetchRemoteData() async throws {
        do {
            let proverbDTOs: [ProverbDTO] = try await supabase.client
                .from("proverbs")
                .select()
                .execute()
                .value
            
            let cdProverbs: [CDProverb] = proverbDTOs.map { dto in
                let cdProverb = CDProverb(context: self.proverbData.bgContext)
                MapDtoToCd.mapToCd(dto, cdProverb)
                return cdProverb
            }
            
            print("✅ \(cdProverbs.count) proverbs fetched")
            try await proverbData.saveProverbs(cdProverbs)
            
        } catch {
            print("❌ Failed to fetch proverbs: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchLocalData() -> [Proverb] {
        let proverbs = proverbData.fetchProverbs()
        return proverbs.sorted { $0.rid < $1.rid }
    }
    
    func saveProverb(_ proverb: Proverb) {
        proverbData.saveProverb(proverb)
    }

    func updateProverb(_ proverb: Proverb) {
        proverbData.updateProverb(proverb)
    }
    
    func getProverbsByTitles(titles: [String]) -> [Proverb] {
        let proverbs = proverbData.getProverbsByTitles(titles: titles)
        return proverbs.sorted { $0.rid < $1.rid }
    }
    
    func deleteLocalData() {
        proverbData.deleteAllProverbs()
    }
    
}
