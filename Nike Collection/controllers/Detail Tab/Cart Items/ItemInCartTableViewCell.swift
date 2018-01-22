//
//  ItemInCartTableViewCell.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/21/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ItemInCartTableViewCell: UITableViewCell,UITextFieldDelegate {

@IBOutlet weak var productImageView: UIImageView!
@IBOutlet weak var productNameLabel: UILabel!
@IBOutlet weak var qtyTextField: UITextField!
{didSet{self.qtyTextField.delegate = self}}
@IBOutlet weak var priceLabel: UILabel!
  
    var shoppingCart = ShoppingCart.sharedInstance
    var item: (product: Product, qty: Int)? {
        didSet {
            if let currentItem = item {
                refreshCell(currentItem: currentItem)
            }
        }
    }
    var itemIndexPath: IndexPath?
    weak var delegate:ShoppingCartDelegate?
    
override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTapRemove(_ sender: Any) {
        
        if let product = item?.product,let itemIndexPath = itemIndexPath{
delegate?.confirmRemoval!(forProduct: product, itemIndexPath: itemIndexPath)
        }
    }
    
}//ItemInCartTableViewCell class over line

//custom functions
extension ItemInCartTableViewCell{
    private func refreshCell(currentItem: (product: Product, qty: Int)) {
productImageView.image = Utility.image(withName: currentItem.product.mainimage, andType: "jpg")
        productNameLabel.text = currentItem.product.name
        qtyTextField.text = "\(currentItem.qty)"
        priceLabel.text = currentItem.product.salePrice.currencyFormatter
    }
}

//UITextFieldDelegate
extension ItemInCartTableViewCell{
    func textFieldDidEndEditing(_ textField: UITextField) {
if let qty = qtyTextField.text, let currentItem = self.item {
            shoppingCart.update(product: currentItem.product, qty: Int(qty)!)
    delegate?.updateTotalCartItem()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();return true
    }
}


