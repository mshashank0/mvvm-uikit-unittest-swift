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
        guard let data = Helper.readLocalPictureOfDay() else {
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
}
