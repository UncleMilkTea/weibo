//
//  MainViewController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tb = TabBar()
        
        setValue(tb, forKey: "tabBar")
        
        addChildViewController(HomeController(), imageName: "tabbar_home", title: "首页")
        
        addChildViewController(MessageController(), imageName: "tabbar_message_center", title: "消息")
        
        addChildViewController(DiscoverController(), imageName: "tabbar_discover", title: "发现")
        
        addChildViewController(ProfileController(), imageName: "tabbar_profile", title: "我")
        
        tb.composeBtnBack = { [weak self] in
            
            ComposeView().show(self!)

//          print("加号点击%@",self)//强引用self
            
        }
    }
    
   private func addChildViewController(childController: UIViewController,imageName: String, title: String) {
    /**
    * 自定义的TabItem需要调用
    */
        childController.tabBarItem = HYKTabItem()
        
        childController.title = title
        
        childController.tabBarItem.image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal)
        
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let attr = [NSForegroundColorAttributeName:UIColor.orangeColor()]
        
        childController.tabBarItem.setTitleTextAttributes(attr, forState:UIControlState.Selected)
    
        addChildViewController(HYKNavigationController(rootViewController: childController))
    }
}
