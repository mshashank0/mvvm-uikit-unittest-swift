//
//  PODViewModel.swift
//  AstronomyNasa
//  Handle view logic and call services
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

class PODViewModel: NSObject {
    
    private let podService: PODServiceDelegate
    private let networkManager: NetworkManagerDelegate
    private let persistenceManager: any PersistenceManagerDelegate
    
    var pod: Observable<Pod> = Observable(nil)
    var imageData: Observable<Data> = Observable(nil)
    
    // Injecting dependencies - service, network manager & persstence manager
    init(podService: PODServiceDelegate = PODService(),
         persistenceManager: any PersistenceManagerDelegate = UserDefaultPersistenceManager(),
         networkManager: NetworkManagerDelegate = NetworkManager.shared) {
        self.podService = podService
        self.persistenceManager = persistenceManager
        self.networkManager = networkManager
    }
    
    func getPictureOfDay() {
        // Check for pod model and image data into the local persistence storage
        guard let pod = persistenceManager.getValue(Pod.self, for: EntityKey.pod.rawValue),
              let imageData = persistenceManager.getValue(Data.self, for: EntityKey.imageData.rawValue) else {
           // If not found, get it from API call
           callServiceToGetThePictureOfDay()
           return
        }
        // If found, return objects from the local persistence storage
        self.pod.value = pod
        self.imageData.value = imageData
    }
    
    // Get picture of day object from server
    func callServiceToGetThePictureOfDay() {
        guard networkManager.isConnected() else {
            // TODO: - Show network error to user and add some retry method without relaunching
            return
        }
        podService.getPod { [weak self] result in
            switch result {
            case .success(let value):
                self?.pod.value = value
                // Save Pod object in the local persistence storage
                self?.persistenceManager.saveValue(Pod.self, with: value, for: EntityKey.pod.rawValue)
            case .failure(_): break
                // TODO: - Handle error
            }
        }
    }
    
    // Get image data from server
    func getImageData() {
        guard networkManager.isConnected() else {
            return
        }
        guard let imageUrl = pod.value?.url else {
            return
        }
        podService.getImageData(from: imageUrl) { [weak self] result in
            switch result {
            case .success(let value):
                self?.imageData.value = value
                // Save image data in the local persistence storage
                self?.persistenceManager.saveValue(Data.self, with: value, for: EntityKey.imageData.rawValue)
            case .failure(_):
                // TODO: - Handle error
                break
            }
        }
    }
}
