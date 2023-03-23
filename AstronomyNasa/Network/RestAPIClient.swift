//
//  RestAPIClient.swift
//  AstronomyNasa
//  Generic request method which uses urlsession datatask to get the result from api
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

// MARK: - NetworkError Enum
enum NetworkError: Error {
   case NoData
   case DecodingError
   case BadURL
}

class RestAPIClient {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // Generic Request
    func request<T: Decodable>(_ type: T.Type, _ request: URLRequest?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let request = request else {
            return completion(.failure(.BadURL))
        }
        urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.NoData))
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            }
            catch {
                completion(.failure(.DecodingError))
            }
        }.resume()
    }
    
    //MARK: - Get picture of the day object
    func getPod(completion: @escaping(Result<Pod, NetworkError>) -> Void) {
        request(Pod.self, APIRouter.pictureOfDay.request, completion: completion)
    }
    
}

// MARK: - Download request
extension RestAPIClient {

    func downloadRequest<T: Decodable>(_ type: T.Type, _ request: URLRequest?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let request = request else {
            return completion(.failure(.BadURL))
        }
        urlSession.dataTask(with: request) { data, response, error in
            guard let data = data as? T, error == nil else {
                return completion(.failure(.NoData))
            }
            completion(.success(data))
        }.resume()
    }
    
    // Download and get image data
    func getImageData(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        let request = APIRouter.imageUrl(url).request
        self.downloadRequest(Data.self, request, completion: completion)
    }
}
