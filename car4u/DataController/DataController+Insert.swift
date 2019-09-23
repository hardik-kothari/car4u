//
//  DataController+Insert.swift
//  car4u
//
//  Created by Hardik Kothari on 23/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation
import CoreData

extension DataController {
    func savePlacemarks(json: Json) -> [Placemark] {
        var error: Error?
        viewContext.performAndWait {
            self.items(Placemark.self).forEach {
                viewContext.delete($0)
            }
            let items = json["placemarks"] as? [Json]
            items?.forEach { json in
                let place = Placemark(context: viewContext)
                place.update(json)
            }
            do {
                try viewContext.save()
            } catch (let err) {
                error = err
            }
        }
        return error == nil ? self.items(Placemark.self) : []
    }
}
