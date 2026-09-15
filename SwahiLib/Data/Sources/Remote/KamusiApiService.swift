//
//  KamusiApiService.swift
//  SwahiLib
//

import Foundation

protocol KamusiApiServiceProtocol {
    func fetchETag(_ endpoint: KamusiEndpoint, storedETag: String?) async -> String?

    func fetchJson<T: Decodable>(_ endpoint: KamusiEndpoint) async -> [T]?
    func fetchRawJson(_ endpoint: KamusiEndpoint) async -> String?
}

enum KamusiEndpoint: CaseIterable {
    case words
    case idioms
    case proverbs
    case sayings

    case libraryCaps
    case libraryCountries
    case libraryFamily
    case libraryFish
    case libraryGreetings
    case libraryInsects
    case libraryKidGames
    case libraryPunctuation
    case librarySeas

    var path: String {
        switch self {
        case .words: return "kamusi/words.json"
        case .idioms: return "kamusi/idioms.json"
        case .proverbs: return "kamusi/proverbs.json"
        case .sayings: return "kamusi/sayings.json"
        case .libraryCaps: return "maktaba/\(LibraryKeys.caps).json"
        case .libraryCountries: return "maktaba/\(LibraryKeys.countries).json"
        case .libraryFamily: return "maktaba/\(LibraryKeys.family).json"
        case .libraryFish: return "maktaba/\(LibraryKeys.fish).json"
        case .libraryGreetings: return "maktaba/\(LibraryKeys.greetings).json"
        case .libraryInsects: return "maktaba/\(LibraryKeys.insects).json"
        case .libraryKidGames: return "maktaba/\(LibraryKeys.kidGames).json"
        case .libraryPunctuation: return "maktaba/\(LibraryKeys.punctuation).json"
        case .librarySeas: return "maktaba/\(LibraryKeys.seas).json"
        }
    }

    var prefKey: String {
        switch self {
        case .words: return "etag_words"
        case .idioms: return "etag_idioms"
        case .proverbs: return "etag_proverbs"
        case .sayings: return "etag_sayings"
        case .libraryCaps: return "etag_caps"
        case .libraryCountries: return "etag_countries"
        case .libraryFamily: return "etag_family"
        case .libraryFish: return "etag_fish"
        case .libraryGreetings: return "etag_greetings"
        case .libraryInsects: return "etag_insects"
        case .libraryKidGames: return "etag_kid_games"
        case .libraryPunctuation: return "etag_punctuation"
        case .librarySeas: return "etag_seas"
        }
    }

    var libraryCollectionKey: String? {
        switch self {
        case .libraryCaps: return LibraryKeys.caps
        case .libraryCountries: return LibraryKeys.countries
        case .libraryFamily: return LibraryKeys.family
        case .libraryFish: return LibraryKeys.fish
        case .libraryGreetings: return LibraryKeys.greetings
        case .libraryInsects: return LibraryKeys.insects
        case .libraryKidGames: return LibraryKeys.kidGames
        case .libraryPunctuation: return LibraryKeys.punctuation
        case .librarySeas: return LibraryKeys.seas
        default: return nil
        }
    }

    static func forLibraryKey(_ key: String) -> KamusiEndpoint? {
        allCases.first { $0.libraryCollectionKey == key }
    }
}

enum KamusiApiError: LocalizedError {
    case fetchFailed(KamusiEndpoint)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let endpoint):
            return "Failed to fetch \(endpoint.path)"
        }
    }
}

final class KamusiApiService: KamusiApiServiceProtocol {
    private let session: URLSession
    private let baseURL: URL

    init(session: URLSession = .shared, baseURL: URL = URL(string: AppConstants.kamusiApiBaseURL)!) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchETag(_ endpoint: KamusiEndpoint, storedETag: String?) async -> String? {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))
        if let storedETag {
            request.setValue(storedETag, forHTTPHeaderField: "If-None-Match")
        }

        do {
            let (_, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { return nil }

            switch http.statusCode {
            case 304:
                print("✅ \(endpoint.path) unchanged (304)")
                return nil
            case 200:
                let etag = http.value(forHTTPHeaderField: "ETag")
                print("🔄 \(endpoint.path) changed — new ETag: \(etag ?? "none")")
                return etag
            default:
                print("⚠️ \(endpoint.path) unexpected status \(http.statusCode)")
                return nil
            }
        } catch {
            print("❌ ETag check failed for \(endpoint.path): \(error.localizedDescription)")
            return nil
        }
    }

    func fetchJson<T: Decodable>(_ endpoint: KamusiEndpoint) async -> [T]? {
        let request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                print("❌ \(endpoint.path) fetch failed")
                return nil
            }
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("❌ JSON fetch failed for \(endpoint.path): \(error.localizedDescription)")
            return nil
        }
    }

    func fetchRawJson(_ endpoint: KamusiEndpoint) async -> String? {
        let request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                print("❌ \(endpoint.path) fetch failed")
                return nil
            }
            return String(data: data, encoding: .utf8)
        } catch {
            print("❌ raw fetch failed for \(endpoint.path): \(error.localizedDescription)")
            return nil
        }
    }
}
