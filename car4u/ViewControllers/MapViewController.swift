//
//  MapViewController.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import MapKit
import RxSwift

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private properties
    private var loadingMapForFirstTime: Bool = true
    private let disposeBag = DisposeBag()
    
    var viewModel: PlacemarksViewModel!
    
    // MARK: - Life-cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pulleyViewController?.setDrawerPosition(position: .closed, animated: false)
    }
    
    private func configureView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        locationButton.applyBoxShadow(color: UIColor(hexString: "#9e9e9e"), alpha: 0.5, x: 0, y: 9, blur: 17)
    }
    
    // MARK: - Action methods
    @IBAction func locationButtonAction(_ sender: UIButton) {
        let currentLocation = mapView.userLocation.coordinate
        zoomMapTo(location: currentLocation)
    }
    
    func selectCarOnMapFor(_ vin: String) {
        guard let annotationToSelect = mapView.annotations.first(where: { $0.description == vin }) as? AnnotationViewModel else {
            return
        }
        mapView.selectAnnotation(annotationToSelect, animated: true)
        zoomMapTo(location: annotationToSelect.coordinate)
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    // MARK: - Data methods
    private func bindView() {
        viewModel.annotationsSubject
            .subscribeNext { [weak self] state in
                self?.handlePlacemarkResponse(state)
            }.disposed(by: disposeBag)
    }
    
    private func handlePlacemarkResponse(_ response: ApiManager.State) {
        switch response {
        case .loading:
            mapView.removeAnnotations(mapView.annotations)
            view.show(.loading)
        case .error:
            mapView.removeAnnotations(mapView.annotations)
            view.show(.error(message: "Something went wrong. Please try again after sometime.", tryAgain: { [weak self] in
                self?.viewModel.getPlacemarks()
            }))
        case .offline:
            view.show(.error(message: "Please check your internet connection and try again later.", tryAgain: { [weak self] in
                self?.viewModel.getPlacemarks()
            }))
        case .response(let response):
            view.show(.none)
            guard let annotations = response as? [AnnotationViewModel] else {
                return
            }
            loadPlacemarksOnMap(annotations)
        }
    }
    
    private func loadPlacemarksOnMap(_ annotations: [AnnotationViewModel]) {
        if !annotations.isEmpty {
            zoomMapTo(location: annotations[0].coordinate)
        }
        mapView.addAnnotations(annotations)
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    private func zoomMapTo(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - MKMapView delegate methods
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotionView") as? AnnotionView
        if annotationView == nil {
            annotationView = AnnotionView(annotation: annotation, reuseIdentifier: "AnnotionView")
        }
        annotationView?.annotation = annotation
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? AnnotationViewModel, !annotation.isKind(of: MKUserLocation.self) else {
            return
        }
    }
}

// MARK: - Pulley Primary Content Controller Delegate
extension MapViewController: PulleyPrimaryContentControllerDelegate {
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        if distance <= drawer.partialRevealDrawerHeight(bottomSafeArea: bottomSafeArea) {
            locationButtonBottomConstraint.constant = distance - bottomSafeArea + 15.0
        } else {
            locationButtonBottomConstraint.constant = kPulleyDefaultPartialRevealHeight + 15.0
        }
    }
}

extension MapViewController {
    static func storyboardInstance(_ viewModel: PlacemarksViewModel) -> MapViewController {
        let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController")
            as! MapViewController
        mapViewController.viewModel = viewModel
        return mapViewController
    }
}
