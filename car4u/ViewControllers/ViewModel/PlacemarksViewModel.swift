//
//  MapViewModel.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import UIKit
import RxSwift

class PlacemarksViewModel: NSObject {
    // MARK: - Private properties
    private var carList: [CarInfoViewModel] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Public properties
    let annotationsSubject = BehaviorSubject<ApiManager.State>(value: .loading)
    let carInfoSubject = BehaviorSubject<[CarInfoViewModel]>(value: [])
    
    // MARK: - Life-cycle methods
    override init() {
        super.init()
        bindWithDataProvider()
    }
    
    private func bindWithDataProvider() {
        LocationProvider.shared.locationFound
            .subscribeNext { [weak self] in
                self?.getPlacemarks()
            }.disposed(by: disposeBag)
    }
    
    private func prepareViewModels(_ placemarks: [Placemark]) {
        var placemarkList = placemarks
        if LocationProvider.shared.isAuthorized {
            let currentLocation = LocationProvider.shared.currentLocation
            placemarkList = placemarks.sorted(by: { $0.distanceFrom(userLocation: currentLocation) < $1.distanceFrom(userLocation: currentLocation) })
        }
        let annotations = placemarkList.map({
            AnnotationViewModel(vin: $0.vin, name: $0.name, coordinates: $0.location)
        })
        annotationsSubject.onNext(.response(annotations))
        carList = placemarkList.map({
            CarInfoViewModel($0)
        })
        carInfoSubject.onNext(carList)
    }
}

extension PlacemarksViewModel {
    @objc func getPlacemarks() {
        if ApiManager.shared.isConnectedToInternet {
            annotationsSubject.onNext((.loading))
            ApiManager.shared.getPlacemarks()
                .observeOn(MainScheduler.instance)
                .subscribe (
                    onNext: { [weak self] placemarks in
                        self?.prepareViewModels(placemarks)
                    },
                    onError: { [weak self] error in
                        self?.annotationsSubject.onNext((.error))
                })
                .disposed(by: disposeBag)
        } else {
            let placeMarks = DataController.shared.items(Placemark.self)
            if placeMarks.isEmpty {
                annotationsSubject.onNext((.offline))
            } else {
                prepareViewModels(placeMarks)
            }
        }
    }
}

// MARK: - Data Source Methods for List Screen
extension PlacemarksViewModel {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return carList.count
    }
    
    func carInfoViewModel(at indexPath: IndexPath) -> CarInfoViewModel {
        return carList[indexPath.row]
    }
}
