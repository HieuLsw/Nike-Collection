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
    @IBOutlet weak var assistView: UIView!
    @IBOutlet weak var croppingImageView: InitalHiddenImageView!
    @IBOutlet weak var resultImageView: InitalHiddenImageView!
    
    //assist view
    var buttonContainerView: UIView?
    
    override func layoutSubviews() {
        layoutCroppingImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func magniftGlassSwitch(_ sender: UIButton) {
        showAction(sender: sender)
    }
    
    @IBAction func setPanAttributes(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: self.assistView)
        let changeX = (sender.view?.center.x)! + transition.x
        let changeY = (sender.view?.center.y)! + transition.y
        var limitCenter = CGPoint.init(x: changeX, y: changeY)
        limitCenter.y = max((sender.view?.frame.size.height)! / 2, limitCenter.y)
        limitCenter.y = min(self.assistView.frame.size.height - (sender.view?.frame.size.height)! / 2, limitCenter.y)
        limitCenter.x = max((sender.view?.frame.size.width)! / 2, limitCenter.x)
        limitCenter.x = min(self.assistView.frame.size.width - (sender.view?.frame.size.width)! / 2, limitCenter.x)
        sender.view?.center = limitCenter
        sender.setTranslation(CGPoint.zero, in: self.assistView)
        let iamges = snapshotTargetView(view: self.productImageView, inRect: sender.view?.frame)
        resultImageView.image = resizeImage(image: iamges!, toNewSize: resultImageView.frame.size)
    }
    
}//DetailSummaryView class over line

//custom functions
extension DetailSummaryView{
    
    private func layoutCroppingImageView() {
        croppingImageView.layer.cornerRadius = 0
        croppingImageView.layer.borderWidth = 3
        croppingImageView.layer.borderColor = UIColor.black.cgColor
        let iamges = snapshotTargetView(view: self.productImageView, inRect: croppingImageView.frame)
        resultImageView.image = resizeImage(image: iamges!, toNewSize: resultImageView.frame.size)
    }
    
    private func snapshotTargetView(view: UIView!, inRect rect: CGRect!) -> UIImage! {
        let scale = UIScreen.main.scale
        
        //Snapshot of view
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        UIGraphicsGetCurrentContext()?.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        //Need this to stop screen flashing, but it's slower
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    private func resizeImage(image: UIImage, toNewSize newSize:CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        image.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
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
        sender.setTitle("👁", for: .normal)
        croppingImageView.isHidden = false
        resultImageView.isHidden = false
        sender.removeTarget(self, action: #selector(showAction(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(hideAction(sender:)), for: .touchUpInside)
    }
    
    @objc func hideAction(sender: UIButton) {
        sender.setTitle("🔍", for: .normal)
        croppingImageView.isHidden = true
        resultImageView.isHidden = true
        sender.removeTarget(self, action: #selector(hideAction(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(showAction(sender:)), for: .touchUpInside)
    }
}


