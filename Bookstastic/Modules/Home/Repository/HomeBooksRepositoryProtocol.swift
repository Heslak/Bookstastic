//
//  HomeBooksRepositoryProtocol.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

protocol HomeBooksRepositoryProtocol {
    func fetchBooks(searchText: String, currentIndex: Int) -> AnyPublisher<BooksList, Error>?
}

