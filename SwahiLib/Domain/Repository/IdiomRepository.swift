//
//  IdiomRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol IdiomRepositoryProtocol {
    func fetchRemoteData() async throws -> [Idiom]
    func saveRemoteData(_ idioms: [Idiom])
    func fetchLocalData() -> [Idiom]
    func updateIdiom(_ idiom: Idiom)
}

class IdiomRepository: IdiomRepositoryProtocol {
    func updateIdiom(_ idiom: Idiom) {
        idiomData.updateIdiom(idiom)
    }
    
    private let supabase: SupabaseServiceProtocol
    private let idiomData: IdiomDataManager
    
    init(supabase: SupabaseServiceProtocol, idiomData: IdiomDataManager) {
        self.supabase = supabase
        self.idiomData = idiomData
    }
    
    func fetchRemoteData() async throws -> [Idiom] {
        do {
            let idiomsDtos: [IdiomDTO] = try await supabase.client
                .from("idioms")
                .select()
                .execute()
                .value
            let idioms: [Idiom] = idiomsDtos.map { MapDtoToEntity.mapToEntity($0) }
            print("✅ Idioms fetched: \(idioms.count)")
            return idioms
        } catch {
            print("❌ Failed to fetch idioms: \(error.localizedDescription)")
            throw error
        }
    }
    
    func saveRemoteData(_ idioms: [Idiom]) {
        idiomData.saveIdioms(idioms)
    }
    
    func fetchLocalData() -> [Idiom] {
        let idioms = idiomData.fetchIdioms()
        return idioms.sorted { $0.id < $1.id }
    }
    
}
