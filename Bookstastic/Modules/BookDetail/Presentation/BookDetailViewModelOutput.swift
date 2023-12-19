//
//  BookDetailViewModelOutput.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation
import Combine

struct BookDetailViewModelOutput {
    let showFetchResultsPublisher = PassthroughSubject<Void, Never>()
    let showFavoriteChangePublisher = PassthroughSubject<Book, Never>()
    let showActivityViewPublisher = PassthroughSubject<[Any], Never>()
}
