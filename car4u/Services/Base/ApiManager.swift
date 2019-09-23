//
//  ApiManager.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Alamofire

class ApiManager {
    static let shared = ApiManager(session: SessionManager.default)
    
    private let session: SessionManager
    
    private init(session: SessionManager) {
        self.session = session
    }
    
    var isConnectedToInternet: Bool {
        guard let isReachable = NetworkReachabilityManager()?.isReachable, isReachable == true else {
            return false
        }
        return isReachable
    }
    
    func request(_ target: Target) -> DataRequest {
        let headers = target.headers ?? [:]
        return session
            .request(target.url, method: target.httpMethod, parameters: target.parameters,
                     encoding: target.parameterEncoding, headers: headers)
    }
}

extension ApiManager {
    enum State: Comparable {
        case loading
        case error
        case offline
        case response(_ response: Any?)
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.error, .error):
                return true
            case (.offline, .offline):
                return true
            default:
                return false
            }
        }
        
        static func < (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.error, .error):
                return true
            case (.offline, .offline):
                return true
            default:
                return false
            }
        }
    }
}
