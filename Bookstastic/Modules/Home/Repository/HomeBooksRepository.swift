//
//  HomeBooksRepository.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

class HomeBooksRepository: HomeBooksRepositoryProtocol {
    
    func fetchBooks(searchText: String, currentIndex: Int) -> AnyPublisher<BooksList, Error>? {
        let searchQuer = URLQueryItem(name: "q", value: searchText)
        let indexQuery = URLQueryItem(name: "startIndex", value: "\(currentIndex)")
        return ApiRest.shared.get(component: "volumes", queryItems: [searchQuer, indexQuery])
    }
}
