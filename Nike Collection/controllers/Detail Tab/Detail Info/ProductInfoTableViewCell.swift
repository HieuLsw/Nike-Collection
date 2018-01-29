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
    
    var productInfo:ProductInfo?{
        didSet{
            if let currentInfo = productInfo{
                configueCell(with: currentInfo)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        infoTitleLabel.layer.borderWidth = 2
        infoTitleLabel.layer.borderColor = UIColor.white.cgColor
        productSpecLabel.layer.borderColor = UIColor.white.cgColor
        productSpecLabel.layer.borderWidth = 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}//ProductInfoTableViewCell class over line

//custom functions
extension ProductInfoTableViewCell{
    internal func configueCell(with productInfo:ProductInfo){
        infoTitleLabel.text = productInfo.title
        productSpecLabel.text = productInfo.info
    }
}
