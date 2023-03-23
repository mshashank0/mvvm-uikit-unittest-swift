//
//  PersistenceManager.swift
//  AstronomyNasa
//  Persistent manage with Userdefault as concrete implementation
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

enum EntityKey: String {
    case pod = "com.walm.pod"
    case imageData = "com.walm.imageData"
}

protocol PersistenceManagerDelegate {
    associatedtype ObjectType
    func saveValue<ObjectType: Encodable>(_ type: ObjectType.Type, with value: ObjectType, for entityKey: String)
    func getValue<ObjectType: Decodable>(_ type: ObjectType.Type, for entityKey: String) -> ObjectType?
    func removeValue(entityKey: String)
}

class UserDefaultPersistenceManager: PersistenceManagerDelegate {
    
    typealias ObjectType = Any
    
    var store = UserDefaults.standard

    func saveValue<T: Encodable>(_ type: T.Type, with value: T, for entityKey: String) {
        do {
            // Encode object
            let data = try JSONEncoder().encode(value)

            // Write/Set Data
            store.set(data, forKey: entityKey)
        } catch {
            print("Unable to Encode Pod - (\(error))")
        }
    }
    
    func getValue<T: Decodable>(_ type: T.Type, for entityKey: String) -> T? {
        guard let data = store.data(forKey: entityKey) else {
            return nil
        }
        do {
            // Decoded object
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            return nil
        }
    }
    
    func removeValue(entityKey: String) {
        store.removeObject(forKey: entityKey)
    }
}
