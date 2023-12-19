//
//  BookDetailRepository.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation
import Combine

class BookDetailRepository: BookDetailRepositoryProtocol {
    
    // MARK: - Variables
    var book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    func getBookDetail() -> AnyPublisher<Book, Never> {
        return Future() { [unowned self] result in
            return result(.success(self.book))
        }.eraseToAnyPublisher()
    }
}
