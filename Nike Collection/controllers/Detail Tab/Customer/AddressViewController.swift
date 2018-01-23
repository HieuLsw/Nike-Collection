//
//  AddressViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/23/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {
    
    @IBOutlet weak var addressPickerView: UIPickerView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var noAddressLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var customer: Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
