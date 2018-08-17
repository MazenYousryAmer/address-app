//
//  DetailsTableViewCell.swift
//  Address App
//
//  Created by Mazen on 8/16/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    //MARK: - iboutlet
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var lblAddressDesciption : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
