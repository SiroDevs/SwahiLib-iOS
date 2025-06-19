//
//  BookRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol BookRepositoryProtocol {
    func fetchRemoteBooks() async throws -> BookResponse
    func fetchLocalBooks() -> [Book]
    func saveBooksLocally(_ books: [Book])
}

class BookRepository: BookRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let bookData: BookDataManager
    
    init(apiService: ApiServiceProtocol, bookData: BookDataManager) {
        self.apiService = apiService
        self.bookData = bookData
    }
    
    func fetchRemoteBooks() async throws -> BookResponse {
        return try await apiService.fetch(endpoint: .books)
    }
    
    func fetchLocalBooks() -> [Book] {
        let books = bookData.fetchBooks()
        return books.sorted { $0.bookId < $1.bookId }
    }
    
    func saveBooksLocally(_ books: [Book]) {
        bookData.saveBooks(books)
    }
}
