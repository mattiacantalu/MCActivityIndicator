//
//  ActivityIndicatorView.swift
//  MCActivityIndicator
//
//  Created by Mattia Cantalù on 01/09/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorView: UIView {
    
    let MRActivityIndicatorViewSpinAnimationKey = "MRActivityIndicatorViewSpinAnimationKey"
    
    let PROGRESS = 0.75
    
    var animating = false
    
    /**
     A float value to indicate how thick the line of the activivity indicator is.
     
     The default value is 2.f.
     */
    let lineWidth = CGFloat()
    
    /**
     A Boolean value that controls whether the receiver is hidden when the animation is stopped.
     
     If the value of this property is YES (the default), the receiver sets its hidden property (UIView) to YES when receiver
     is not animating. If the hidesWhenStopped property is NO, the receiver is not hidden when animation stops. You stop an
     animating progress indicator with the stopAnimating method.
     */
    var hidesWhenStopped = false
    
    /**
     External ShapeLayer
     */
    weak var shapeLayer = CAShapeLayer()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    //MARK: - View
    private func commonInit() {
        self.isAccessibilityElement = true
        self.accessibilityLabel = NSLocalizedString("Indeterminate Profress", comment: "Accessibility label for activity indicator view")
        
        self .setLineWidth(width: 2.0)
        self.hidesWhenStopped = true
        
        let tmpShapeLayer = CAShapeLayer()
        tmpShapeLayer.borderWidth = 0
        tmpShapeLayer.fillColor = UIColor.clear.cgColor
        self.layer .addSublayer(tmpShapeLayer)
        self.shapeLayer = tmpShapeLayer
        
        self .tintColorDidChange()
    }
    
    //MARK: - Notification
    func registerForNotification() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: Selector(("applicationDidEnterBackground")), name: NSNotification.Name.UIApplicationDidEnterBackground, object: UIApplication.shared)
        center.addObserver(self, selector: Selector(("applicationWillEnterForeground")), name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
    }
    
    func unregisterFromNotificationCenter() {
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    func applicationDidEnterBackground(note : NSNotification) {
        self.remoteAnimation()
    }
    
    func applicationWillEnterForeground(note : NSNotification) {
        if (self.isAnimating()){
            self.addAnimation()
        }
    }
    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.bounds
        if (abs(frame.size.width - frame.size.height) < CGFloat.leastNormalMagnitude) {
            // Ensure that we have a square frame
            let s = min(frame.size.width, frame.size.height)
            frame.size.width = s
            frame.size.height = s
        }

        self.shapeLayer?.frame = frame
        self.shapeLayer?.path = self.layoutPath().cgPath
        self.shapeLayer?.lineCap = "round"
        
        self.addAnimation()
    }
    
    func layoutPath() -> UIBezierPath {
        
        let mpi2 = 2.0 * M_PI
        let startAngle = 0.75 * mpi2
        let endAndle = startAngle + mpi2 * PROGRESS
        
        let width = self.bounds.size.width
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: width/2.0, y: width/2.0), radius: width/2.2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAndle), clockwise: true)
    
        return bezierPath
    }
    
    //MARK: - Hook tintColor
    override func tintColorDidChange() {
         super.tintColorDidChange()
        self.shapeLayer?.strokeColor = self.tintColor.cgColor
    }
    
    //MARK: - Line width
    func setLineWidth(width : CGFloat) {
        self.shapeLayer?.lineWidth = width
    }
    
    func getLineWidth() -> CGFloat {
        return (self.shapeLayer?.lineWidth)!
    }
    
    //MARK: - Control Animation
    func startAnimating() {
        if (self.animating){
            return
        }
        
        self.animating = true
        
        self.registerForNotification()
        
        self.addAnimation()
        
        if (self.hidesWhenStopped) {
            self.isHidden = false
        }
    }
    
    func stopAnimating() {
        if (!self.animating){
            return
        }
        
        self.animating = false
        
        self.unregisterFromNotificationCenter()
        
        self.remoteAnimation()
        
        if (self.hidesWhenStopped) {
            self.isHidden = true
        }
    }
    
    func isAnimating() -> Bool {
        return self.animating
    }

    //MARK: - Add and remove animation
    func addAnimation() {
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.toValue = 1 * 2 * M_PI
        spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        spinAnimation.duration = 1.0
        spinAnimation.repeatCount = Float.infinity
        
        self.shapeLayer?.add(spinAnimation, forKey: MRActivityIndicatorViewSpinAnimationKey)
    }
    
    func remoteAnimation() {
        self.shapeLayer?.removeAnimation(forKey: MRActivityIndicatorViewSpinAnimationKey)
    }

    //MARK: - Dealloc
    deinit {
        self.unregisterFromNotificationCenter()
    }
}
