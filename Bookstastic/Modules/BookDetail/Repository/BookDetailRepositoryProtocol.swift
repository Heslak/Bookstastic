//
//  BookDetailRepositoryProtocol.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation
import Combine

protocol BookDetailRepositoryProtocol {
    func getBookDetail() -> AnyPublisher<Book, Never>
}
