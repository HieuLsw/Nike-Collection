//
//  LoginViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/22/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

@IBOutlet weak var emailTextField: UITextField!
@IBOutlet weak var passwordTextField: UITextField!
    
    var customer: Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
      case "segueShipAddress":
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
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        
customer = CoreDataFetch.verify(username: email, password: password)
        
        if customer != nil {
performSegue(withIdentifier: "segueShipAddress", sender: self)}
        else{
let alertController = UIAlertController(title: "Login Failed", message: "We do not recognize your email and/or password.  \nPlease try again.", preferredStyle: UIAlertControllerStyle.alert)
            
let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
DispatchQueue.main.async { [weak self] in
self?.emailTextField.text = ""
self?.passwordTextField.text = ""}
})
            
alertController.addAction(okAction)
present(alertController, animated: true, completion: nil)
        }
    }
  
    @IBAction func unwindFromCreateAccount(segue: UIStoryboardSegue){
        
    }
    
}
