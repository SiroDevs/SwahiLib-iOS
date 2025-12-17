//
//  IdiomRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//

import Foundation

protocol IdiomRepoProtocol {
    func fetchRemoteData() async throws
    func fetchLocalData() -> [Idiom]
    func getIdiomsByTitles(titles: [String]) -> [Idiom]
    func saveIdiom(_ idiom: Idiom)
    func updateIdiom(_ idiom: Idiom)
    func deleteLocalData()
}

class IdiomRepo: IdiomRepoProtocol {
    private let supabase: SupabaseServiceProtocol
    private let idiomData: IdiomDataManager
    
    init(supabase: SupabaseServiceProtocol, idiomData: IdiomDataManager) {
        self.supabase = supabase
        self.idiomData = idiomData
    }
    
    func fetchRemoteData() async throws {
        do {
            let idiomsDtos: [IdiomDTO] = try await supabase.client
                .from("idioms")
                .select()
                .execute()
                .value
            let idioms: [Idiom] = idiomsDtos.map { MapDtoToEntity.mapToEntity($0) }
            print("✅ Idioms fetched: \(idioms.count)")
            idiomData.saveIdioms(idioms)
        } catch {
            print("❌ Failed to fetch idioms: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchLocalData() -> [Idiom] {
        let idioms = idiomData.fetchIdioms()
        return idioms.sorted { $0.id < $1.id }
    }
    
    func saveIdiom(_ idiom: Idiom) {
        idiomData.saveIdiom(idiom)
    }
    
    func updateIdiom(_ idiom: Idiom) {
        idiomData.updateIdiom(idiom)
    }
    
    func getIdiomsByTitles(titles: [String]) -> [Idiom] {
        let idioms = idiomData.getIdiomsByTitles(titles: titles)
        return idioms.sorted { $0.id < $1.id }
    }
    
    func deleteLocalData() {
        idiomData.deleteAllIdioms()
    }
    
}
