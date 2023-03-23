//
//  PODModel.swift
//  AstronomyNasa
//  Picture of the day model getting from server which is conforming to Codable protocol for later use
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

// MARK: - Pod
struct Pod: Codable {
    let copyright, date, explanation: String
    let hdurl: String
    let mediaType, serviceVersion, title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
