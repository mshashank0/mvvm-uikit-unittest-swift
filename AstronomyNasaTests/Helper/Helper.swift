//
//  Helper.swift
//  AstronomyNasaTests
//
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

class Helper {
    static func readLocalFile(_ name: String, with ext: String) -> Data? {
        guard let fileUrl = Bundle.main.url(forResource: name, withExtension: ext) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            return data
        }
        catch {
            return nil
        }
    }
}
