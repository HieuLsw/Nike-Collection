//
//  CartTableViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class CartTableViewController: UITableViewController {
    
@IBOutlet weak var checkOutButton: UIBarButtonItem!

    var shoppingCart = ShoppingCart.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkOutButton.isEnabled = shoppingCart.totalItem() > 0 ? true : false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

@IBAction func ContinueShopping(_ sender: Any) {
     
        dismiss(animated: true, completion: nil)
        
    }
    
}//CartTableViewController class over line

//UITableViewDataSource
extension CartTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return shoppingCart.items.count
        case 1:
            return 1
        default:
            return 0
        }
    }

}

//UITableViewDelegate
extension CartTableViewController{
    
override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Review Items"
        default:
            return ""
        }
    }
    
}
