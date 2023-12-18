//
//  HomeBooksViewModelOutput.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

struct HomeBooksViewModelOutput {
    let showFetchResultsPublisher = PassthroughSubject<Void, Never>()
    let showFavoriteChangePublisher = PassthroughSubject<IndexPath, Never>()
}
