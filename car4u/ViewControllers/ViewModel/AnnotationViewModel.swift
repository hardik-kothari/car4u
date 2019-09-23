//
//  AnnotationViewModel.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation
import MapKit

class AnnotationViewModel: NSObject, MKAnnotation {
    let vin: String
    let name: String
    let coordinates:CLLocationCoordinate2D
    
    var title: String? {
        return name
    }
    
    override var description: String {
        return vin
    }
    
    var coordinate: CLLocationCoordinate2D {
        return coordinates
    }
    
    init(vin: String, name: String, coordinates: CLLocationCoordinate2D) {
        self.vin = vin
        self.name = name
        self.coordinates = coordinates
    }
}
