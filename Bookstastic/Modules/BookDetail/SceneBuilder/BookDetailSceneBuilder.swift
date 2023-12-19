//
//  BookDetailSceneBuilder.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation

class BookDetailSceneBuilder {
    
    func build(book: Book) -> BookDetailViewController {
        let repository = BookDetailRepository(book: book)
        let favoriteRepository = HomeBooksRepository()
        let useCase = BookDetailUseCase(repository: repository,
                                        favoriteRepository: favoriteRepository)
        let viewModel = BookDetailViewModel(useCase: useCase)
        let controller = BookDetailViewController(viewModel: viewModel)
        return controller
    }
}
