//
//  PODServiceTests.swift
//  AstronomyNasaTests
//
//  Created by Shashank Mishra on 23/03/23.
//

import XCTest
@testable import AstronomyNasa

final class PODServiceTests: XCTestCase {
    
    var urlSession: URLSession!
    var apiClient: RestAPIClient!
    
    override func setUpWithError() throws {
        
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        
        // Create API client. Injected with custom url session for mocking
        apiClient = RestAPIClient(urlSession: urlSession)
    }
    
    func testGetPod() throws {
        
        // Set mock pod data
        guard let data = Helper.readLocalFile("MockPodResponse", with: "json") else {
            XCTFail("No local data found")
            return
        }
        // Return pod data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let expectation = XCTestExpectation(description: "pod response")
        
        // Make mock network request to get pod
        PODService(apiClient: apiClient).getPod { result in
            switch result {
            case .success(let pod):
                XCTAssertNotNil(pod)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetImageData() throws {
       
        // Set mock image data
        guard let data = Helper.readLocalFile("NGC2841_1024", with: "jpg") else {
            XCTFail("No local data found")
            return
        }
        // Return image data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let expectation = XCTestExpectation(description: "image data response")
        
        guard let fileUrl = Bundle.main.url(forResource: "NGC2841_1024", withExtension: "jpg")?.absoluteString else {
            XCTFail("No mocked image found")
            return
        }
        
        // Make mock network request to get imagedata
        PODService(apiClient: apiClient).getImageData(from: fileUrl) { result in
            switch result {
            case .success(let imageData):
                XCTAssertNotNil(imageData)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
