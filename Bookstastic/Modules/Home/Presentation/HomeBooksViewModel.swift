//
//  HomeBooksViewModel.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

class HomeBooksViewModel: HomeBooksViewModelProtocol {
    
    // MARK: - Variables
    var useCase: HomeBooksUseCaseProtocol
    var booksList: BooksList = BooksList()
    var currentIndex: Int = 0
    
    // MARK: - Private Variables
    private var output = HomeBooksViewModelOutput()
    private var cancellable = Set<AnyCancellable>()
    private var currentSerchtext: String = String()
    private var elementsPerPage = 10
    
    init(useCase: HomeBooksUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // MARK: - Binding
    func bind(input: HomeBooksViewModelInput) -> HomeBooksViewModelOutput {
                
        input.fetchBooksPublisher.sink { [weak self] searchText in
            self?.fetchBooks(with: searchText)
        }.store(in: &cancellable)
        
        input.cleanBooksListPublisher.sink { [weak self] in
            self?.cleanBooskList()
        }.store(in: &cancellable)
        
        input.changeFavoritePublisher.sink { [weak self] indexPath in
            self?.changeFavorite(for: indexPath)
        }.store(in: &cancellable)
        
        input.increaseCounterPublisher.sink { [weak self] in
            self?.increaseCounter()
        }.store(in: &cancellable)
        
        input.decreaseCounterPublisher.sink { [weak self] in
            self?.decreaseCounter()
        }.store(in: &cancellable)
        
        return output
    }
    
    // MARK: - Private Methods
    private func fetchBooks(with searchText: String) {
        self.currentSerchtext = searchText
        useCase.fetchBooks(searchText: searchText,
                           currentIndex: currentIndex)?.sink { [weak self] result in
            switch result {
            case .finished:
                break
            case .failure(let failure):
                print("Error \(failure)")
            }
        } receiveValue: { [weak self] booksList in
            self?.booksList = booksList
            self?.output.showFetchResultsPublisher.send()
        }.store(in: &cancellable)
    }
    
    private func cleanBooskList() {
        booksList = BooksList()
        currentIndex = 0
        output.showFetchResultsPublisher.send()
    }
    
    private func changeFavorite(for indexPath: IndexPath) {
        booksList.items[indexPath.row].isFavorite.toggle()
        output.showFavoriteChangePublisher.send(indexPath)
    }
    
    private func increaseCounter() {
        guard booksList.items.count != 0 else { return }
        currentIndex += elementsPerPage
        fetchBooks(with: currentSerchtext)
    }
    
    private func decreaseCounter() {
        guard currentIndex > 0 else { return }
        currentIndex -= elementsPerPage
        fetchBooks(with: currentSerchtext)
    }
}
