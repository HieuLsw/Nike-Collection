//
//  InitalHiddenImageView.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 3/18/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class InitalHiddenImageView: UIImageView {
    override func layoutSubviews() {
        self.isHidden = true
    }
}
