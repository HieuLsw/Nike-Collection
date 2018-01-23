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
    
    //assist view
    var buttonContainerView: UIView?
    var magnifyingGlassView: MagnifyingGlassView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        MagnifyingGlassView.setTargetView(targetView: self.productImageView)
        MagnifyingGlassView.setScale(scale: 5)
    MagnifyingGlassView.setContentFrame(frame: CGRect.init(origin: self.productImageView.bounds.origin, size: CGSize.init(width: 200, height: 200)))
        MagnifyingGlassView.setIndicatorColor(color: UIColor.green)
        MagnifyingGlassView.setShadowColor(color: UIColor.black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func magniftGlassSwitch(_ sender: UIButton) {
        showAction(sender: sender)
    }
    
}//DetailSummaryView class over line

//custom functions
extension DetailSummaryView{
    
    func updateView(with product: Product){
        
// Make sure no previous view still exists in the current view
buttonContainerView?.removeFromSuperview()
        
        //set default state
        qtyLeftLabel.isHidden = true
        addToCartButton.isEnabled = true
        addToCartButton.alpha = 1.0
quantityControl.maximumValue = Double(product.quantity)
        
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
qtyLeftLabel.text = "Only \(product.quantity) \(qtyLeftStr) left" }
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
            let imageCount = allImages.count
            var arrButtons = [UIButton]()
            buttonContainerView = UIView()
            
    for x in 0..<imageCount {
let image = Utility.image(withName: allImages[x].name, andType: "jpg")
let buttonImage = image;let button = UIButton()
button.setTitle(allImages[x].name, for: UIControlState.normal)
button.imageView?.contentMode = .scaleAspectFit
button.setImage(buttonImage, for: UIControlState.normal)
button.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
                button.contentMode = .center
                button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.cornerRadius = 5
                
if x == 0 {
button.frame = CGRect(x: self.productImageView.frame.origin.x, y: 0, width: 50.0, height: 50.0)
}else {
                    
    //  |0| |1|
button.frame = CGRect(x: arrButtons[x-1].frame.maxX + 10, y: arrButtons[x-1].frame.minY, width: 50.0, height: 50.0)
}
                
    arrButtons.append(button)
                
button.addTarget(self, action: #selector(buttonAction(_:)), for: UIControlEvents.touchUpInside)
buttonContainerView?.addSubview(button)}
            
let containerWidth = imageCount * 50 + (imageCount - 1) * 10
buttonContainerView?.frame = CGRect(x: 20, y: Int(productImageView.frame.maxY + 10), width: containerWidth, height: 50)
            self.addSubview(buttonContainerView!)
        }
    }
}

//custom functions selectors
extension DetailSummaryView{
    
    @objc fileprivate func buttonAction(_ sender: UIButton) {
        if let imageName = sender.currentTitle {
            let image = Utility.image(withName: imageName, andType: "jpg")
            productImageView.image = image
            productImageView.contentMode = .scaleAspectFit
        }
    }
    
    @objc func showAction(sender: UIButton) {
        MagnifyingGlassView.show(animated: true)
        sender.setTitle("👁", for: .normal)
        sender.removeTarget(self, action: #selector(showAction(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(hideAction(sender:)), for: .touchUpInside)
    }
    
    @objc func hideAction(sender: UIButton) {
        MagnifyingGlassView.dismiss(animated: true)
        sender.setTitle("🔍", for: .normal)
        sender.removeTarget(self, action: #selector(hideAction(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(showAction(sender:)), for: .touchUpInside)
    }
}


