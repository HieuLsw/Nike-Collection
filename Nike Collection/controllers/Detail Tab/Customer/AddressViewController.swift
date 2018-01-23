//
//  AddressViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/23/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var addressPickerView: UIPickerView!
{didSet{self.addressPickerView.delegate = self
self.addressPickerView.dataSource = self}}
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
    var addresses = [Address]()
    var selectedAddress:Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set inital state
        setInitalState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}//AddressViewController class over line

//custom functions
extension AddressViewController{
    fileprivate func setInitalState(){
        addressPickerView.isHidden = false
        noAddressLabel.isHidden = true
        
        if let customer = customer {
            addresses = CoreDataFetch.addressList(forCustomer: customer)
            if addresses.count == 0{
                addressPickerView.isHidden = true
                noAddressLabel.isHidden = false
            }
        }
    }
}

//UIPickerViewDataSource
extension AddressViewController{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addresses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let address = addresses[row]
return "\(address.address1!) \(address.address2!) \(address.city!) \(address.state!) \(address.zip!)"
    }
}

//UIPickerViewDelegate
extension AddressViewController{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAddress = addresses[row]
    }
}
