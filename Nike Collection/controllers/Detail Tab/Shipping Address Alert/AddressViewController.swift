//
//  AddressViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/23/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var addressPickerView: UIPickerView!
        {didSet{self.addressPickerView.delegate = self
            self.addressPickerView.dataSource = self}}
    @IBOutlet var textFields: [UITextField]!
        {didSet{_ = self.textFields.map { $0.delegate = self}}}
    @IBOutlet weak var noAddressLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var customer: Customer?
    var addresses = [Address]()
    var selectedAddress:Address?
    var activeTextField:UITextField?
    var shoppingCart = ShoppingCart.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set inital state
        setInitalState()
        
        //register for notifications
        registerForNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove notifications
        removeNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier{
            case "segueToPayment":
                if let customer = customer{
                    shoppingCart.assignCart(toCustomer: customer)
                    var address:Address
                    
                    if !(textFields[1].text?.isEmpty)!{
                        address = CoreDataFetch.addAddress(forCustomer: customer, address1:textFields[1].text! , address2: textFields[2].text!, city: textFields[3].text!, state: textFields[4].text!, zip: textFields[5].text!, phone: textFields[6].text!)
                        shoppingCart.assignShipping(address: address)
                    }else {
                        if selectedAddress == nil{
                            selectedAddress = addresses[self.addressPickerView.selectedRow(inComponent: 0)]
                        }
                        shoppingCart.assignShipping(address: selectedAddress!)
                    }
                    let paymentController = segue.destination as! PaymentViewController
                    paymentController.customer = customer
                }
            default: break
            }
        }
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

//observers
extension AddressViewController{
    private func registerForNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardIsOn(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardIsOff(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    private func removeNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
}

//observers selectors
extension AddressViewController{
    @objc private func keyboardIsOn(sender: Notification){
        let info = sender.userInfo! as NSDictionary
        let value = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize = value.cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height - 90, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardIsOff(sender: Notification){
        scrollView.setContentOffset(CGPoint.init(x: 0, y: -50), animated: true)
        scrollView.isScrollEnabled = false
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

//UITextFieldDelegate
extension AddressViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        scrollView.isScrollEnabled = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeTextField = nil
        return true
    }
}
