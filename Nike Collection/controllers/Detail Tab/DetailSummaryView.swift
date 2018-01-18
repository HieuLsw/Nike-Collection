//
//  DetailSummaryView.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class DetailSummaryView: UIView{
    
    @IBOutlet weak var manufacturer: UILabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var listPriceLabel: UILabel!
    
    @IBOutlet weak var dealPriceLabel: UILabel!
    
    @IBOutlet weak var priceSaveDollarLabel: UILabel!
    
    @IBOutlet weak var priceSavedPercentlabel: UILabel!
    
    @IBOutlet weak var isInStock: UILabel!
    
    @IBOutlet weak var qtyLeftLabel: UILabel!
    
    @IBOutlet weak var quantityControl: Stepper!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var userRating: UserRating!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}//DetailSummaryView class over line

//custom functions
extension DetailSummaryView{
    
    func updateView(with product: Product){
        
        //set default state
        qtyLeftLabel.isHidden = true
        addToCartButton.isEnabled = true
        addToCartButton.alpha = 1.0
        
        //product info
         manufacturer.text = product.manufacturer?.name
         userRating.rating = Int(product.rating)
         productNameLabel.text = product.name
        
let listPricAttributeString = NSAttributedString.init(string: product.regularPrice.currencyFormatter, attributes: [NSAttributedStringKey.strikethroughStyle : 1])
listPriceLabel.attributedText = listPricAttributeString
        
dealPriceLabel.text = product.salePrice.currencyFormatter
priceSaveDollarLabel.text = (product.regularPrice - product.salePrice).currencyFormatter
        
let percentSave = ((product.regularPrice - product.salePrice) / product.regularPrice).percentFormatter
priceSavedPercentlabel.text = percentSave
        
        if product.quantity > 0{
            isInStock.textColor = UIColor.green
            isInStock.text = "In Stock"
            
            if product.quantity < 5{
                qtyLeftLabel.isHidden = false
let qtyLeftStr = product.quantity == 1 ? "item" : "items"
qtyLeftLabel.text = "Only \(product.quantity) \(qtyLeftStr) left"
            }
        }
        else{
            isInStock.textColor = UIColor.red
            isInStock.text = "Currently Unavailable"
            addToCartButton.isEnabled = false
            addToCartButton.alpha = 0.5
        }
        
        if let images = product.productImages{
    let allImages = images.allObjects as! [ProductImage]
            
            if let mainImage = allImages.first{
productImageView.image = Utility.image(withName: mainImage.name, andType: "jpg")
            }
        }
    }
}
