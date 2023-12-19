//
//  Book.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation

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
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo?
    
    enum CodingKeys: String, CodingKey {
        case kind, etag, selfLink, volumeInfo, saleInfo, accessInfo, searchInfo
        case identifier = "id"
    }
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let industryIdentifiers: [IndustryIdentifiers]?
    let pageCount: Int?
    let printType: String
    let maturityRating: String
    let allowAnonLogging: Bool
    let contentVersion: String
    let panelizationSummary: PanelizationSummary?
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
        } ?? ""
    }
}

struct IndustryIdentifiers: Decodable {
    let type: String
    let identifier: String
}

struct ReadingModes: Decodable {
    let text: Bool
    let images: Bool
}

struct PanelizationSummary: Decodable {
    let containsEpubBubbles: Bool
    let containsImageBubbles: Bool
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}

struct SaleInfo: Decodable {
    let country: String
    let saleability: String
    let isEbook: Bool
    let buyLink: String?
}

struct AccessInfo: Decodable {
    let country: String
    let viewability: String
    let embeddable: Bool
    let publicDomain: Bool
    let textToSpeechPermission: String
    let epub: Epub
    let webReaderLink: String
    let accessViewStatus: String
    let quoteSharingAllowed: Bool
}

struct Epub: Decodable {
    let isAvailable: Bool
    let downloadLink: String?
}

struct Pdf: Decodable {
    let isAvailable: Bool
    let downloadLink: String
}

struct SearchInfo: Decodable {
    let textSnippet: String
}
