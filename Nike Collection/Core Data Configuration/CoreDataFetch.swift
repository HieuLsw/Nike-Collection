//
//  ProductService.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataFetch {
    
   static func productsServe(category type: String) -> [Product] {
        
        let appDelegateFetch = UIApplication.shared.delegate as! AppDelegate
  let managedObjectContexts = appDelegateFetch.coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        request.predicate = NSPredicate(format: "type == %@", type)
              
        do {
            
   let products = try managedObjectContexts.fetch(request)
            return products
        }
        catch let error as NSError {
fatalError("Error is getting product list: \(error.localizedDescription)")
        }
    }
    
   static func verify(username: String, password: String) -> Customer? {
        let appDelegateFetch = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContexts = appDelegateFetch.coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Customer> = Customer.fetchRequest()
    request.predicate = NSPredicate(format: "email = %@ AND password = %@", username, password)
        do {
            let result = try managedObjectContexts.fetch(request)
            if result.count > 0 {return result.first}
            return nil
        }
        catch let error as NSError {
fatalError("Error verifying customer login: \(error.localizedDescription)")
        }
    }
    
 static func addCustomer(name: String, email:String, password: String) -> Customer{
   
    let appDelegateFetch = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContexts = appDelegateFetch.coreDataStack.persistentContainer.viewContext
    let customer = Customer(context: managedObjectContexts)
    customer.name = name
    customer.email = email
    customer.password = password
    do {
        try managedObjectContexts.save()
        return customer
    }
    catch let error as NSError {
        fatalError("Error create a new customer: \(error.localizedDescription)")
    }
    }
    
static func addressList(forCustomer customer:Customer) -> [Address]{
        
let addresses = customer.address?.mutableCopy() as! NSMutableSet
return addresses.allObjects as! [Address]
    }
    
static func addAddress(forCustomer customer: Customer,address1: String,address2: String,city: String,state: String,zip: String,phone: String) -> Address{
        let appDelegateFetch = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContexts = appDelegateFetch.coreDataStack.persistentContainer.viewContext
        let address = Address(context: managedObjectContexts)
        address.address1 = address1
        address.address2 = address2
        address.state = state
        address.city = city
        address.zip = zip
        
        let addresses = customer.address?.mutableCopy() as! NSMutableSet
        addresses.add(address)
        customer.address = addresses.copy() as? NSSet
        customer.phone = phone
        
        do {
            try managedObjectContexts.save();return address
        } catch let error as NSError {
fatalError("Error adding customer address: \(error.localizedDescription)")
        }
    }
    
}
