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
    
    init(repository: BookDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func getBookDetail() -> AnyPublisher<Book, Never> {
        return repository.getBookDetail()
    }
}
