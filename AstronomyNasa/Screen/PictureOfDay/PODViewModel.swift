//
//  PODViewModel.swift
//  AstronomyNasa
//  Handle view logic and call services
//  Created by Shashank Mishra on 23/03/23.
//

import Foundation

class PODViewModel: NSObject {
    
    private let podService: PODServiceDelegate
    
    var pod: Observable<Pod> = Observable(nil)
    var imageData: Observable<Data> = Observable(nil)
    
    // Injecting service dependency
    init(podService: PODServiceDelegate = PODService()) {
        self.podService = podService
    }
    
    func getPictureOfDay() {
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
        guard let imageUrl = pod.value?.url else {
            return
        }
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
