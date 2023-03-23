//
//  AstronomyNasaUITests.swift
//  AstronomyNasaUITests
//
//  Created by Shashank Mishra on 23/03/23.
//

import XCTest

final class AstronomyNasaUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func test_UIElements() throws {
        let app = XCUIApplication()
        app.launch()
        
        let textViewQueries = app.textViews
        XCTAssertTrue(textViewQueries.element.exists, "TextView not found")
        
        let staticTextQueries = app.staticTexts
        XCTAssertTrue(staticTextQueries.element.exists, "Title Label not found")
        
        let imageViewElement = app.windows.children(matching: .other).element
        
        XCTAssertTrue(imageViewElement.exists, "ImageView not found")
    }
}
