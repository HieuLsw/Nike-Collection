//
//  ProductInfoTableViewCell.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ProductInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var productSpecLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
