//
//  MockPlacemark.swift
//  car4uTests
//
//  Created by Hardik Kothari on 23/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import XCTest
@testable import car4u

class PlacemarkTests: XCTestCase {
    
    func testSuccessfulInit() {
        let testSuccessfulJSON: Json = [
            "address": "Lesserstraße 170, 22049 Hamburg",
            "coordinates": [
                10.07526,
                53.59301,
                0
            ],
            "engineType": "CE",
            "exterior": "UNACCEPTABLE",
            "fuel": 42,
            "interior": "UNACCEPTABLE",
            "name": "HH-GO8522",
            "vin": "WME4513341K565439"
        ]
        
        let place = Placemark(context: DataController.shared.viewContext)
        place.update(testSuccessfulJSON)
        
        XCTAssert(!place.name.isEmpty)
        XCTAssert(!place.vin.isEmpty)
        XCTAssert(!place.address.isEmpty)
        XCTAssertNotNil(place.location)
    }
}
