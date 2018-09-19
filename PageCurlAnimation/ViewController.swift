//
//  ViewController.swift
//  PageCurlAnimation
//
//  Created by wanghuiguang on 2018/9/14.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

import UIKit

class ViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView = {
       let table = UITableView.init(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height), style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return table
    }()
    
    var soundsArray:[String] = ["系统翻页动画", "系统翻页ViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let acell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        guard let cell = acell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = soundsArray[indexPath.row]
        
        return cell
    }
    
    var myViewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        for var i in 0...5 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.init(red: CGFloat(6-i)/6.0, green: CGFloat(3+i)/8.0, blue: CGFloat(15 - i)/15.0, alpha: 1)
            viewControllers.append(vc)
        }
        return viewControllers
    }()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(SystemPageCurlController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(SystemPageViewController(), animated: true)
        default:
            break
        }
    }
}

