//
//  ObservableType+Extensions.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import RxSwift

extension ObservableType {
    func subscribeNext(_ onNext: @escaping ((Self.Element) -> Void)) -> Disposable {
        return subscribe(onNext: onNext)
    }
    
    func subscribeError(_ onError: @escaping ((Error) -> Void)) -> Disposable {
        return subscribe(onError: onError)
    }
    
    func subscribeCompleted(_ onCompleted: @escaping (() -> Void)) -> Disposable {
        return subscribe(onCompleted: onCompleted)
    }
    
    func subscribeDisposed(_ onDisposed: @escaping (() -> Void)) -> Disposable {
        return subscribe(onDisposed: onDisposed)
    }
    
    func doNext(_ onNext: @escaping ((Self.Element) -> Void)) -> Observable<Self.Element> {
        return self.do(onNext: onNext)
    }
}
