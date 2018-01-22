//
//  MagnifyingGlass.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/22/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class MagnifyingGlass: UIImageView {

     var viewToMagnify: UIView!
     var touchPoint: CGPoint! {
        didSet {
self.center = CGPoint(x: touchPoint.x + touchPointOffset.x, y: touchPoint.y + touchPointOffset.y)
        }
    }
    
     var touchPointOffset: CGPoint!
     var scale: CGFloat!
     var scaleAtTouchPoint: Bool!
     var magnifyingGlassDefaultRadius: CGFloat = 40.0
     var magnifyingGlassDefaultOffset: CGFloat = -40.0
     var magnifyingGlassDefaultScale: CGFloat = 2.0
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1).cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = frame.size.width / 2
        self.layer.masksToBounds = true
        self.touchPointOffset = CGPoint(x: 0, y: magnifyingGlassDefaultOffset)
        self.scale = magnifyingGlassDefaultScale
        self.viewToMagnify = nil
        self.scaleAtTouchPoint = true
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.frame.size.width/2, y: self.frame.size.height/2)
        context.scaleBy(x: self.scale, y: self.scale)
        context.translateBy(x: -self.touchPoint.x, y: -self.touchPoint.y + (self.scaleAtTouchPoint != nil ? 0 : self.bounds.size.height/2))
        self.viewToMagnify.layer.render(in: context)
    }

}//MagnifyingGlass class over line

//custom functions
extension MagnifyingGlass{
    func initViewToMagnify(viewToMagnify: UIView, touchPoint: CGPoint, touchPointOffset: CGPoint, scale: CGFloat, scaleAtTouchPoint: Bool) {
        self.viewToMagnify = viewToMagnify
        self.touchPoint = touchPoint
        self.touchPointOffset = touchPointOffset
        self.scale = scale
        self.scaleAtTouchPoint = scaleAtTouchPoint
    }
    
    private func setFrame(frame: CGRect) {
        super.frame = frame
        self.layer.cornerRadius = frame.size.width / 2
    }
    
}
