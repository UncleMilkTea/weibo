//
//  HYKTabItem.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/10.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HYKTabItem: UITabBarItem {

    /**
    *  重写badgeValue方法
    */
    override var badgeValue:String?{
        // 通过查看 Xcode 6.4 可以发现一个 _target ,获取打印其类型,就是我们想要的
        didSet{
            
           let target = self.valueForKey("_target") as! UITabBarController
            
            for tabBarSubView in target.tabBar.subviews {
                
                if tabBarSubView.isKindOfClass(NSClassFromString("UITabBarButton")!){
                
                    for tabBarButtonSubView in tabBarSubView.subviews{
                        
                        if tabBarButtonSubView.isKindOfClass(NSClassFromString("_UIBadgeView")!){
                            
                            for badgeView in tabBarButtonSubView.subviews{
                                
                                if badgeView.isKindOfClass(NSClassFromString("_UIBadgeBackground")!){
                                    
                                        badgeView.setValue(UIImage(named:"main_badge" ), forKey: "_image")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
