//
//  PaymentTableViewCell.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/29/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNumberLaber: UILabel!
    @IBOutlet weak var nameOnCardLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    
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

//custom funcitons
extension PaymentTableViewCell{
    func configueCell()  {
        if let creditCard = shoppingCart.creditCard{
            let cardType = creditCard.type
            cardImageView.image = UIImage.init(named: cardType!)
            cardNumberLaber.text = creditCard.cardNumber?.maskedPlusLast4()
            nameOnCardLabel.text = creditCard.nameOnCard
            expirationLabel.text = "\(creditCard.expMonth)/\(creditCard.expYear)"
        }
    }
}



