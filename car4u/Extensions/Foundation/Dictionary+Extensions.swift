//
//  Dictionary+Extensions.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    subscript<T>(_ key: CodingKey) -> T? {
        return self[key.stringValue] as? T
    }
    
    subscript(_ key: CodingKey) -> Any? {
        return self[key.stringValue]
    }
}
