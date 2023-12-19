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
          
        input.viewDidLoadPublisher.sink { [weak self] in
            self?.fetchLocalBooks()
        }.store(in: &cancellable)
        
        input.fetchBooksPublisher.sink { [weak self] searchText in
            self?.fetchBooks(with: searchText)
        }.store(in: &cancellable)
        
        input.cleanBooksListPublisher.sink { [weak self] isSearching in
            self?.cleanBooskList(isSearching: isSearching)
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
    private func fetchLocalBooks() {
        DispatchQueue.main.async {
            self.useCase.fetchBooksFromLocal().sink { [weak self] booksList in
                self?.booksList = booksList
                self?.output.showFetchResultsPublisher.send()
            }.store(in: &self.cancellable)
        }
    }
        
    private func fetchBooks(with searchText: String) {
        self.currentSerchtext = searchText
        useCase.fetchBooks(searchText: searchText,
                           currentIndex: currentIndex)?.sink { [weak self] result in
            switch result {
            case .finished:
                break
            case .failure(_):
                self?.output.showErrorAlertPublisher.send()
            }
        } receiveValue: { [weak self] booksList in
            self?.booksList = booksList
            self?.output.showFetchResultsPublisher.send()
        }.store(in: &cancellable)
    }
    
    private func cleanBooskList(isSearching: Bool) {
        if !isSearching {
            fetchLocalBooks()
        } else {
            booksList = BooksList()
        }
        currentIndex = 0
        output.showFetchResultsPublisher.send()
    }
    
    private func changeFavorite(for indexPath: IndexPath) {
        booksList.items[indexPath.row].isFavorite.toggle()
        let book =  booksList.items[indexPath.row]
        
        if book.isFavorite {
            setBookAsFavorite(for: book, indexPath: indexPath)
        } else {
            removeBookAsFavorite(for: book, indexPath: indexPath)
        }
    }
    
    private func setBookAsFavorite(for book: Book, indexPath: IndexPath) {
        useCase.setBookAsFavorite(book: book).sink { [weak self] isSaved in
            self?.output.showFavoriteChangePublisher.send(indexPath)
        }.store(in: &cancellable)
    }
    
    private func removeBookAsFavorite(for book: Book, indexPath: IndexPath) {
        useCase.removeBookAsFavorite(book: book).sink { [weak self] _ in
            self?.output.showFavoriteChangePublisher.send(indexPath)
        }.store(in: &cancellable)
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
