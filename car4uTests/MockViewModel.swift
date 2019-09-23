//
//  MockViewModel.swift
//  car4uTests
//
//  Created by Hardik Kothari on 23/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import XCTest
import CoreLocation
@testable import car4u

class MockViewModel: PlacemarksViewModel {

    var apiState: ApiManager.State = .loading
    
    let fakeAnnotations = [
        AnnotationViewModel(vin: "WME4513341K565439", name: "HH-GO8522", coordinates: CLLocationCoordinate2D(latitude: 10.07526, longitude: 53.59301)),
        AnnotationViewModel(vin: "WME4513341K412697", name: "HH-GO8480", coordinates: CLLocationCoordinate2D(latitude: 10.07526, longitude: 53.59301)),
        AnnotationViewModel(vin: "WME4513341K412709", name: "HH-GO8001", coordinates: CLLocationCoordinate2D(latitude: 10.07526, longitude: 53.59301))
    ]
    
    override func getPlacemarks() {
        annotationsSubject.onNext(apiState)
    }
}
