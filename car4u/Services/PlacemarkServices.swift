//
//  PlacemarkServices.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import Foundation
import RxSwift

extension ApiManager {
    func getPlacemarks() -> Observable<[Placemark]> {
        return self
            .rx
            .request(Api.placemarks)
            .mapJson()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ json in
                DataController.shared.savePlacemarks(json: json)
            })
            .observeOn(MainScheduler.instance)
    }
}
