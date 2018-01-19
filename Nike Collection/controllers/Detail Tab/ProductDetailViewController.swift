//
//  ProductDetailViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var detailSummaryView: DetailSummaryView!
    
    @IBOutlet weak var productDescriptionImageView: UIImageView!
    
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
{didSet{self.tableView.delegate = self
self.tableView.dataSource = self}}
    
    var specifications = [ProductInfo]()
    
    //var productTableVC = ProductsTableViewController()
    
    var product:Product?{
        didSet{if let currentProduct = product{
self.showDetail(forThe: currentProduct)}}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //self.productTableVC.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}// ProductDetailViewController class over line

// custom functions
extension ProductDetailViewController{
    
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
