//
//  ProductsTableViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableViewController: UITableViewController, MenuViewDelegate{
    
    struct sectionStructure {
        var isExpanded: Bool
        var products: [Product]
    }
    
    var sectionItems = [sectionStructure]()
    var sectionItems1 = [sectionStructure]()
   fileprivate var sectionNames = ["Tops&T-Shirts", "Jackets", "Shoes", "Souvenirs", "Shorts", "Pants"]
   fileprivate var sectionNames1 = ["Jackets", "Sleeves", "Glove", "Shoes"]
    
    //selected cell
    var selectedProduct: Product?
    fileprivate var currentIndex = 0
    fileprivate var sceneViewIsHidden: Bool?
    fileprivate var menu: MenuView!
    fileprivate let items = [MenuItem.init(image: #imageLiteral(resourceName: "Basketball Index")), MenuItem.init(image: #imageLiteral(resourceName: "USF Index"))]
    
    //share class
    weak var delegate: ProductDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch all data
        fetchData()
        
        // load menu
        loadMenu()
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
    
    @IBAction func switchMenu(_ sender: Any) {
        menu.setRevealed(!menu.revealed, animated: true)
    }
}

// custom functions
extension ProductsTableViewController{
    
    fileprivate func loadMenu() {
        menu = {
            let menu = MenuView()
            menu.delegate = self
            menu.items = items
            return menu
        }()
        
        tableView.addSubview(menu)
    }
    
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
        sectionItems1 = sectionNames1.map{ (type) -> sectionStructure in
            let returnItem = sectionStructure.init(isExpanded: false, products: CoreDataFetch.productsServe(category: type + "UF"))
            return returnItem
        }
    }
    
    fileprivate func isExpand(isExpanded : Bool, button: UIButton, indexPaths: [IndexPath]) {
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
    
    @objc func handleExpandClose(button: UIButton) {
        
                let section = button.tag
                var indexPaths = [IndexPath]()
        
        if currentIndex == 0 {
        for row in sectionItems[section].products.indices {
            let indexPath = IndexPath.init(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = sectionItems[section].isExpanded
            sectionItems[section].isExpanded = !isExpanded
            isExpand(isExpanded: isExpanded, button: button, indexPaths: indexPaths)
        }
        else if currentIndex == 1 {
            for row in sectionItems1[section].products.indices {
                let indexPath = IndexPath.init(row: row, section: section)
                indexPaths.append(indexPath)
            }
            let isExpanded = sectionItems1[section].isExpanded
            sectionItems1[section].isExpanded = !isExpanded
            isExpand(isExpanded: isExpanded, button: button, indexPaths: indexPaths)
     }
    }
}

//observers
extension ProductsTableViewController {
    fileprivate func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeToHidden(_:)), name: NSNotification.Name.init("knowIsHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToNotHidden(_:)), name: NSNotification.Name.init("knowIsNotHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex(_:)), name: NSNotification.Name.init("indexChanged"), object: nil)
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
    @objc fileprivate func changeIndex(_: Notification) {
        tableView.reloadData()
    }
}

//UITableViewDataSource
extension ProductsTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if currentIndex == 0 {
            return sectionNames.count }
        else if currentIndex == 1 {
            return sectionNames1.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentIndex == 0 {
        if !sectionItems[section].isExpanded {
            return 0
        }
            return sectionItems[section].products.count }
        else if currentIndex == 1 {
            if !sectionItems1[section].isExpanded {
                return 0
            }
            return sectionItems1[section].products.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ProductsTableViewCell
        var currentProduct = Product.init()
        if currentIndex == 0 {
           currentProduct = sectionItems[indexPath.section].products[indexPath.row]}
        else if currentIndex == 1 {
           currentProduct = sectionItems1[indexPath.section].products[indexPath.row]}
        if selectedProduct?.id == currentProduct.id{
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
        if currentIndex == 0 {
        button.setTitle(sectionNames[section], for: .normal)
        } else if currentIndex == 1 {
        button.setTitle(sectionNames1[section], for: .normal)
        }
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
        if currentIndex == 0 {
        selectedProduct = sectionItems[indexPath.section].products[indexPath.row]
        delegate?.product = selectedProduct
        } else if currentIndex == 1 {
selectedProduct = sectionItems1[indexPath.section].products[indexPath.row]
delegate?.product = selectedProduct
        }
        if !sceneViewIsHidden! {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension ProductsTableViewController {
    func menu(_ menu: MenuView, didSelectItemAt index: Int) {
        currentIndex = index
        NotificationCenter.default.post(name: NSNotification.Name.init("indexChanged"), object: nil)
    }
}
