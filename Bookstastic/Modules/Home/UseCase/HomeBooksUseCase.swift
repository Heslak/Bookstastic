//
//  HomeBooksUseCase.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

class HomeBooksUseCase: HomeBooksUseCaseProtocol {
    
    var repository: HomeBooksRepositoryProtocol
    
    init(repository: HomeBooksRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchBooksFromLocal() -> AnyPublisher<BooksList, Never> {
        return repository.fetchBooksFromLocal()
    }
    
    func fetchBooks(searchText: String, currentIndex: Int) -> AnyPublisher<BooksList, Error>? {
        return repository.fetchBooks(searchText: searchText, currentIndex: currentIndex)
    }
    
    func setBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never> {
        return repository.setBookAsFavorite(book: book)
    }
    
    func removeBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never> {
        return repository.removeBookAsFavorite(book: book)
    }
}
