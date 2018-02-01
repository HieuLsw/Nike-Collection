//
//  PaymentViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/24/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,PopInfoSelectionDelegate,CreditCardDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
        {didSet{self.tableView.dataSource = self;self.tableView.delegate = self}}
    
    var customer: Customer?
    var creditCards = [CreditCard]()
    var shoppingCart = ShoppingCart.sharedInstance
    var popInfoType: PopInfoType?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set card type
        setCardType()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapExpMonth(_ sender: UIButton) {
        popInfoType = PopInfoType.exYear
        showPopoverInfo(forSender: sender)
    }
    
    @IBAction func didTapExpYear(_ sender: UIButton) {
        popInfoType = PopInfoType.exMonth
        showPopoverInfo(forSender: sender)
    }
}

//custom functions
extension PaymentViewController{
    fileprivate func setCardType(){
        if let customer = customer{
            let creditCardSet = customer.creditCard?.mutableCopy() as! NSMutableSet
            if creditCardSet.count > 0 {
                creditCards = creditCardSet.allObjects as! [CreditCard]
            }
        }
    }
}

//UITableViewDataSource
extension PaymentViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,2,3:
            return 1
        case 1:
            let rowCount = creditCards.count > 0 ? creditCards.count : 1
            return rowCount
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            tableView.rowHeight = 30
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitleLabel", for: indexPath)
            return cell
            
        case 1:
            tableView.rowHeight = 30
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCreditCard", for: indexPath) as! ExistingCreditCardTableViewCell
            cell.accessoryType = .none
            
            let isCreditCardOnRecord = self.creditCards.count > 0 ? true : false
            cell.noCreditCardLabel.isHidden = isCreditCardOnRecord
            cell.cardTypeImageView.isHidden = !isCreditCardOnRecord
            cell.cardNumberLabel.isHidden = !isCreditCardOnRecord
            cell.nameOnCardLabel.isHidden = !isCreditCardOnRecord
            cell.expirationLabel.isHidden = !isCreditCardOnRecord
            
            if isCreditCardOnRecord == true {
                let creditCard = self.creditCards[indexPath.row]
                cell.configueCell(withCreditCard: creditCard)
                
                if self.creditCards[indexPath.row] == shoppingCart.creditCard {
                    cell.accessoryType = .checkmark
                    selectedIndexPath = indexPath
                }
            }
            
            return cell
            
        case 2:
            tableView.rowHeight = 50
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAddCardTitle", for: indexPath)
            return cell
            
        case 3:
            tableView.rowHeight = 200
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAddCard", for: indexPath) as! NewCreditCardTableViewCell
            cell.customer = customer
            cell.creditCardDelegate = self
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}

//UITableViewDelegate
extension PaymentViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if self.creditCards.count > 0 {
                shoppingCart.creditCard = self.creditCards[indexPath.row]
                
                if selectedIndexPath != nil && selectedIndexPath != indexPath {
                    tableView.cellForRow(at: selectedIndexPath!)?.accessoryType = .none
                    selectedIndexPath = indexPath
                }
                
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
        default:
            break
        }
    }
}

//PopInfoSelectionDelegate
extension PaymentViewController {
    func updateWithPopInfoSelection(value: String, sender: UIButton) {
        sender.setTitle(value, for: UIControlState.normal)
    }
}

//CreditCardDelegate
extension PaymentViewController{
    func add(card: CreditCard) {
        self.shoppingCart.creditCard = card
        self.creditCards.append(card)
        
        self.tableView.reloadData()
    }
}

//UIPopoverPresentationControllerDelegate
extension PaymentViewController {
    func showPopoverInfo(forSender sender: UIButton) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "navPopover") as! UINavigationController
        navController.modalPresentationStyle = .popover
        
        let popoverTVC = navController.topViewController as! PopoverTableViewController
        popoverTVC.popInfoType = popInfoType
        popoverTVC.title = popInfoType?.rawValue
        popoverTVC.sender = sender
        popoverTVC.delegate = self
        
        let popoverController = navController.popoverPresentationController
        popoverController?.sourceView = sender
        popoverController?.sourceRect = sender.bounds
        popoverController?.permittedArrowDirections = .any
        popoverController?.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
}


