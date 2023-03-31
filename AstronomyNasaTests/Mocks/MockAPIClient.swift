//
//  MockAPIClient.swift
//  AstronomyNasaTests
//  Mocking APIClient
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation
import XCTest

@testable import AstronomyNasa

class MockAPIClient: RestAPIClient {
   
    override func request<T: Decodable>(_ type: T.Type, _ request: URLRequest?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let data = Helper.readLocalFile("MockPodResponse", with: "json") else {
            return
        }
        let decodedData = try! JSONDecoder().decode(T.self, from: data)
        completion(.success(decodedData))
    }
    
    //MARK: - Get picture of the day object
    override func getPod(completion: @escaping(Result<Pod, NetworkError>) -> Void) {
        request(Pod.self, URLRequest(url: URL(fileURLWithPath: "")), completion: completion)
    }
    
    override func downloadRequest<T: Decodable>(_ type: T.Type, _ request: URLRequest?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let _ = request else {
            return completion(.failure(.BadURL))
        }
        guard let data = Helper.readLocalFile("NGC2841_1024", with: "jpg") else {
            return
        }
        guard let data = data as? T else {
            return completion(.failure(.NoData))
        }
        completion(.success(data))
    }
    
    // Download and get image data
    override func getImageData(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        let request = APIRouter.imageUrl(url).request
        self.downloadRequest(Data.self, request, completion: completion)
    }
}
