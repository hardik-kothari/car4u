//
//  LocationProvider.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class LocationProvider: NSObject {
    static let shared = LocationProvider()
    private var locationManager = CLLocationManager()
    var locationFound = PublishSubject<Void>()
    var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var isAuthorized: Bool = false
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isAuthorized = false
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isAuthorized = false
            locationFound.onNext(())
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, abs(newLocation.timestamp.timeIntervalSinceNow) <= 1 else {
            return
        }
        currentLocation = newLocation
        locationFound.onNext(())
        locationManager.stopUpdatingLocation()
    }
}
