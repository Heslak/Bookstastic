//
//  Bookstastic.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation

enum Bookstastic {
    static var baseUrl: String = "https://www.googleapis.com/"
    static var apiVersion: String = "books/v1"
    static var fullUrl: URL? {
        get {
            return URL(string: Bookstastic.baseUrl+Bookstastic.apiVersion)
        }
    }
}
