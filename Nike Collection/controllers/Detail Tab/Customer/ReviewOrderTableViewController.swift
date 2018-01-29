//
//  ReviewOrderTableViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/29/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ReviewOrderTableViewController: UITableViewController,ShoppingCartDelegate {
    
    var shoppingCart = ShoppingCart.sharedInstance
    weak var delegate: ShoppingCartDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "ItemInCartTableViewCell", bundle: nil), forCellReuseIdentifier: "cellItemInCart")
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//UITableViewDataSource
extension ReviewOrderTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,2,3,4,5:
            return 1
        case 2:
            return shoppingCart.items.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0,5:
            tableView.rowHeight = 60
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellPlaceOrder", for: indexPath)
            return cell
        case 1:
            tableView.rowHeight = 60
            let item = shoppingCart.items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellItemInCart", for: indexPath) as! ItemInCartTableViewCell
            cell.item = item
            cell.itemIndexPath = indexPath
            cell.delegate = self
            return cell
        case 2:
            tableView.rowHeight = 60
            let itemStr = shoppingCart.items.count == 1 ? "item" : "items"
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderTotal", for: indexPath)
            cell.textLabel?.text = "Subtotal (\(shoppingCart.totalItem()) \(itemStr))"
            cell.detailTextLabel?.text = shoppingCart.totalItemCost().currencyFormatter
            return cell
        case 3:
            tableView.rowHeight = 135
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellShipping", for: indexPath) as! ShippingTableViewCell
            cell.configureCell()
            return cell
        case 4:
            tableView.rowHeight = 70
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellPayment", for: indexPath) as! PaymentTableViewCell
            cell.configueCell()
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//UITableViewDelegate
extension ReviewOrderTableViewController{
    
}

//ShoppingCartDelegate
extension ReviewOrderTableViewController{
    func updateTotalCartItem() {
        // Invoke delegate in ProductDetailViewController to update the number of item in cart
        delegate?.updateTotalCartItem()
        
        tableView.reloadData()
    }
    
    func confirmRemoval(forProduct product: Product, itemIndexPath: IndexPath) {
        let alertController = UIAlertController(title: "Remove Item", message: "Remove \(product.name!.uppercased()) from your shopping cart?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let removeAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.destructive) { [weak self] (action: UIAlertAction) in
            self?.shoppingCart.delete(product: product)
            self?.tableView.deleteRows(at: [itemIndexPath], with: UITableViewRowAnimation.fade)
            self?.tableView.reloadData()
            
            self?.updateTotalCartItem()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}



