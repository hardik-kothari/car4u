//
//  DataController+Fetch.swift
//  car4u
//
//  Created by Hardik Kothari on 23/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation
import CoreData

extension DataController {
    func items<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, offset: Int = 0) -> [T] {
        let context = viewContext
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchOffset = offset
        if let n = limit {
            fetchRequest.fetchLimit = n
        }
        do {
            let items = try context.fetch(fetchRequest)
            if let items = items as? [T] {
                return items
            } else {
                return []
            }
        } catch {
            return []
        }
    }
}
