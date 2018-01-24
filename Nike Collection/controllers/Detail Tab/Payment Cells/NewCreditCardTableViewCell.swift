//
//  NewCreditCardTableViewCell.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/24/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

enum CreditCardType: String{
    case Visa = "visa"
    case MC = "mastercard"
    case Amex = "amex"
    case Discover = "discover"
    case Unknown = "unknown"
}

protocol CreditCardDelegate: class {
    func add(card: CreditCard)
}

class NewCreditCardTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOnCardTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expMonthButton: UIButton!
    @IBOutlet weak var expYearButton: UIButton!
    
    var customer:Customer?
    weak var creditCardDelegate:CreditCardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

@IBAction func didTapAddCard(_ sender: Any) {
    
    guard let nameOnCard = nameOnCardTextField.text else {
        return
    }
    guard let cardNumber = cardNumberTextField.text else {
        return
    }
    guard let expMonth = expMonthButton.titleLabel?.text else {
        return
    }
    guard let expYear = expYearButton.titleLabel?.text else {
        return
    }
    
    let creditCard = CoreDataFetch.addCreditCard(forCustomer: self.customer!, nameOnCard: nameOnCard, cardNumber: cardNumber, expMonth: Int(expMonth)!, expYear: Int(expYear)!)
    self.creditCardDelegate?.add(card: creditCard)
    
    nameOnCardTextField.text = ""
    cardNumberTextField.text = ""
    expMonthButton.setTitle("01", for: .normal)
    expYearButton.setTitle("\(Utility.currentYear())", for: .normal)
    }
    
}







