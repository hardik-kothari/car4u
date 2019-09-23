//
//  CarInfoCell.swift
//  car4u
//
//  Created by Hardik Kothari on 22/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import UIKit

class CarInfoCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var interiorLabel: UILabel!
    @IBOutlet weak var exteriorLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(viewModel: CarInfoViewModel) {
        nameLabel.text = viewModel.name
        distanceView.isHidden = !LocationProvider.shared.isAuthorized
        distanceLabel.text = viewModel.distance
        
        interiorLabel.text = viewModel.interior
        exteriorLabel.text = viewModel.exterior
        fuelLabel.text = viewModel.fuel
        addressLabel.text = viewModel.address
    }
}
