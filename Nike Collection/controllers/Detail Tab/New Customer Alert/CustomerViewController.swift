//
//  CustomerViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/23/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar
        setNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier{
            case "segueAddAddress":
                
                guard let name = nameTextField.text, let email =  emailTextField.text, let password = passwordTextField.text, name.count > 0, email.count > 0, !password.isEmpty else {
                    
                    let alertController = UIAlertController(title: "Missing Information", message: "Please npprovide all the information for name, email and password", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alertController.addAction(okAction)
                    present(alertController, animated: true, completion: nil)
                    return
                }
                let customer = CoreDataFetch.addCustomer(name: name, email: email, password: password)
                
                let addressController = segue.destination as! AddressViewController
                addressController.customer = customer
            default: break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}//CustomerViewController class over line

//custom functions
extension CustomerViewController{
    
    fileprivate func setNavigationBar(){
        let navBack = UIBarButtonItem.init(title: "", style: .plain, target: navigationController, action: nil)
        self.navigationItem.leftBarButtonItem = navBack
    }
}
