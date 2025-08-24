//
//  DiContainer.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

final class DiContainer {
    static let shared = DiContainer()
    let container: Container

    private init() {
        container = Container()
        DependencyMap.registerDependencies(in: container)
        validateDependencies()
    }

    private func validateDependencies() {
        let dependencies: [() -> Any?] = [
            { self.container.resolve(PrefsRepository.self) },
            { self.container.resolve(CoreDataManager.self) },
            { self.container.resolve(SupabaseServiceProtocol.self) },
            { self.container.resolve(AnalyticsServiceProtocol.self) },
            { self.container.resolve(LoggerProtocol.self) },
            { self.container.resolve(HistoryDataManager.self) },
            { self.container.resolve(IdiomDataManager.self) },
            { self.container.resolve(ProverbDataManager.self) },
            { self.container.resolve(SayingDataManager.self) },
            { self.container.resolve(SearchDataManager.self) },
            { self.container.resolve(WordDataManager.self) },
            { self.container.resolve(IdiomRepositoryProtocol.self) },
            { self.container.resolve(ProverbRepositoryProtocol.self) },
            { self.container.resolve(SayingRepositoryProtocol.self) },
            { self.container.resolve(WordRepositoryProtocol.self) },
            { self.container.resolve(SubscriptionRepositoryProtocol.self) },
            { self.container.resolve(InitViewModel.self) },
            { self.container.resolve(HomeViewModel.self) },
            { self.container.resolve(IdiomViewModel.self) },
            { self.container.resolve(ProverbViewModel.self) },
            { self.container.resolve(SayingViewModel.self) },
            { self.container.resolve(WordViewModel.self) },
        ]

        for resolve in dependencies {
            guard resolve() != nil else {
                fatalError("One or more dependencies are not registered in the container.")
            }
        }
        print("All dependencies are successfully registered.")
    }
}

extension DiContainer {
    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(type) else {
            fatalError("Failed to resolve dependency: \(type)")
        }
        return dependency
    }

    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        guard let dependency = container.resolve(type, argument: argument) else {
            fatalError("Failed to resolve dependency: \(type) with argument: \(argument)")
        }
        return dependency
    }
}
