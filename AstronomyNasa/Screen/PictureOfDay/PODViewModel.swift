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
    var isOldPicture: Observable<Bool> = Observable(false)
    
    var isSameDate: Bool = false
    var currentDate: Date = Date()
    
    // Injecting dependencies - service, network manager & persstence manager
    init(podService: PODServiceDelegate = PODService(),
         persistenceManager: any PersistenceManagerDelegate = UserDefaultPersistenceManager(),
         networkManager: NetworkManagerDelegate = NetworkManager.shared) {
        self.podService = podService
        self.persistenceManager = persistenceManager
        self.networkManager = networkManager
    }
    
    // MARK: - Get picture of day
    /*
     1. Check for pod model and image data into the local persistence storage
     2. If not found call api
     3. Check if date stored in local store is same as today's date or internet is not connected then show saved picture from store
     4. If date is not same and internet is connected, then call api
     5. Set observables' value
     */
    func getPictureOfDay() {
        // #1
        guard let pod = persistenceManager.getValue(Pod.self, for: EntityKey.pod.rawValue),
              let imageData = persistenceManager.getValue(Data.self, for: EntityKey.imageData.rawValue) else {
           // #2
           callServiceToGetThePictureOfDay()
           return
        }
        
        // Compare current date with pod date
        isDateSameAs(podDate: pod.date, currentDate: currentDate)
        
        // #3
        guard isSameDate ||
            !networkManager.isConnected() else {
            // #4
            callServiceToGetThePictureOfDay()
            return
        }
        
        // #5
        self.pod.value = pod
        self.imageData.value = imageData
        isOldPicture.value = !isSameDate
    }
    
    func isDateSameAs(podDate: String, currentDate: Date) {
        isSameDate = podDate.isSameAs(date: currentDate)
    }
    
    // MARK: Get picture of day object from service
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
    
    // MARK: Get image data from service
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
