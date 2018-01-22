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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {

super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {

    }
    
}
