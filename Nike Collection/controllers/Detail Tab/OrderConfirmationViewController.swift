//
//  OrderConfirmationViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/29/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var orderConfirmationNumberLabel: UILabel!
    
    var shoppingCart = ShoppingCart.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up bar button items
    setUpBarButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapContinueShopping(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
        shoppingCart.reset()
    }
    
}

//custom functions
extension OrderConfirmationViewController{
    
    fileprivate func setUpBarButtonItem(){
        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        orderConfirmationNumberLabel.text = UUID.init().uuidString
    }
    
    
}





