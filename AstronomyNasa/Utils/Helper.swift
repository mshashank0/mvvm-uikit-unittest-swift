//
//  Helper.swift
//  AstronomyNasa
//
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

enum DateFormat: String {
    case yyyyMMdd = "yyyy-MM-dd"
}

extension String {
    func isSameAs(date: Date = Date()) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        let today = dateFormatter.string(from: date)
        return today == self
    }
}
