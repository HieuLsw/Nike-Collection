//
//  ExistingCreditCardTableViewCell.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/24/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ExistingCreditCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var nameOnCardLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var noCreditCardLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}//ExistingCreditCardTableViewCell class over line

//custom functions
extension ExistingCreditCardTableViewCell{
    
    func configueCell(withCreditCard creditCard: CreditCard){
       noCreditCardLabel.isHidden = true
        cardNumberLabel.text = creditCard.cardNumber
        cardTypeImageView.image = UIImage.init(named: creditCard.type!)
        nameOnCardLabel.text = creditCard.nameOnCard
        expirationLabel.text = "\(creditCard.expMonth)/\(creditCard.expYear)"
    }
    
}
