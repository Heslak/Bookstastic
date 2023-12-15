//
//  HomeBooksUseCase.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation

class HomeBooksUseCase: HomeBooksUseCaseProtocol {
    
    var repository: HomeBooksRepositoryProtocol
    
    init(repository: HomeBooksRepositoryProtocol) {
        self.repository = repository
    }
}
