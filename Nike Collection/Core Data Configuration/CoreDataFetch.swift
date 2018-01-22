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
}
