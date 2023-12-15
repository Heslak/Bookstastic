//
//  HomeBooksViewModel.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation

class HomeBooksViewModel: HomeBooksViewModelProtocol {
    var useCase: HomeBooksUseCaseProtocol
    
    init(useCase: HomeBooksUseCaseProtocol) {
        self.useCase = useCase
    }
}
