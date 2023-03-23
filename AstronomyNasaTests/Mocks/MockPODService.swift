//
//  MockPODService.swift
//  AstronomyNasaTests
//  Mocking PODService
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation
import XCTest

@testable import AstronomyNasa

class MockPODService: PODServiceDelegate {
    var apiClient: RestAPIClient = MockAPIClient()
     
    func getPod(completion: @escaping (Result<Pod, NetworkError>) -> Void) {
        apiClient.getPod(completion: completion)
    }
    
    func getImageData(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        apiClient.getImageData(from: url, completion: completion)
    }
}
