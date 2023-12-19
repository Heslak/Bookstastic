//
//  BookDetailViewModel.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation
import Combine

class BookDetailViewModel: BookDetailViewModelProtocol {
    
    // MARK: - Variables
    var book: Book?
    
    // MARK: - Private Variables
    private var output = BookDetailViewModelOutput()
    private var cancellable = Set<AnyCancellable>()
    private var useCase: BookDetailUseCase
    
    init(useCase: BookDetailUseCase) {
        self.useCase = useCase
    }
    
    func bind(input: BookDetailViewModelInput) -> BookDetailViewModelOutput {
        input.viewDidLoadPublisher.sink { [weak self] in
            self?.fetchBook()
        }.store(in: &cancellable)
        
        input.changeFavoritePublisher.sink { [weak self] in
            self?.changeFavorite()
        }.store(in: &cancellable)
        
        input.shareBookPublisher.sink { [weak self] in
            self?.shareBook()
        }.store(in: &cancellable)
        
        return output
    }
    
    // MARK: - Private Methods
    private func fetchBook() {
        useCase.getBookDetail().sink { [weak self] book in
            self?.book = book
            self?.output.showFetchResultsPublisher.send()
        }.store(in: &cancellable)
    }
    
//    private func changeFavorite() {
//        book?.isFavorite.toggle()
//        guard let book = book else { return }
//        output.showFavoriteChangePublisher.send(book)
//    }
    
    private func changeFavorite() {
        book?.isFavorite.toggle()
        guard let book = book else { return }
        if book.isFavorite {
            setBookAsFavorite(for: book)
        } else {
            removeBookAsFavorite(for: book)
        }
    }
    
    private func setBookAsFavorite(for book: Book) {
        useCase.setBookAsFavorite(book: book).sink { [weak self] isSaved in
            self?.output.showFavoriteChangePublisher.send(book)
        }.store(in: &cancellable)
    }
    
    private func removeBookAsFavorite(for book: Book) {
        useCase.removeBookAsFavorite(book: book).sink { [weak self] _ in
            self?.output.showFavoriteChangePublisher.send(book)
        }.store(in: &cancellable)
    }
    
    private func shareBook() {
        guard let infoLink = book?.volumeInfo.infoLink else { return }
        guard let infoUrl = URL(string: infoLink) else { return }
        let activityItems = [infoUrl] as [Any]
        output.showActivityViewPublisher.send(activityItems)
    }
}
