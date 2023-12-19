//
//  BookDetailUseCaseProtocol.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation
import Combine

protocol BookDetailUseCaseProtocol {
    func getBookDetail() -> AnyPublisher<Book, Never>
}
