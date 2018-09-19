//
//  SystemPageViewController.swift
//  PageCurlAnimation
//
//  Created by wanghuiguang on 2018/9/17.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

import UIKit

let fullScreenRect: CGRect = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height-NavBar_Height)

class SubViewController: UIViewController {
    var currentIndex: Int = 0
    var pageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = fullScreenRect
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(pageImageView)
    }
}

class SystemPageViewController: BasicViewController, UIPageViewControllerDataSource {
    
    var pdfManager: SYPDFManager = SYPDFManager(pdfName: "The Swift Programming Language.pdf", pdfBoxRect: fullScreenRect)
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = SubViewController()
        vc.view.frame = fullScreenRect
        
        let pageIndex = (viewController as! SubViewController).currentIndex - 1
        let aimage = pdfManager.loadPdf(index: pageIndex)
        guard let image = aimage else {return nil}
        vc.currentIndex = pageIndex
        vc.pageImageView.image = image
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = SubViewController()
        vc.view.frame = fullScreenRect
        
        let pageIndex = (viewController as! SubViewController).currentIndex + 1
        let aimage = pdfManager.loadPdf(index: pageIndex)
        guard let image = aimage else {return nil}
        vc.currentIndex = pageIndex
        vc.pageImageView.image = image
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        
        let pageController = UIPageViewController.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionSpineLocationKey:NSNumber(value: UIPageViewControllerSpineLocation.min.rawValue)])
        pageController.view.frame = fullScreenRect
        pageController.dataSource = self
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        
        let viewController = SubViewController()
        viewController.view.frame = fullScreenRect
        viewController.pageImageView.image = pdfManager.loadPdf(index: 1)
        viewController.currentIndex = 1
        pageController.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    
}
