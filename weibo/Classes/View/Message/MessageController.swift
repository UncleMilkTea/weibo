//
//  MessageController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class MessageController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
        visitorView.setPage("visitordiscover_image_message", title: "别人评论你的微博，发给你的消息，都会在这里收到通知")
            
            return
        }
        
        let btn = UIButton(type: .Custom)
        btn.setTitle("好的", forState: .Normal)
        btn.backgroundColor = UIColor.redColor()
        navigationItem.titleView = btn
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "发现群", target: self, action: "findGroup")
        tabBarItem.badgeValue = "10"
    }
//        for tabBarSubView in (tabBarController?.tabBar.subviews)! {
//            // 判断是否是 UITabBarButton
//            if tabBarSubView.isKindOfClass(NSClassFromString("UITabBarButton")!) {
//                for tabBarButtonSubView in tabBarSubView.subviews {
//                    // 判断是否是 _UIBadgeView
//                    if tabBarButtonSubView.isKindOfClass(NSClassFromString("_UIBadgeView")!) {
//                        for badgeSubView in tabBarButtonSubView.subviews {
//                            if badgeSubView.isKindOfClass(NSClassFromString("_UIBadgeBackground")!) {
//                                print("终于找到你,还好没放弃")
//                                
//                                badgeSubView.setValue(UIImage(named: "main_badge"), forKey: "_image")
//                                //                                // UnsafeMutablePointer
//                                //                                var i: UInt32 = 0
//                                //
//                                //                                // 如何去获取一个未知类身上的属性
//                                //                                let ivars = class_copyIvarList(NSClassFromString("_UIBadgeBackground")!, &i)
//                                //                                for i in 0..<i {
//                                //                                    let ivar = ivars[Int(i)]
//                                //                                    let name = ivar_getName(ivar)
//                                //                                    let nameStr = String(CString: name, encoding: NSUTF8StringEncoding)
//                                //
//                                //                                    let type = ivar_getTypeEncoding(ivar)
//                                //                                    let typeStr = String(CString: type, encoding: NSUTF8StringEncoding)
//                                //                                    print("name=\(nameStr),type=\(typeStr)")
//                                //                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }


    func findGroup(){
    
    print("发现群")
    }
    
}
