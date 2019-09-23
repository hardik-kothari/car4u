//
//  Api.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Api target type
protocol Target {
    var baseUrl: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

extension Target {
    var url: URL {
        return URL(string: baseUrl)!.appendingPathComponent(path)
    }
}

enum Api {
    case placemarks
}

extension Api: Target {
    
    var baseUrl: String {
        return "https://s3-us-west-2.amazonaws.com"
    }
    
    var path: String {
        switch self {
        case .placemarks:
            return "/wunderbucket/locations.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .placemarks:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var headers: [String: String]? {
        return nil
    }
}
