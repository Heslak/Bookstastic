//
//  Book.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import CoreData

struct BooksList: Decodable {
    let kind: String
    let totalItems: Int
    var items: [Book]
    
    init(kind: String = "", totalItems: Int = 0, items: [Book] = [Book]()) {
        self.kind = kind
        self.totalItems = totalItems
        self.items = items
    }
    
    enum CodingKeys: CodingKey {
        case kind
        case totalItems
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.totalItems = try container.decode(Int.self, forKey: .totalItems)
        self.items = try container.decodeIfPresent([Book].self, forKey: .items) ?? [Book]()
    }
}

struct Book: Decodable {
    let kind: String
    let identifier: String
    var isFavorite: Bool = false
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    
    enum CodingKeys: String, CodingKey {
        case kind, etag, selfLink, volumeInfo
        case identifier = "id"
    }
    
    init?(from localBook: NSManagedObject) {
        guard let kind = localBook.value(forKey: "kind") as? String else { return nil }
        guard let identifier = localBook.value(forKey: "identifier") as? String else { return nil }
        guard let isFavorite = localBook.value(forKey: "isFavorite") as? Bool else { return nil }
        guard let etag = localBook.value(forKey: "etag") as? String else { return nil }
        guard let selfLink = localBook.value(forKey: "selfLink") as? String else { return nil }
        guard let volumeInfoObject = localBook.value(forKey: "volumeInfo") as? NSManagedObject else { return nil }
        guard let volumeInfo = VolumeInfo(from: volumeInfoObject) else { return nil }
        
        self.kind = kind
        self.identifier = identifier
        self.isFavorite = isFavorite
        self.etag = etag
        self.selfLink = selfLink
        self.volumeInfo = volumeInfo
    }
    
    func mapToLocalBook(into localBook: NSManagedObject) {
        localBook.setValue(kind, forKey: "kind")
        localBook.setValue(identifier, forKey: "identifier")
        localBook.setValue(isFavorite, forKey: "isFavorite")
        localBook.setValue(etag, forKey: "etag")
        localBook.setValue(selfLink, forKey: "selfLink")
    }
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let printType: String
    let maturityRating: String
    let allowAnonLogging: Bool
    let contentVersion: String
    let imageLinks: ImageLinks?
    let language: String
    let previewLink: String
    let infoLink: String
    let canonicalVolumeLink: String
    
    func getAuthors() -> String {
       return authors?.reduce("") { rest, autor in
           
            if rest == "" {
                return autor
            }
            
            return rest + ", " + autor
        } ?? "No Info"
    }
    
    init?(from localVolumeInfo: NSManagedObject) {
        guard let title = localVolumeInfo.value(forKey: "title") as? String else { return nil }
        guard let authors = localVolumeInfo.value(forKey: "authors") as? [String]? else { return nil }
        guard let publishedDate = localVolumeInfo.value(forKey: "publishedDate") as? String? else { return nil }
        guard let description = localVolumeInfo.value(forKey: "desc") as? String? else { return nil }
        guard let pageCount = localVolumeInfo.value(forKey: "pageCount") as? Int? else { return nil }
        guard let printType = localVolumeInfo.value(forKey: "printType") as? String else { return nil }
        guard let maturityRating = localVolumeInfo.value(forKey: "maturityRating") as? String else { return nil }
        guard let allowAnonLogging = localVolumeInfo.value(forKey: "allowAnonLogging") as? Bool else { return nil }
        guard let contentVersion = localVolumeInfo.value(forKey: "contentVersion") as? String else { return nil }
        guard let language = localVolumeInfo.value(forKey: "language") as? String else { return nil }
        guard let previewLink = localVolumeInfo.value(forKey: "previewLink") as? String else { return nil }
        guard let infoLink = localVolumeInfo.value(forKey: "infoLink") as? String else { return nil }
        guard let canonicalVolumeLink = localVolumeInfo.value(forKey: "canonicalVolumeLink") as? String else { return nil }
        
        
        self.title = title
        self.authors = authors
        self.publishedDate = publishedDate
        self.description = description
        self.pageCount = pageCount
        self.printType = printType
        self.maturityRating = maturityRating
        self.allowAnonLogging = allowAnonLogging
        self.contentVersion = contentVersion
        self.language = language
        self.previewLink = previewLink
        self.infoLink = infoLink
        self.canonicalVolumeLink = canonicalVolumeLink

        if let imageLinks = localVolumeInfo.value(forKey: "imageLinks") as? NSManagedObject {
            self.imageLinks = ImageLinks(from: imageLinks)
        } else {
            imageLinks = nil
        }

    }
    
    func mapToLocalVolumeInfo(into localVolumeInfo: NSManagedObject) {
        localVolumeInfo.setValue(title, forKey: "title")
        localVolumeInfo.setValue(authors, forKey: "authors")
        localVolumeInfo.setValue(publishedDate, forKey: "publishedDate")
        localVolumeInfo.setValue(description, forKey: "desc")
        localVolumeInfo.setValue(pageCount, forKey: "pageCount")
        localVolumeInfo.setValue(printType, forKey: "printType")
        localVolumeInfo.setValue(maturityRating, forKey: "maturityRating")
        localVolumeInfo.setValue(allowAnonLogging, forKey: "allowAnonLogging")
        localVolumeInfo.setValue(contentVersion, forKey: "contentVersion")
        localVolumeInfo.setValue(language, forKey: "language")
        localVolumeInfo.setValue(previewLink, forKey: "previewLink")
        localVolumeInfo.setValue(infoLink, forKey: "infoLink")
        localVolumeInfo.setValue(canonicalVolumeLink, forKey: "canonicalVolumeLink")
    }
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
    
    init?(from localImageLinks: NSManagedObject) {
        guard let smallThumbnail = localImageLinks.value(forKey: "smallThumbnail") as? String else { return nil }
        guard let thumbnail = localImageLinks.value(forKey: "thumbnail") as? String else { return nil }
        
        self.smallThumbnail = smallThumbnail
        self.thumbnail = thumbnail
        
    }
    
    func mapToLocalImageLinks(into localImageLinks: NSManagedObject) {
        localImageLinks.setValue(smallThumbnail, forKey: "smallThumbnail")
        localImageLinks.setValue(thumbnail, forKey: "thumbnail")
    }
}
