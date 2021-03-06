//
//  ProductDetailViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ShoppingCartDelegate{
    @IBOutlet weak var detailSummaryView: DetailSummaryView!
    @IBOutlet weak var productDescriptionImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    {didSet{self.tableView.delegate = self
            self.tableView.dataSource = self}}
    @IBOutlet weak var shoppingCartButton: UIBarButtonItem!
    @IBOutlet var basketballSceneView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let cartButton = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: 35, height: 30))
    let cartLabel = UILabel.init(frame: CGRect.init(x: 22, y: 2, width: 16, height: 16))
    let cartView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
    var productTable = ProductsTableViewController()
    var quantity = 1
    var shoppingCart = ShoppingCart.sharedInstance
    var specifications = [ProductInfo]()
    var product:Product?{
        didSet{if let currentProduct = product{
            self.showDetail(forThe: currentProduct)}}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set cart view
        setCartView()
        
        //set gradient navigation bar
        gradientNavigationBar()
        
        //init basketball scene view
        initBasketballSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create observers
        createObservers()
        
        //update cart
        updateCart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //delete observers
         removeObservers()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,identifier == "segueToViewCart" {
            let navController = segue.destination as! UINavigationController
            let cartTVC = navController.topViewController as! CartTableViewController
            cartTVC.cartDelegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
        if let producct = product{
            self.quantity = Int(detailSummaryView.quantityControl.value)
            shoppingCart.add(product: producct, qty: self.quantity)
            
            UIView.animate(withDuration: 0.5, animations: {[weak self] in
                self?.cartButton.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)})
            
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.cartButton.layer.transform = CATransform3DMakeRotation(CGFloat.pi * 2, 0.0, 1.0, 0.0)}, completion: { (succes: Bool) in
                    DispatchQueue.main.async { [unowned self] in
                        self.cartLabel.text = "\(self.shoppingCart.totalItem())"}})
        }
    }
    
}// ProductDetailViewController class over line

// custom functions
extension ProductDetailViewController{
    
    private func initBasketballSceneView() {
        scrollView.addSubview(basketballSceneView)
        basketballSceneView.translatesAutoresizingMaskIntoConstraints = false
        basketballSceneView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        basketballSceneView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        basketballSceneView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        basketballSceneView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
    }
    
    private func updateCart(){
        cartLabel.text = "\(self.shoppingCart.totalItem())"
    }
    
    private func gradientNavigationBar(){
        navigationController?.navigationBar.setGradientBackground(colors: [#colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)])
    }
    
    private func setCartView(){
        cartButton.setBackgroundImage(#imageLiteral(resourceName: "shopping-cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(viewCart(sender:)), for: .touchUpInside)
        cartLabel.text = "0"
        cartLabel.textColor = .black
        cartLabel.textAlignment = .center
        cartLabel.font = UIFont.init(name: "System", size: 14.0)
        cartLabel.numberOfLines = 1
        cartLabel.adjustsFontSizeToFitWidth = true
        cartView.addSubview(cartButton)
        cartView.addSubview(cartLabel)
        shoppingCartButton.customView = cartView
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
            tableView.reloadData()}}
}

//custom functions selectors
extension ProductDetailViewController {
    @objc fileprivate func viewCart(sender:UIButton){
        performSegue(withIdentifier: "segueToViewCart", sender: self)
    }
}

//observers
extension ProductDetailViewController {
    fileprivate func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideBasketballSceneView(_:)), name: NSNotification.Name.init("hideBasketballSceneView"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(showBasketballSceneView(_:)), name: NSNotification.Name.init("showBasketballSceneView"), object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}

//observers selectors
extension ProductDetailViewController {
 
  @objc fileprivate func hideBasketballSceneView(_: Notification) {
        basketballSceneView.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name.init("knowIsHidden"), object: nil)
    }
    
   @objc fileprivate func showBasketballSceneView(_: Notification) {
        basketballSceneView.isHidden = false
      NotificationCenter.default.post(name: NSNotification.Name.init("knowIsNotHidden"), object: nil)
    }
}
    
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

//ShoppingCartDelegate
extension ProductDetailViewController {
    func updateTotalCartItem() {
        cartLabel.text = "\(shoppingCart.totalItem())"
    }
}






