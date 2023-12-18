//
//  HomeBooksViewModelProtocol.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation

protocol HomeBooksViewModelProtocol {
    var booksList: BooksList { get set }
    
    func bind(input: HomeBooksViewModelInput) -> HomeBooksViewModelOutput
}
