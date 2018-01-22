//
//  MagnifyingView.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/22/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class MagnifyingView: UIImageView {

    private var magnifyingGlassShowDelay: TimeInterval = 0.2
    
    private var touchTimer: Timer!
    
    var magnifyingGlass:MagnifyingGlass?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch: UITouch = touches.first {
            
self.touchTimer = Timer.scheduledTimer(timeInterval: magnifyingGlassShowDelay, target: self, selector: #selector(MagnifyingView.addMagnifyingGlassTimer(timer:)), userInfo: NSValue(cgPoint: touch.location(in: self)), repeats: false)
        }
    }
    
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch: UITouch = touches.first {
self.updateMagnifyingGlassAtPoint(point: touch.location(in: self))
        }
    }
    
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchTimer.invalidate()
        self.touchTimer = nil
        self.removeMagnifyingGlass()
    }

}//MagnifyingView class over line

//custom functions
extension MagnifyingView{
   @objc func addMagnifyingGlassTimer(timer: Timer) {
        let value: AnyObject? = timer.userInfo as AnyObject?
        if let point = value?.cgPointValue {
            self.addMagnifyingGlassAtPoint(point: point)
        }
    }
    
    private func addMagnifyingGlassAtPoint(point: CGPoint) {
        self.magnifyingGlass?.viewToMagnify = self as UIView
        self.magnifyingGlass?.touchPoint = point
        let selfView: UIView = self as UIView
        selfView.addSubview(self.magnifyingGlass!)
        self.magnifyingGlass?.setNeedsDisplay()
    }
    
    private func removeMagnifyingGlass() {
        self.magnifyingGlass?.removeFromSuperview()
    }
    
    private func updateMagnifyingGlassAtPoint(point: CGPoint) {
        self.magnifyingGlass?.touchPoint = point
        self.magnifyingGlass?.setNeedsDisplay()
    }
}
