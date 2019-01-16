//
//  BeverageTableViewCell.swift
//  BruRestaurant
//
//  Created by Simon Mc Neil on 2018-11-22.
//  Copyright © 2018 Simon Mc Neil. All rights reserved.
//

import UIKit

class BeverageTableViewCell: UITableViewCell {

    @IBOutlet weak var beverageImage: UIImageView!
    @IBOutlet weak var beverageTitle: UILabel!
    @IBOutlet weak var beverageDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
