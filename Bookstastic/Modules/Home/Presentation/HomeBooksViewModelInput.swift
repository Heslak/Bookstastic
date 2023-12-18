//
//  HomeBooksViewModelInput.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

struct HomeBooksViewModelInput {
    let viewDidLoadPublisher = PassthroughSubject<Void, Never>()
    let fetchBooksPublisher = PassthroughSubject<String, Never>()
    let cleanBooksListPublisher = PassthroughSubject<Void, Never>()
    let changeFavoritePublisher = PassthroughSubject<IndexPath, Never>()
}
