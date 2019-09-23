//
//  MockApiManager.swift
//  car4uTests
//
//  Created by Hardik Kothari on 23/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import XCTest
import RxSwift
@testable import car4u

enum GetPlacemarkFailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}

class MockPlacemarkServices: PlacemarkServices {
    var testResultSuccess: Bool = true
    
    override func getPlacemarks() -> Observable<[Placemark]> {
        return Observable.create { observer in
            if self.testResultSuccess {
                observer.onNext(self.readLocationJson())
            } else {
                observer.onError(GetPlacemarkFailureReason.unAuthorized)
            }
            return Disposables.create()
        }
    }
    
    private func readLocationJson() -> [Placemark] {
        if let path = Bundle(for: type(of: self)).path(forResource: "locations", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let json = jsonResult as? Json, let places = json["placemarks"] as? [Json] {
                    var placemarks: [Placemark] = []
                    for item in places {
                        let placemark = Placemark(context: DataController.shared.viewContext)
                        placemark.update(item)
                        placemarks.append(placemark)
                    }
                    return placemarks
                }
            } catch { return [] }
        }
        return []
    }
}
