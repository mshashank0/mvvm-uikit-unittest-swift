//
//  APIRouter.swift
//  AstronomyNasa
//  Enum to provide URLRequest object after decorating with different attributes based on case
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

// TODO: - Improvement - Move it to configuration file and add it to .gitignore file
let baseUrl = "https://api.nasa.gov"

// TODO: - Improvement - Move it to configuration file and add it to .gitignore file
let pocKey = "dGCtgaTDSgoYtYqNQrwGYkHaOD0yMrNMqiaB5jHW"

enum Method: String {
    case get = "GET"
}

// MARK: - APIRouter
enum APIRouter {
    
    case pictureOfDay
    
    private var urlPath :String {
        switch self {
        case .pictureOfDay:
            return "\(baseUrl)/planetary/apod?api_key=\(pocKey)"
        }
    }
    
    private var method: Method {
        switch self {
        case .pictureOfDay:
            return .get
        }
    }
    
    var request: URLRequest? {
        guard let url = URL(string: urlPath) else {
            return nil
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
}
