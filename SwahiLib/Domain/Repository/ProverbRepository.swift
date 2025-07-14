//
//  ProverbRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol ProverbRepositoryProtocol {
    func fetchRemoteData() async throws -> [Proverb]
    func saveRemoteData(_ proverbs: [Proverb])
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
    
    func saveRemoteData(_ proverb: Proverb) {
        proverbData.saveProverb(proverb)
    }

    func fetchLocalData() -> [Proverb] {
        let proverbs = proverbData.fetchProverbs()
        return proverbs.sorted { $0.id < $1.id }
    }
    
}
