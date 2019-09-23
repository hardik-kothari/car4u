//
//  ApiManager+Rx.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Alamofire
import RxSwift

typealias Json = [String: Any]

extension DataResponse: Swift.Error {}
extension DefaultDataResponse: Swift.Error {}

extension DataRequest: ReactiveCompatible {}
extension Reactive where Base: DataRequest {
    func json() -> Observable<Json> {
        return Observable.create { o -> Disposable in
            self.base.responseJSON { response in
                if let error = response.error {
                    if let jsonData = response.data {
                        print(String(data: jsonData, encoding: .utf8)!)
                    }
                    o.onError(error)
                } else if let value = response.value as? Json {
                    o.onNext(value)
                    o.onCompleted()
                } else {
                    o.onError(response)
                }
            }
            return Disposables.create {
                self.base.cancel()
            }
        }
    }
    
    func jsonArray() -> Observable<[Json]> {
        return Observable.create { o -> Disposable in
            self.base.responseJSON { response in
                if let value = response.value as? [Json] {
                    o.onNext(value)
                    o.onCompleted()
                } else {
                    o.onError(response)
                }
            }
            return Disposables.create {
                self.base.cancel()
            }
        }
    }
}

extension Observable where Element == DataRequest {
    func mapJson() -> Observable<Json> {
        return self.flatMap { request in
            return request.rx.json()
        }
    }
    
    func mapJsonArray() -> Observable<[Json]> {
        return self.flatMap { request in
            request.rx.jsonArray()
        }
    }
}

// MARK: - ApiManager + Rx
extension ApiManager: ReactiveCompatible {}
extension Reactive where Base: ApiManager {
    func request(_ target: Api) -> Observable<DataRequest> {
        return Observable.just(self.base.request(target))
    }
}

// MARK: - ApiManager + URLSession
extension Reactive where Base: URLSession {
    func response(_ request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable.create { observer  in
            let task = self.base.dataTask(with: request) { (data, response, error)  in
                guard let response = response, let data = data else {
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                observer.on(.next((httpResponse, data)))
                observer.on(.completed)
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
