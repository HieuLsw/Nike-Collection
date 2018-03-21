//
//  InitalHiddenImageView.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 3/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

public struct MenuItem {
    
    public var image: UIImage
    public var highlightedImage: UIImage?
    
    public var backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    public var highlightedBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    // MARK: - Init
    public init(image: UIImage, highlightedImage: UIImage? = nil) {
        self.image = image
        self.highlightedImage = highlightedImage
    }    
}
