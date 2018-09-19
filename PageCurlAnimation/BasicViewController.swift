//
//  BasicViewController.swift
//  PageCurlAnimation
//
//  Created by wanghuiguang on 2018/9/14.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

import UIKit

let Screen_Width = ScreenWidth()
let Screen_Height = ScreenHeight()
let NavBar_Height: CGFloat = (UIApplication.shared.statusBarFrame.height + 40)

func ScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

func ScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

func checkCPUIsLittle() -> Bool{
    // 0111 1111 0000 0000,第一位是正负号标志,这里是0表示正数
    //大端：高地址存储小字节；小端：低地址存储小字节
    //如果是小端，那么向后移位，读取高地址即左边数值：0111 1111
    //如果是大端，那么向后移位，读取高地址即右边数值：0000 0000
    var c: Int16 = Int16(32512)
    let ch = withUnsafeMutableBytes(of: &c) { (bb) -> Int8 in
        let c = bb.load(fromByteOffset: 1, as: Int8.self)
        return c
    }
    
    return (ch == 127)
}

class BasicViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
    }
}
