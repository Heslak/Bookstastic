//
//  BookstasticTests.swift
//  BookstasticTests
//
//  Created by Sergio Acosta on 15/12/23.
//

import XCTest
@testable import Bookstastic

final class BookstasticTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func authorsTest() throws {
        
        let authors = ["Charles Dickens", "James Joyce", "Mary Shelley"]
        let volumeInfo = VolumeInfo(
            title: "Tratado de pilotage (XX, 184, [2] p., II h. pleg., V h. de grab. pleg.)",
            authors: authors,
            publishedDate: nil,
            industryIdentifiers: nil,
            pageCount: nil,
            printType: "",
            maturityRating: "",
            allowAnonLogging: false,
            contentVersion: "",
            panelizationSummary: nil,
            imageLinks: nil,
            language: "",
            previewLink: "",
            infoLink: "",
            canonicalVolumeLink: "")
        
        XCTAssert(volumeInfo.getAuthors() == "Charles Dickens, James Joyce, Mary Shelley")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
