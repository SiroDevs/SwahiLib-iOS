//
//  DependencyMap.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

struct DependencyMap {
    static func registerDependencies(in container: Container) {
        container.register(PrefsRepository.self) { _ in
            PrefsRepository()
        }.inObjectScope(.container)

        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(SupabaseServiceProtocol.self) { _ in
            SupabaseService()
        }.inObjectScope(.container)

        container.register(AnalyticsServiceProtocol.self) { _ in
            AnalyticsService()
        }.inObjectScope(.container)

        container.register(LoggerProtocol.self) { _ in
            Logger()
        }.inObjectScope(.container)
        
        container.register(HistoryDataManager.self) { resolver in
            HistoryDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(IdiomDataManager.self) { resolver in
            IdiomDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ProverbDataManager.self) { resolver in
            ProverbDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SayingDataManager.self) { resolver in
            SayingDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SearchDataManager.self) { resolver in
            SearchDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(WordDataManager.self) { resolver in
            WordDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(IdiomRepositoryProtocol.self) { resolver in
            IdiomRepository(
                supabase: resolver.resolve(SupabaseServiceProtocol.self)!,
                idiomData: resolver.resolve(IdiomDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ProverbRepositoryProtocol.self) { resolver in
            ProverbRepository(
                supabase: resolver.resolve(SupabaseServiceProtocol.self)!,
                proverbData: resolver.resolve(ProverbDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SayingRepositoryProtocol.self) { resolver in
            SayingRepository(
                supabase: resolver.resolve(SupabaseServiceProtocol.self)!,
                sayingData: resolver.resolve(SayingDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(WordRepositoryProtocol.self) { resolver in
            WordRepository(
                supabase: resolver.resolve(SupabaseServiceProtocol.self)!,
                wordData: resolver.resolve(WordDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(InitViewModel.self) { resolver in
            InitViewModel(
                prefsRepo: resolver.resolve(PrefsRepository.self)!,
                idiomRepo: resolver.resolve(IdiomRepositoryProtocol.self)!,
                proverbRepo: resolver.resolve(ProverbRepositoryProtocol.self)!,
                sayingRepo: resolver.resolve(SayingRepositoryProtocol.self)!,
                wordRepo: resolver.resolve(WordRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                prefsRepo: resolver.resolve(PrefsRepository.self)!,
                idiomRepo: resolver.resolve(IdiomRepositoryProtocol.self)!,
                proverbRepo: resolver.resolve(ProverbRepositoryProtocol.self)!,
                sayingRepo: resolver.resolve(SayingRepositoryProtocol.self)!,
                wordRepo: resolver.resolve(WordRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(IdiomViewModel.self) { resolver in
            IdiomViewModel(
                idiomRepo: resolver.resolve(IdiomRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ProverbViewModel.self) { resolver in
            ProverbViewModel(
                proverbRepo: resolver.resolve(ProverbRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SayingViewModel.self) { resolver in
            SayingViewModel(
                sayingRepo: resolver.resolve(SayingRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(WordViewModel.self) { resolver in
            WordViewModel(
                wordRepo: resolver.resolve(WordRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
    }
}
