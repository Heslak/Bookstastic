//
//  HomeBooksUseCaseProtocol.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

protocol HomeBooksUseCaseProtocol {
    func fetchBooks(searchText: String) -> AnyPublisher<BooksList, Error>?
}
