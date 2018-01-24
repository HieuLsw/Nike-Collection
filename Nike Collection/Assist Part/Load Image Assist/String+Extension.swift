//
//  String+Extension.swift
//  Nike Collection
//
//  Created by Shao Kahn on 11/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

extension String {
    func stripFileExtension() -> String {
        if self.contains(".") {
            
            // example: "Jordan.jpg" to "Jordan"
        return String(self[..<self.index(of: ".")!])
        }
        return self
    }
    
    func maskedPlusLast4() -> String{
        let last4CardNumber = self[self.index(self.endIndex, offsetBy: -4)...]
        return "****\(last4CardNumber)"
    }
}
