//
//  ShoppingCart.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

@objc protocol ShoppingCartDelegate: class {
    func updateTotalCartItem()
    @objc optional func confirmRemoval(forProduct product: Product, itemIndexPath: IndexPath)
}

class ShoppingCart {
    
    var items = [(product: Product, qty: Int)]()
    var customer: Customer?
    var creditCard: CreditCard?
    var shippingAddress: Address?
    
    static let sharedInstance = ShoppingCart()
    private init() {}
    
}//ShoppingCart class over line

//custom functions
extension ShoppingCart{
    
    func add(product: Product, qty: Int) {
        
        // Check if a product already exists in the shopping cart
        if let index = find(product: product) {
            
            // If already exists in the shopping cart, add the qty to the current qty
            let newQty = items[index].qty + qty
            items[index] = (product, newQty)
        }else {
            
            // If not yet exists in the shopping cart, add the product with the qty to items array
            items.append((product, qty))
        }
    }
    
    func update(product: Product, qty: Int) {
        if let index = find(product: product) {
            items[index] = (product, qty)
        }
    }
    
    func delete(product: Product) {
        if let index = find(product: product) {
            items.remove(at: index)
        }
    }
    
    func totalItem() -> Int {
        var totalItem = 0
        
        for item in items {
            totalItem += item.qty
        }
        return totalItem
    }
    
    func totalItemCost() -> Double {
        var totalCost: Double = 0.0
        
        for item in items {
            totalCost += Double(item.qty) * item.product.salePrice
        }
        return totalCost
    }
    
    func assignCart(toCustomer customer: Customer) {
        self.customer = customer
    }
    
    func assignShipping(address: Address) {
        self.shippingAddress = address
    }
    
    func reset()  {
        self.items.removeAll()
        self.customer = nil
        self.creditCard = nil
        self.shippingAddress = nil
    }
    
    private func find(product: Product) -> Int? {
        let index = items.index(where: { $0.product == product })
        return index
    }
}
