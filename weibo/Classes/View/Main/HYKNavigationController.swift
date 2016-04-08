//
//  HYKNavigationController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/3.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HYKNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            // 代表当前已经存在1个控制器,正要往里面push第2个,所以去获取第1个控制器的 title
            if childViewControllers.count == 1 {
                title = childViewControllers.first?.title ?? "返回"
            }
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_back_withtext", title: "返回", target: self, action: "back")
            
            viewController.hidesBottomBarWhenPushed = true
            
        }
        super.pushViewController(viewController, animated: true)
    }
    
    func back(){
        
        popViewControllerAnimated(true)
    }
    
}
