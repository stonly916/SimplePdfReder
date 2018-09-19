//
//  SYPDFManager.swift
//  PageCurlAnimation
//
//  Created by wanghuiguang on 2018/9/19.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

import UIKit

class SYPDFManager: NSObject {
    //******** property ***********
    private var _pdfName: String?
    var pdfName: String? {
        get {
            return _pdfName
        }
        set {
            _pdfName = newValue
            self.getPdfDocument(for: _pdfName)
        }
    }
    
    var pdfBoxRect: CGRect?
    private(set) var currentImage: UIImage?
    private(set) var pdfNumbers: Int = 0
    
    private var _currentIndex: UInt = 0
    var currentIndex: UInt {
        get{
            return _currentIndex
        }
        set{
            loadPdf(index: Int(newValue))
        }
    }
    
    private var pdfDucoment: CGPDFDocument?
    
    //******** func ***********
    init(pdfName: String?) {
        super.init()
        self.pdfName = pdfName
    }
    
    init(pdfName: String?, pdfBoxRect: CGRect) {
        super.init()
        self.pdfName = pdfName
        self.pdfBoxRect = pdfBoxRect
    }
    
    func pdfContext(for size: CGSize) -> CGContext? {
        let context = CGContext.init(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue|CGImageAlphaInfo.premultipliedLast.rawValue)
        return context
    }
    
    @discardableResult func getPdfDocument(for fileName: String?) -> CGPDFDocument? {
        if fileName == pdfName, pdfDucoment != nil {
            return pdfDucoment
        }
        
        guard let fileName = fileName else {return nil}
        
        let acfUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), fileName as CFString, nil, nil)
        guard let cfUrl = acfUrl else {return nil}
        
        let document = CGPDFDocument(cfUrl)
        pdfNumbers = document?.numberOfPages ?? 0
        pdfDucoment = document
        
        return document
    }
    
    func resetRect(rect: CGRect) -> CGSize {
        let width = Int(rect.width)
        let height = Int(rect.height)
        return CGSize(width: width, height: height)
    }
    
    func getTransform(for innerRect: CGRect, outerRect: CGRect) -> CGAffineTransform {
        let scaleA = outerRect.width/innerRect.width
        let scaleB = outerRect.height/innerRect.height
        let scaleFactor = scaleA < scaleB ? scaleA:scaleB
        
        let scale = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
        let scaledInnerRect = innerRect.applying(scale)
        
        let translation = CGAffineTransform.init(translationX: (outerRect.width - scaledInnerRect.width) / 2 + outerRect.minX, y: (outerRect.height - scaledInnerRect.height) / 2 + outerRect.minY)
        return scale.concatenating(translation)
    }
    
    @discardableResult func loadPdf(index: Int) -> UIImage? {
        if pdfDucoment == nil || pdfNumbers == 0 {
            _currentIndex = 0
            self.currentImage = nil
            return nil
        }
        
        if index <= 0 || index > pdfNumbers {return nil}
        
        _currentIndex = UInt(index)
        let size = self.resetRect(rect: self.pdfBoxRect!)
        let apage = self.pdfDucoment!.page(at: index)
        let acontext = pdfContext(for: size)
        guard let page = apage, let context = acontext else {return nil}
        
        //        context.concatenate(self.getTransform(for: page.getBoxRect(.mediaBox), outerRect: context.boundingBoxOfClipPath))
        context.concatenate(page.getDrawingTransform(.mediaBox, rect: context.boundingBoxOfClipPath, rotate: 0, preserveAspectRatio: true))
        
        context.drawPDFPage(page)
        let imageRef = context.makeImage()
        guard let cgImage = imageRef else {return nil}
        let image = UIImage(cgImage: cgImage)
        self.currentImage = image
        return image
    }
    
    @discardableResult func loadPdf(withPath pdfName: String, index: Int) -> UIImage? {
        self.pdfName = pdfName
        return self.loadPdf(index: index)
    }
    
    func loadImageBefore() -> UIImage? {
        return self.loadPdf(index: Int(self.currentIndex - 1))
    }
    
    func loadImageAfter() ->UIImage? {
        return self.loadPdf(index: Int(self.currentIndex + 1))
    }
}
