//
//  BookDetailViewModelInput.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation
import Combine

struct BookDetailViewModelInput {
    let viewDidLoadPublisher = PassthroughSubject<Void, Never>()
    let changeFavoritePublisher = PassthroughSubject<Void, Never>()
    let shareBookPublisher = PassthroughSubject<Void, Never>()
}
