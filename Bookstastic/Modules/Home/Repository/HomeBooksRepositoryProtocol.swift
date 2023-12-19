//
//  HomeBooksRepositoryProtocol.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

protocol HomeBooksRepositoryProtocol {
    func fetchBooksFromLocal() -> AnyPublisher<BooksList, Never>
    func fetchBooks(searchText: String, currentIndex: Int) -> AnyPublisher<BooksList, Error>?
    func setBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never>
    func removeBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never>
}

