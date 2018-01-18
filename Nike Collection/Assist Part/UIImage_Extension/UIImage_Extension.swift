//
//  UIImage_Extension.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

extension UIImage{
    
    func resizeImage(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
