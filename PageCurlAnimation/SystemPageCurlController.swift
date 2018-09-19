//
//  SystemPageCurlController.swift
//  PageCurlAnimation
//
//  Created by wanghuiguang on 2018/9/14.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

import UIKit

class SystemPageCurlController: BasicViewController, CAAnimationDelegate {
    var viewA: SYSubLayer = {
        let view = SYSubLayer()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        view.backgroundColor = UIColor.red.cgColor
        return view
    }()
    var viewB: SYSubLayer = {
        let view = SYSubLayer()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        view.backgroundColor = UIColor.yellow.cgColor
        return view
    }()
    
    var currentView: SYSubLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addColorfulView()
    }

    func addColorfulView() {
        self.view.layer.addSublayer(viewA)
        self.view.layer.addSublayer(viewB)
        self.currentView = viewB
        
        self.currentView!.addObserver(self, forKeyPath: "transform", options: [.new,.old], context: nil)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(tap:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "transform" {
            if object as! SYSubLayer == self.viewB {
                print("\(self.viewB.transform)")
            }
        }
    }
    
    @objc func tapClick(tap: UITapGestureRecognizer) {
        self.currentView?.add(self.addAnimation(), forKey: "SystemPageCurlValue")
        
//        let basicAnimation = CABasicAnimation.init(keyPath: "SubLayerTest")
//        basicAnimation.fromValue = 0
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 1.5
//        basicAnimation.isRemovedOnCompletion = false
//        basicAnimation.fillMode = kCAFillModeForwards
//        basicAnimation.delegate = self
//        basicAnimation.isRemovedOnCompletion = true
//        basicAnimation.fillMode = kCAFillModeForwards
//        self.currentView?.add(basicAnimation, forKey: "basicAnimation")
        
//        let group = CAAnimationGroup.init()
//        group.animations = [basicAnimation ,self.addAnimation()]
//        group.duration = 1.5
//        group.isRemovedOnCompletion = false
//        group.fillMode = kCAFillModeForwards
//        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        self.currentView?.add(group, forKey: "gourpAnimation")
    }
    
    func addAnimation() -> CATransition {
         let tran = CATransition.init()
        tran.type = "pageCurl"
        tran.subtype = kCATransitionFromLeft
        tran.duration = 1.5
        tran.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        tran.delegate = self
        
        tran.isRemovedOnCompletion = false
        tran.fillMode = kCAFillModeForwards
        
        return tran
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print("动画开始了")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            print("动画停止了")
            
            if self.currentView == self.viewA {
                self.view.layer.insertSublayer(self.viewB, above: self.viewA)
                self.currentView = self.viewB
            } else {
                self.view.layer.insertSublayer(self.viewA, above: self.viewB)
                self.currentView = self.viewA
            }
        }
    }
}

protocol sdfjl {
    var transform: CATransform3D {get}
}

@objc class SYSubLayer: CALayer, sdfjl{
    @objc var SubLayerTest:CGFloat = 0
    
    override class func needsDisplay(forKey key: String) -> Bool{
        if key == "SubLayerTest" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        print("\(self.transform)")
        let angle: CGFloat = SubLayerTest * .pi * 2
        
        ctx.addArc(center: CGPoint(x: 50, y: 50), radius: 40, startAngle: 0, endAngle: angle, clockwise: false)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(2)
        ctx.strokePath()
    }
}
