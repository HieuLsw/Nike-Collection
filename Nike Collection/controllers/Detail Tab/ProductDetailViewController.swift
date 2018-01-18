//
//  ProductDetailViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var detailSummaryView: DetailSummaryView!
    
    var productTableVC = ProductsTableViewController()
    
    var product:Product?{
        didSet{if let currentProduct = product{
self.showDetail(forThe: currentProduct)}}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
     self.productTableVC.delegate = self
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
detailSummaryView.updateView(with: currentProduct)}
    }    
}


