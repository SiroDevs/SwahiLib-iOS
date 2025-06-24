//
//  ProverbRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol ProverbRepositoryProtocol {
    func fetchRemoteData() async throws -> [ProverbDTO]
    func saveRemoteData(_ proverbs: [ProverbDTO])
    func fetchLocalData() -> [Proverb]
    func updateProverb(_ proverb: Proverb)
}

class ProverbRepository: ProverbRepositoryProtocol {
    func updateProverb(_ proverb: Proverb) {
        proverbData.updateProverb(proverb)
    }
    
    private let supabase: SupabaseServiceProtocol
    private let proverbData: ProverbDataManager
    
    init(supabase: SupabaseServiceProtocol, proverbData: ProverbDataManager) {
        self.supabase = supabase
        self.proverbData = proverbData
    }
    
    func fetchRemoteData() async throws -> [ProverbDTO] {
        do {
            let proverbs: [ProverbDTO] = try await supabase.client
                .from("proverbs")
                .select()
                .execute()
                .value
            
            print("✅ Proverbs fetched: \(proverbs.count)")
            return proverbs
        } catch {
            print("❌ Failed to fetch proverbs: \(error.localizedDescription)")
            throw error
        }
    }
    
    func saveRemoteData(_ proverbs: [ProverbDTO]) {
        proverbData.saveProverbs(proverbs)
    }

    func fetchLocalData() -> [Proverb] {
        let proverbs = proverbData.fetchProverbs()
        return proverbs.sorted { $0.id < $1.id }
    }
    
}
