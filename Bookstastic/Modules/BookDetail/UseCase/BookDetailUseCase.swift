//
//  BookDetailUseCase.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation
import Combine

class BookDetailUseCase: BookDetailUseCaseProtocol {
    
    // MARK: - Variables
    var repository: BookDetailRepositoryProtocol
    var favoriteRepository: HomeBooksRepository
    
    init(repository: BookDetailRepositoryProtocol,
         favoriteRepository: HomeBooksRepository) {
        self.repository = repository
        self.favoriteRepository = favoriteRepository
    }
    
    func getBookDetail() -> AnyPublisher<Book, Never> {
        return repository.getBookDetail()
    }
    
    func setBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never> {
        return favoriteRepository.setBookAsFavorite(book: book)
    }
    
    func removeBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never> {
        return favoriteRepository.removeBookAsFavorite(book: book)
    }
}
