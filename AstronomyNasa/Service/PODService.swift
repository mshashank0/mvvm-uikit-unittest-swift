//
//  PODService.swift
//  AstronomyNasa
//
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

protocol PODServiceDelegate {
    var apiClient: RestAPIClient {get set}
    func getPod(completion: @escaping(Result<Pod, NetworkError>) -> Void)
}

class PODService: PODServiceDelegate {

    var apiClient: RestAPIClient
    
    init(apiClient: RestAPIClient = RestAPIClient()) {
        self.apiClient = apiClient
    }
        
    func getPod(completion: @escaping (Result<Pod, NetworkError>) -> Void) {
        apiClient.getPod(completion: completion)
    }
}
