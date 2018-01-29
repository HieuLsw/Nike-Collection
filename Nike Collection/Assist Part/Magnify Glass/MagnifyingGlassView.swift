//
//  MagnifyingGlassView.swift
//  Nike Collection
//
//  Created by Bobby Negoat on 1/23/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

private let _MagnifyingGlassViewInstance = MagnifyingGlassView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))

class MagnifyingGlassView: UIView {
    
    class var sharedInstance: MagnifyingGlassView {
        return _MagnifyingGlassViewInstance
    }
    
    let glassView = UIView()
    let magnifyingImageView = UIImageView()
    let indicatorView = UIView()
    let shadowLayer = CAShapeLayer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    var targetView:UIView = UIApplication.shared.windows.first!
    var scale: CGFloat = 2
    
    convenience init(){
        self.init(frame:CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutSubviews(animated: false)
    }
    
    //Convert touch space into a circle instead of a rectangle
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let radius = self.bounds.size.width / 2
        let center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        
        let dist = distanceFromPoint(point1: point, toPoint: center)
        if(dist <= radius){
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
}//MagnifyingGlassView class over line

//custom functions
extension MagnifyingGlassView{
    
    fileprivate func setupViews() {
        
        //Set up the indicator
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/scale, height: self.frame.size.height/scale)
        indicatorView.layer.borderColor = UIColor.lightGray.cgColor
        indicatorView.layer.borderWidth = 2
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width/2
        indicatorView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(indicatorView)
        
        //Set up the glass
        let glassY = indicatorView.frame.origin.y - 10 - self.frame.size.height
        glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(glassView)
        
        //Add shadow layer
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        glassView.layer.addSublayer(shadowLayer)
        
        //Set up the image display
        magnifyingImageView.frame = CGRect(x: 0, y: 0, width: glassView.frame.size.width, height: glassView.frame.size.height)
        magnifyingImageView.contentMode = UIViewContentMode.scaleToFill
        magnifyingImageView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        magnifyingImageView.clipsToBounds = true
        glassView.addSubview(magnifyingImageView)
        
        //Set up gesture recognizer
        panGestureRecognizer.addTarget(self, action: #selector(panAction(sender:)))
        indicatorView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.isEnabled = true
    }
    
    fileprivate func moveView(translation: CGPoint) {
        self.frame = CGRect(x:self.frame.origin.x + translation.x, y:self.frame.origin.y + translation.y, width:self.frame.size.width, height:self.frame.size.height)
        self.layoutSubviews(animated: false)
    }
    
    fileprivate func snapshotTargetView(view: UIView!, inRect rect: CGRect!) -> UIImage! {
        //Hide self
        self.isHidden = true
        let scale = UIScreen.main.scale
        
        //Snapshot of view
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        UIGraphicsGetCurrentContext()?.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        //Need this to stop screen flashing, but it's slower
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show self
        self.isHidden = false
        return snapshotImage
    }
    
    fileprivate func resizeImage(image: UIImage, toNewSize newSize:CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        image.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    fileprivate func layoutSubviews(animated: Bool) {
        let cornerRadius = CGFloat(max(frame.size.width, frame.size.height) / 2)
        magnifyingImageView.layer.borderColor = UIColor.gray.cgColor
        magnifyingImageView.layer.cornerRadius = CGFloat(cornerRadius)
        
        //Update the indicator frame
        let indicatorSize = max(min(self.frame.size.width/scale, 50),10)
        indicatorView.frame = CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize)
        indicatorView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width/2
        
        //Update the frame of the glass
        if(panGestureRecognizer.isEnabled) {
            let glassY = indicatorView.frame.origin.y - 10 - self.frame.size.height
            if(animated) {
                UIView.animate(withDuration: 0.25,delay: 0,options: UIViewAnimationOptions.curveEaseInOut,animations: { () -> Void in self.glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
                    self.indicatorView.alpha = 1}, completion: nil)}else {
                glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
                self.indicatorView.alpha = 1}
            refreshImage()}else {if(animated) {
            UIView.animate(withDuration: 0.25,delay: 0,options: UIViewAnimationOptions.curveEaseInOut,animations: { () -> Void in self.glassView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
                self.indicatorView.alpha = 0}, completion: nil)
        }else {glassView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            self.indicatorView.alpha = 0
            }
        }
        refreshImage()
        
        //Update the shadow of the view
        let shadowPath = UIBezierPath(roundedRect: magnifyingImageView.frame, cornerRadius: cornerRadius)
        shadowLayer.shadowPath = shadowPath.cgPath
    }
    
    
    fileprivate func refreshImage() {
        
        //Since we are scaling the image, we can take a snapshot of a smaller image instead, thus increasing performance
        let newWidth = self.frame.size.width / scale
        let newHeight = self.frame.size.height / scale
        let newX = (self.frame.size.width - newWidth) / 2 + self.frame.origin.x
        let newY = (self.frame.size.height - newHeight) / 2 + self.frame.origin.y
        var newImage = snapshotTargetView(view: targetView, inRect: CGRect(x: newX, y: newY, width: newWidth, height: newHeight))
        newImage = resizeImage(image: newImage!, toNewSize: self.frame.size)
        magnifyingImageView.image = newImage
    }
    
    //Hit Test
    fileprivate func distanceFromPoint(point1: CGPoint, toPoint point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x;let dy = point1.y - point2.y
        return sqrt(dx*dx + dy*dy)
    }
    
    class func setTargetView(targetView: UIView){
        MagnifyingGlassView.sharedInstance.targetView = targetView
    }
    
    class func setScale(scale: CGFloat){
        MagnifyingGlassView.sharedInstance.scale = scale
    }
    
    class func allowDragging(allowDragging: Bool, animated: Bool) {
        MagnifyingGlassView.sharedInstance.panGestureRecognizer.isEnabled = allowDragging
        MagnifyingGlassView.sharedInstance.layoutSubviews(animated: animated)
    }
    
    class func setContentFrame(frame: CGRect) {
        var correctedFrame = frame
        var width = frame.size.width
        var height = frame.size.height
        if(width != height) {
            width = min(width, height)
            height = width
            correctedFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
        }
        MagnifyingGlassView.sharedInstance.frame = correctedFrame
    }
    
    class func setIndicatorColor(color: UIColor) {
        MagnifyingGlassView.sharedInstance.indicatorView.layer.borderColor = color.cgColor
    }
    
    class func setShadowColor(color: UIColor) {
        MagnifyingGlassView.sharedInstance.shadowLayer.shadowColor = color.cgColor
    }
    
    class func show(animated: Bool) {
        MagnifyingGlassView.sharedInstance.layoutSubviews(animated: false)
        MagnifyingGlassView.sharedInstance.targetView.addSubview(MagnifyingGlassView.sharedInstance)
        if(animated) {
            MagnifyingGlassView.sharedInstance.alpha = 0
            UIView.animate(withDuration: 0.25,delay: 0,options: UIViewAnimationOptions.curveEaseInOut,animations: { () -> Void in
                MagnifyingGlassView.sharedInstance.alpha = 1
            }, completion: nil)
        }
    }
    
    class func dismiss(animated: Bool) {
        UIView.animate(withDuration: 0.25,delay: 0,options: UIViewAnimationOptions.curveEaseInOut,animations: { () -> Void in
            MagnifyingGlassView.sharedInstance.alpha = 0
        }) { (completed) -> Void in
            MagnifyingGlassView.sharedInstance.removeFromSuperview()
        }
    }
    
}//MagnifyingGlassView class over line

//custom functions selectors
extension MagnifyingGlassView{
    @objc fileprivate func panAction(sender: UIPanGestureRecognizer) {
        switch (sender.state){
        case UIGestureRecognizerState.began:
            break
        case UIGestureRecognizerState.changed:
            let translation = sender.translation(in: targetView)
            moveView(translation: translation)
            sender.setTranslation(CGPoint.zero, in: targetView)
            break
        case UIGestureRecognizerState.ended,
             UIGestureRecognizerState.failed:
            sender.setTranslation(CGPoint.zero, in: targetView)
            break
        default:
            break
        }
    }
}
