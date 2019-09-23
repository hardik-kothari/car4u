//
//  PlacemarksViewModelTests.swift
//  car4uTests
//
//  Created by Hardik Kothari on 24/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import XCTest
import RxSwift
@testable import car4u

class PlacemarksViewModelTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPlacemarksSuccess() {
        let services = MockPlacemarkServices()
        services.testResultSuccess = true
        let viewModel = PlacemarksViewModel(service: services)
        viewModel.getPlacemarks()
        
        let expectPlacemarksReceived = expectation(description: "Placemarks received")
        
        viewModel.annotationsSubject
            .subscribeNext { state in
                switch state {
                case .response(let placemarks):
                    if let places = placemarks as? [Placemark] {
                        XCTAssertTrue(!places.isEmpty)
                    }
                default:
                    XCTAssertTrue(false)
                    break
                }
                expectPlacemarksReceived.fulfill()
            }.disposed(by: disposeBag)
        wait(for: [expectPlacemarksReceived], timeout: 0.1)
    }
    
    func testGetPlacemarksFail() {
        let services = MockPlacemarkServices()
        services.testResultSuccess = false
        let viewModel = PlacemarksViewModel(service: services)
        viewModel.getPlacemarks()
        
        let expectPlacemarksNotFound = expectation(description: "Placemarks not found")
        
        viewModel.annotationsSubject
            .subscribeNext { state in
                switch state {
                case .loading, .response:
                    XCTAssertTrue(false)
                default:
                    XCTAssertTrue(true)
                    break
                }
                expectPlacemarksNotFound.fulfill()
            }.disposed(by: disposeBag)
        wait(for: [expectPlacemarksNotFound], timeout: 0.1)
    }
}
