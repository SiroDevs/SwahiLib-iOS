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
        
        container.register(ApiServiceProtocol.self) { _ in
            ApiService()
        }.inObjectScope(.container)

        container.register(AnalyticsServiceProtocol.self) { _ in
            AnalyticsService()
        }.inObjectScope(.container)

        container.register(LoggerProtocol.self) { _ in
            Logger()
        }.inObjectScope(.container)
        
        container.register(BookDataManager.self) { resolver in
            BookDataManager(coreDataManager: resolver.resolve(CoreDataManager.self)!)
        }.inObjectScope(.container)
        
        container.register(BookRepositoryProtocol.self) { resolver in
            BookRepository(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                bookData: resolver.resolve(BookDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SongDataManager.self) { resolver in
            SongDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
                bookDataManager: resolver.resolve(BookDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SongRepositoryProtocol.self) { resolver in
            SongRepository(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                songData: resolver.resolve(SongDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SelectionViewModel.self) { resolver in
            SelectionViewModel(
                prefsRepo: resolver.resolve(PrefsRepository.self)!,
                bookRepo: resolver.resolve(BookRepositoryProtocol.self)!,
                songRepo: resolver.resolve(SongRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                prefsRepo: resolver.resolve(PrefsRepository.self)!,
                bookRepo: resolver.resolve(BookRepositoryProtocol.self)!,
                songRepo: resolver.resolve(SongRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(PresenterViewModel.self) { resolver in
            PresenterViewModel(
                prefsRepo: resolver.resolve(PrefsRepository.self)!,
                songRepo: resolver.resolve(SongRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
    }
}
