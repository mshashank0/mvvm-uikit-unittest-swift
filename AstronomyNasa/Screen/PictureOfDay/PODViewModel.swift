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
    
    var pod: Observable<Pod> = Observable(nil)
    var imageData: Observable<Data> = Observable(nil)
    
    // Injecting service dependency
    init(podService: PODServiceDelegate = PODService(),
         networkManager: NetworkManagerDelegate = NetworkManager.shared) {
        self.podService = podService
        self.networkManager = networkManager
    }
    
    func getPictureOfDay() {
        // Check internet connectivity
        guard networkManager.isConnected() else {
            // TODO: - Handle error
            return
        }
        // Get pod model
        podService.getPod { [weak self] result in
            switch result {
            case .success(let value):
                self?.pod.value = value
            case .failure(_): break
                //TO DO :- Handle error
            }
        }
    }
    
    // Get image data from pod service
    func getImageData() {
        // Check internet connectivity
        guard networkManager.isConnected() else {
            // TODO: - Handle error
            return
        }
        // Check if url is available
        guard let imageUrl = pod.value?.url else {
            return
        }
        // Get image data
        podService.getImageData(from: imageUrl) { [weak self] result in
            switch result {
            case .success(let value):
                self?.imageData.value = value
            case .failure(_):
                // TODO: - Handle error
                break
            }
        }
    }
}
