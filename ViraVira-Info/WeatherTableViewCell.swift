//
//  WeatherTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

	@IBOutlet weak var collectionView: WeatherCollectionView!
	@IBOutlet weak var dayTag: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
