//
//  ApiService.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

protocol ApiServiceProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T
}

class ApiService: ApiServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw ApiError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ApiError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.decodingError(error)
        }
    }
}

enum ApiError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}
