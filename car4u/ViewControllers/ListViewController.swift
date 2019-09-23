//
//  ListViewController.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var heaerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    var viewModel: PlacemarksViewModel!

    // MARK: - Life-cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindView()
    }
    
    private func configureView() {
        titleLabel.text = "Nearby cars"
        tableView.register(UINib(nibName: "CarInfoCell", bundle: nil), forCellReuseIdentifier: "CarInfoCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.tableFooterView = UIView()
    }
    
    private func bindView() {
        viewModel.carInfoSubject
            .subscribeNext { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Action methods
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
}

// MARK: - UITableView datasource methods
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let carInfoCell = tableView.dequeueReusableCell(withIdentifier: "CarInfoCell") as? CarInfoCell else {
            return UITableViewCell()
        }
        let carInfo = viewModel.carInfoViewModel(at: indexPath)
        carInfoCell.configure(viewModel: carInfo)
        return carInfoCell
    }
}

// MARK: - UITableView delegate methods
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let mapViewController = self?.pulleyViewController?.primaryContentViewController as? MapViewController, let vin = self?.viewModel.carInfoViewModel(at: indexPath).vin else {
                return
            }
            mapViewController.selectCarOnMapFor(vin)
        }
    }
}

// MARK: - PulleyDrawerViewController delegate methods
extension ListViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return kPulleyDefaultCollapsedHeight + bottomSafeArea
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return kPulleyDefaultPartialRevealHeight + bottomSafeArea
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        if drawer.drawerPosition == .collapsed {
            headerViewHeightConstraint.constant = kPulleyDefaultCollapsedHeight + bottomSafeArea
        } else {
            headerViewHeightConstraint.constant = kPulleyDefaultCollapsedHeight + (drawer.drawerPosition == .open ? 16.0 : 0.0)
        }
        let titleFontSize: CGFloat = drawer.drawerPosition == .open ? 34.0 : 20.0
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        tableView.isScrollEnabled = drawer.drawerPosition == .open
    }
    
    func makeUIAdjustmentsForFullscreen(progress: CGFloat, bottomSafeArea: CGFloat) {
        guard let drawer = self.pulleyViewController, drawer.currentDisplayMode == .drawer else {
            closeButton.alpha = 1.0
            return
        }
        closeButton.alpha = progress
    }
}

extension ListViewController {
    static func storyboardInstance(_ viewModel: PlacemarksViewModel) -> ListViewController {
        let listViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListViewController")
            as! ListViewController
        listViewController.viewModel = viewModel
        return listViewController
    }
}
