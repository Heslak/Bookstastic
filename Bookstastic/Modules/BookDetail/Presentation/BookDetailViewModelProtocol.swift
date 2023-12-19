//
//  BookDetailViewModelProtocol.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import Foundation

protocol BookDetailViewModelProtocol {
    var book: Book? { get set }
    
    func bind(input: BookDetailViewModelInput) -> BookDetailViewModelOutput
}
