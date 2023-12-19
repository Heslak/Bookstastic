//
//  HomeBooksRepository.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine
import CoreData

class HomeBooksRepository: HomeBooksRepositoryProtocol {
    
    func fetchBooksFromLocal() -> AnyPublisher<BooksList, Never> {
        let context = AppDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookLocal")
        request.sortDescriptors = [NSSortDescriptor(key: "volumeInfo.title", ascending: true)]
        
        return Future() { completion in
            do {
                let result = try context.fetch(request) as? [NSManagedObject] ?? []
                var books = [Book]()
                for data in result {
                    guard let book = Book(from: data) else { continue }
                    books.append(book)
                }
                let booksList: BooksList = BooksList(items: books)
                completion(.success(booksList))
            } catch {
                completion(.success(BooksList()))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchBooks(searchText: String, currentIndex: Int) -> AnyPublisher<BooksList, Error>? {
        let searchQuer = URLQueryItem(name: "q", value: searchText)
        let indexQuery = URLQueryItem(name: "startIndex", value: "\(currentIndex)")
        let sortQuery = URLQueryItem(name: "orderBy", value: "relevance")
        return ApiRest.shared.get(component: "volumes", queryItems: [searchQuer,
                                                                     indexQuery,
                                                                     sortQuery])
    }
    
    func setBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never> {
        return Future() { completion in
            
            let context = AppDelegate.persistentContainer.viewContext
            guard let bookEntity = NSEntityDescription.entity(forEntityName: "BookLocal",
                                                              in: context) else { return completion(.success(false)) }
            guard let volumeInfoEntity = NSEntityDescription.entity(forEntityName: "VolumeInfoLocal",
                                                                    in: context) else { return completion(.success(false)) }
            guard let imageLinksEntity = NSEntityDescription.entity(forEntityName: "ImageLinksLocal",
                                                                    in: context) else { return completion(.success(false)) }
            
            let localBook = NSManagedObject(entity: bookEntity, insertInto: context)
            let localVolumeInfo = NSManagedObject(entity: volumeInfoEntity, insertInto: context)
            let localImageLinks = NSManagedObject(entity: imageLinksEntity, insertInto: context)
            
            book.mapToLocalBook(into: localBook)
            book.volumeInfo.mapToLocalVolumeInfo(into: localVolumeInfo)
            localBook.setValue(localVolumeInfo, forKey: "volumeInfo")
            book.volumeInfo.imageLinks?.mapToLocalImageLinks(into: localImageLinks)
            localVolumeInfo.setValue(localImageLinks, forKey: "imageLinks")
            do {
                try context.save()
                completion(.success(true))
            } catch {
                completion(.success(false))
            }
        }.eraseToAnyPublisher()
    }
    
    func removeBookAsFavorite(book: Book) -> AnyPublisher<Bool, Never> {
        let context = AppDelegate.persistentContainer.viewContext
        return Future() { completion in
            
            guard let book = self.fetchBook(from: context, with: book.identifier) else {
                completion(.success(true))
                return
            }
            
            context.delete(book)
            try? context.save()
            completion(.success(true))
        }.eraseToAnyPublisher()
    }
    
    func checkIfIsFavorite(book: Book) -> AnyPublisher<Bool, Never> {
        let context = AppDelegate.persistentContainer.viewContext
        return Future() { completion in
            guard let book = self.fetchBook(from: context, with: book.identifier) else {
                completion(.success(false))
                return
            }
            
            print(book)
            completion(.success(true))
        }.eraseToAnyPublisher()
    }
    
    private func fetchBook(from context: NSManagedObjectContext,
                           with identifier: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookLocal")
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        request.predicate = predicate
        let result = try? context.fetch(request) as? [NSManagedObject] ?? []
        return result?.first
    }
}
