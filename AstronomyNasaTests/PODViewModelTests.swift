//
//  PODViewModelTests.swift
//  AstronomyNasaTests
//  Test cases for view model methods
//  Created by Shashank Mishra on 23/03/23.
//

import XCTest
@testable import AstronomyNasa

final class PODViewModelTests: XCTestCase {
    
    var viewModel: PODViewModel?
        
    var mockNetworkManager = MockNetworkManager(mockConnectionValue: true)
    var persistenceManager = UserDefaultPersistenceManager()
    
    override func setUpWithError() throws {
        
        // Initialize view model with mocked service client to avoid actual network hit
        viewModel = PODViewModel(podService: MockPODService(),
                                 persistenceManager: persistenceManager,
                                 networkManager: mockNetworkManager)
    }
    
    func test_ValidPodObjectWithInternet() throws {
        let pod = getPodObject(viewModel: viewModel!)
        XCTAssertTrue(pod != nil)
    }
    
    func test_ValidImageDataWithInternet() throws {
        viewModel?.pod.value = Pod(copyright: "", date: "", explanation: "", hdurl: "", mediaType: "", serviceVersion: "", title: "", url: "https://apod.nasa.gov/apod/image/2303/NGC2841_1024.jpg")
        XCTAssertNotNil(viewModel?.pod.value?.url)
        let imageData = getImageData(viewModel: viewModel!)
        XCTAssertTrue(imageData != nil)
    }
    
    func test_ValidSavedImageAndPodDataWhenCurrentDateIsSameAsPodObjectDate() {
        viewModel?.getPictureOfDay()
        viewModel?.getImageData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        let date = dateFormatter.date(from: "2023-02-07")
        viewModel?.currentDate = date!
        sleep(UInt32(0.5))
        viewModel?.getPictureOfDay()
        let pod = persistenceManager.getValue(Pod.self, for: EntityKey.pod.rawValue)
        let imageData = persistenceManager.getValue(Data.self, for: EntityKey.imageData.rawValue)
        XCTAssertNotNil(pod != nil && imageData != nil)
    }
    
    override func tearDownWithError() throws {
        self.persistenceManager.removeValue(entityKey: EntityKey.pod.rawValue)
        self.persistenceManager.removeValue(entityKey: EntityKey.imageData.rawValue)
        viewModel = nil
    }

    // MARK: Get mocked Picture of day(pod) object
    func getPodObject(viewModel: PODViewModel) -> Pod? {
        viewModel.getPictureOfDay()
        sleep(UInt32(0.5))
        let pod = persistenceManager.getValue(Pod.self, for: EntityKey.pod.rawValue)
        return pod
    }
    
    // MARK: Get mocked image data
    func getImageData(viewModel: PODViewModel) -> Data? {
        viewModel.pod.value = Pod(copyright: "", date: "", explanation: "", hdurl: "", mediaType: "", serviceVersion: "", title: "", url: "https://apod.nasa.gov/apod/image/2303/NGC2841_1024.jpg")
        viewModel.getImageData()
        sleep(UInt32(0.5))
        let imageData = persistenceManager.getValue(Data.self, for: EntityKey.imageData.rawValue)
        return imageData
    }
}
