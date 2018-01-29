//
//  ShippingTableViewCell.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/29/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ShippingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customNameLabel: UILabel!
    @IBOutlet weak var addAddress1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    let shoppingCart = ShoppingCart.sharedInstance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//custom functions
extension ShippingTableViewCell{
    
    func configureCell(){
        if let customr = shoppingCart.customer, let shippingAddress = shoppingCart.shippingAddress{
            customNameLabel.text = customr.name
            phoneLabel.text = customr.phone
            addAddress1Label.text = shippingAddress.address1
            if let address2 = shippingAddress.address2{
                address2Label.text = address2
            }else{
                address2Label.text = ""
            }
            cityLabel.text = "\(shippingAddress.city!),"
            stateLabel.text = shippingAddress.state
            zipLabel.text = shippingAddress.zip
            
        }
    }
    
}
