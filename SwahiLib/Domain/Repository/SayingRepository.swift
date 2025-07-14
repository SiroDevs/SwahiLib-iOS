//
//  SayingRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol SayingRepositoryProtocol {
    func fetchRemoteData() async throws -> [Saying]
    func saveRemoteData(_ sayings: [Saying])
    func fetchLocalData() -> [Saying]
    func updateSaying(_ saying: Saying)
}

class SayingRepository: SayingRepositoryProtocol {
    func updateSaying(_ saying: Saying) {
        sayingData.updateSaying(saying)
    }
    
    private let supabase: SupabaseServiceProtocol
    private let sayingData: SayingDataManager
    
    init(supabase: SupabaseServiceProtocol, sayingData: SayingDataManager) {
        self.supabase = supabase
        self.sayingData = sayingData
    }
    
    func fetchRemoteData() async throws -> [Saying] {
        do {
            let sayingsDtos: [SayingDTO] = try await supabase.client
                .from("sayings")
                .select()
                .execute()
                .value
            
            let sayings: [Saying] = sayingsDtos.map { MapDtoToEntity.mapToEntity($0) }
            print("✅ Sayings fetched: \(sayings.count)")
            return sayings
        } catch {
            print("❌ Failed to fetch sayings: \(error.localizedDescription)")
            throw error
        }
    }
    
    func saveRemoteData(_ saying: Saying) {
        sayingData.saveSaying(saying)
    }
     
    func fetchLocalData() -> [Saying] {
        let sayings = sayingData.fetchSayings()
        return sayings.sorted { $0.id < $1.id }
    }
    
}
