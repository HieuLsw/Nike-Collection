//
//  PopoverTableViewController.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/27/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

enum PopInfoType: String{
    case exMonth = "Expiration Month"
    case exYear = "Expiration Year"
}

protocol PopInfoSelectionDelegate:class {
    func updateWithPopInfoSelection(value: String,sender: UIButton)
}

class PopoverTableViewController: UITableViewController {
    
    var popInfoType:PopInfoType?
    var data = [String]()
    var sender:UIButton?
    weak var delegate:PopInfoSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //choose pop info type
        choosepopInfoType()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//custom functions
extension PopoverTableViewController{
    fileprivate func choosepopInfoType(){
        switch self.popInfoType! {
        case .exMonth:
            data = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        case .exYear:
            let currentYear = Utility.currentYear()
            for year in currentYear...(currentYear + 10){
                data.append("\(year)")
            }
        }
    }
    
}

//UITableViewDataSource
extension PopoverTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 40
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellExpiration", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
}

//UITableViewDelegate
extension PopoverTableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateWithPopInfoSelection(value: data[indexPath.row], sender: self.sender!)
        dismiss(animated: true, completion: nil)
    }
}
