//
//  CarInfoViewModel.swift
//  car4u
//
//  Created by Hardik Kothari on 22/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation

class CarInfoViewModel: NSObject {
    let address: String
    let engineType: String
    let exterior: String
    let fuel: String
    let interior: String
    let name: String
    let vin: String
    let distance: String
    
    init(_ placemark: Placemark) {
        self.address = placemark.address
        self.engineType = placemark.engineType
        self.exterior = placemark.exterior
        self.fuel = "\(placemark.fuel)%"
        self.interior = placemark.interior
        self.name = placemark.name
        self.vin = placemark.vin
        if LocationProvider.shared.isAuthorized {
            self.distance = String(format: "%.1f km", placemark.distanceFrom(userLocation: LocationProvider.shared.currentLocation) / 1000.0)
        } else {
            self.distance = "--"
        }
    }
}
