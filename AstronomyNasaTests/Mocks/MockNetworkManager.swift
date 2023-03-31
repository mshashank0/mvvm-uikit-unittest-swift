//
//  MockNetworkManager.swift
//  AstronomyNasaTests
//  Mocking NetworkManager
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation
import XCTest

@testable import AstronomyNasa

class MockNetworkManager: NetworkManagerDelegate {
    
    var mockConnectionValue = false
    
    init(mockConnectionValue: Bool) {
        self.mockConnectionValue = mockConnectionValue
    }

    // Get connection is satisfied on not
    func isConnected() -> Bool {
        return mockConnectionValue
    }
}
