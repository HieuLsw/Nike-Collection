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
tableView.register(UINib(nibName: "ItemInCartTableViewCell", bundle: nil), forCellReuseIdentifier: "cellItemInCart")
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            tableView.rowHeight = 80
            
            let item = shoppingCart.items[indexPath.row]
            
let cell = tableView.dequeueReusableCell(withIdentifier: "cellItemInCart", for: indexPath) as! ItemInCartTableViewCell
cell.item = item;cell.itemIndexPath = indexPath
            return cell
            
case 1:tableView.rowHeight = 40
            
            // Subtotal ( xx items) .... $$$
let itemStr = shoppingCart.items.count == 1 ? "item" : "items"
let cell = tableView.dequeueReusableCell(withIdentifier: "cellSummary", for: indexPath)
cell.textLabel?.text = "Subtotal (\(shoppingCart.totalItem()) \(itemStr))"
cell.detailTextLabel?.text = shoppingCart.totalItemCost().currencyFormatter
return cell
            
        default:
            return UITableViewCell()
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
