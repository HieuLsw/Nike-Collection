//
//  ProductDetailViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var detailSummaryView: DetailSummaryView!
    @IBOutlet weak var productDescriptionImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
{didSet{self.tableView.delegate = self
self.tableView.dataSource = self}}
    
@IBOutlet weak var shoppingCartButton: UIButton!
@IBOutlet weak var cartItemCountLabel: UILabel!
 
@IBOutlet weak var stateView: UIView!
    
var productTable = ProductsTableViewController()
var quantity = 1
var shoppingCart = ShoppingCart.sharedInstance
var specifications = [ProductInfo]()
var product:Product?{
        didSet{if let currentProduct = product{
self.showDetail(forThe: currentProduct)}}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    //configue state view
     configueStateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
        if let producct = product{
            
  shoppingCart.add(product: producct, qty: self.quantity)
self.quantity = 1
            
UIView.animate(withDuration: 0.5, animations: {[weak self] in
 self?.shoppingCartButton.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)})

UIView.animate(withDuration: 0.5, animations: { [weak self] in
self?.shoppingCartButton.layer.transform = CATransform3DMakeRotation(CGFloat.pi * 2, 0.0, 1.0, 0.0)}, completion: { (succes: Bool) in
DispatchQueue.main.async { [unowned self] in
self.cartItemCountLabel.text = "\(self.shoppingCart.totalItem())"}})
            
        }
    }
    
}// ProductDetailViewController class over line

// custom functions
extension ProductDetailViewController{
    
    fileprivate func configueStateView(){
        self.view.addSubview(stateView)
        stateView.translatesAutoresizingMaskIntoConstraints = false
        stateView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        stateView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stateView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stateView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
   internal func openState() {
        self.stateView.isHidden = true
    }
    
    internal func closeState() {
        self.stateView.isHidden = false
    }
    
fileprivate func showDetail(forThe currentProduct:Product){
        if viewIfLoaded != nil {
detailSummaryView.updateView(with: currentProduct)
let productInfo = currentProduct.productInfo?.allObjects as! [ProductInfo]
specifications = productInfo.filter{ $0.type == "specs"}
var description = ""
for currentInfo in productInfo{
if let info = currentInfo.info, info.count > 0, currentInfo.type == "description"{
description = description + info + "\n\n"}}
productDescriptionLabel.text = description
productDescriptionImageView.image = Utility.image(withName: currentProduct.mainimage, andType: "jpg")
tableView.reloadData()}}}

//UITableViewDataSource
extension ProductDetailViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCell(withIdentifier: "cellProductInfo", for: indexPath) as! ProductInfoTableViewCell
        cell.productInfo = specifications[indexPath.row]
        return cell
    }
}

//UITableViewDelegate
extension ProductDetailViewController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}







