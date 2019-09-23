//
//  MapViewControllerTests.swift
//  car4uTests
//
//  Created by Hardik Kothari on 23/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import XCTest
import RxSwift
import RxNimble
import Nimble
@testable import car4u

class MapViewControllerTests: XCTestCase {

    var viewController: MapViewController!
    let viewModel = MockViewModel()
    override func setUp() {
        super.setUp()
        viewController = MapViewController.storyboardInstance(viewModel)
    }

    override func tearDown() {
    }

    func testLoadingCase() {
        viewModel.apiState = .loading
        viewController.viewModel.getPlacemarks()
        expect(self.viewController.mapView.annotations.isEmpty) == true
    }
    
    func testSuccessCase() {
        viewModel.apiState = .response((viewModel.fakeAnnotations))
        viewController.viewModel.getPlacemarks()
        expect(self.viewController.mapView.annotations.isEmpty) == false
        
        guard let firstAnnotation = self.viewController.mapView.annotations.first as? AnnotationViewModel else {
            return
        }
        expect(firstAnnotation.name) == viewModel.fakeAnnotations[0].name
        expect(self.viewController.mapView.annotations.count) == viewModel.fakeAnnotations.count
    }
    
    func testErrorCase() {
        viewModel.apiState = .error
        viewController.viewModel.getPlacemarks()
        expect(self.viewController.mapView.annotations.isEmpty) == true
    }
}
