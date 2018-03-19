//
//  InitalHiddenImageView.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 3/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

@objc public protocol MenuViewDelegate {
    
    func menu(_ menu: MenuView, didSelectItemAt index: Int)
}
