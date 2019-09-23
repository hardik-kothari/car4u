//
//  Placemark.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Placemark: NSManagedObject {
    var location: CLLocationCoordinate2D {
        get {
            if !coordinates.isEmpty {
                return CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
            } else {
                return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            }
        }
    }
    
    func distanceFrom(userLocation: CLLocation) -> Double {
        let carLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return carLocation.distance(from: userLocation)
    }
}

extension Placemark {
    class func fetchRequest() -> NSFetchRequest<Placemark> {
        return NSFetchRequest<Placemark>(entityName: "Placemark")
    }

    @NSManaged var address: String
    @NSManaged private var coordinates: [Double]
    @NSManaged var engineType: String
    @NSManaged var exterior: String
    @NSManaged var fuel: Int32
    @NSManaged var interior: String
    @NSManaged var name: String
    @NSManaged var vin: String
}

extension Placemark {
    enum Keys: String, CodingKey {
        case address
        case coordinates
        case engineType
        case exterior
        case fuel
        case interior
        case name
        case vin
    }

    func update(_ json: Json) {
        address = json[Keys.address] ?? ""
        coordinates = json[Keys.coordinates] ?? []
        engineType = json[Keys.engineType] ?? ""
        exterior = json[Keys.exterior] ?? ""
        fuel = json[Keys.fuel] ?? 0
        interior = json[Keys.interior] ?? ""
        name = json[Keys.name] ?? ""
        vin = json[Keys.vin] ?? ""
    }
}
