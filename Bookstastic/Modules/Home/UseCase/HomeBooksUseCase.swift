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
    
    func fetchBooks(searchText: String) -> AnyPublisher<BooksList, Error>? {
        return repository.fetchBooks(searchText: searchText)
    }
}
