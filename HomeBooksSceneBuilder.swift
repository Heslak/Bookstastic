//
//  HomeBooksSceneBuilder.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation

class HomeBooksSceneBuilder {
    
    func build() -> HomeBooksViewController {
        let repository = HomeBooksRepository()
        let useCase = HomeBooksUseCase(repository: repository)
        let viewModel = HomeBooksViewModel(useCase: useCase)
        let controller =  HomeBooksViewController(viewModel: viewModel)
        return controller
    }
}
