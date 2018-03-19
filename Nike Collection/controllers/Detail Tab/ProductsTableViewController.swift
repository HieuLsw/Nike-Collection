//
//  ProductsTableViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableViewController: UITableViewController{
    
    struct sectionStructure {
        var isExpanded: Bool
        var products: [Product]
    }
    
    var sectionItems = [sectionStructure]()
    var sectionNames = ["Tops&T-Shirts", "Jackets", "Shoes", "Souvenirs", "Shorts", "Pants"]
    
    //selected cell
    var selectedProduct: Product?
    
    var sceneViewIsHidden: Bool?
    
    //share class
    weak var delegate: ProductDetailViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch all data
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create foot view
        setFootView()
        
        //create observers
        createObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //delete observers
        deleteObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// custom functions
extension ProductsTableViewController{
    
    private func setFootView(){
        let footView = UIView.init()
        footView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.tableFooterView = footView
    }
    
    private func fetchData() {
        sectionItems = sectionNames.map{ (type) -> sectionStructure in
            let returnItem = sectionStructure.init(isExpanded: false, products: CoreDataFetch.productsServe(category: type))
            return returnItem
        }
    }
    
    @objc func handleExpandClose(button: UIButton) {
        
                let section = button.tag
                var indexPaths = [IndexPath]()
        for row in sectionItems[section].products.indices {
            let indexPath = IndexPath.init(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = sectionItems[section].isExpanded
        sectionItems[section].isExpanded = !isExpanded
        if isExpanded {
       UIView.animate(withDuration: 0.4, animations: {
                button.imageView?.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat.pi) / 180.0)})
        tableView.deleteRows(at: indexPaths, with: .fade)
        }
        else {
            UIView.animate(withDuration: 0.4, animations: {
                button.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat.pi) / 180.0)})
        tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
}

//observers
extension ProductsTableViewController {
    fileprivate func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeToHidden(_:)), name: NSNotification.Name.init("knowIsHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToNotHidden(_:)), name: NSNotification.Name.init("knowIsNotHidden"), object: nil)
    }
    fileprivate func deleteObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}

//observers selectors
extension ProductsTableViewController {
    @objc fileprivate func changeToHidden(_: Notification) {
        self.sceneViewIsHidden = true
    }
    
    @objc fileprivate func changeToNotHidden(_: Notification) {
        self.sceneViewIsHidden = false
    }
}

//UITableViewDataSource
extension ProductsTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !sectionItems[section].isExpanded {
            return 0
        }
        return sectionItems[section].products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ProductsTableViewCell
        let currentProduct = sectionItems[indexPath.section].products[indexPath.row]
        if selectedProduct?.id == currentProduct.id{
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            delegate?.product = selectedProduct }else{
            cell.contentView.layer.borderWidth = 0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }
        cell.productImageView.layer.borderWidth = 2
        cell.productImageView.layer.cornerRadius = 10
        cell.productImageView.layer.borderColor = UIColor.red.cgColor
        cell.configureCell(with: currentProduct)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = ButtonWithImage()
        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.titleLabel?.font = UIFont.init(name: "ZiGzAgEo", size: 28)
        button.setImage(#imageLiteral(resourceName: "DownGear"), for: .normal)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.setTitle(sectionNames[section], for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose(button:)), for: .touchUpInside)
        button.tag = section
        return button
    }
}

//UITableViewDelegate
extension ProductsTableViewController{
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let previewCells = tableView.cellForRow(at: indexPath)
        if (previewCells?.isSelected)! {
             tableView.deselectRow(at: indexPath, animated: true)
           NotificationCenter.default.post(name: NSNotification.Name.init("showBasketballSceneView"), object: nil)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name.init("hideBasketballSceneView"), object: nil)
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = sectionItems[indexPath.section].products[indexPath.row]
        delegate?.product = selectedProduct
        if !sceneViewIsHidden! {
             tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
