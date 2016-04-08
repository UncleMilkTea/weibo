//
//  CommonTools.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

 ///切换控制器
let SwitchRootVCNotification = "SwitchRootVCNotification"

 /// 颜色设定
func RGB(r red:CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    
    return UIColor(red: red/255, green: g/255, blue: b/255, alpha: 1)
}
 /// 随机色
let RANDOMCOLOR = RGB(r: CGFloat(random()%256), g: CGFloat(random()%256), b: CGFloat(random()%256))

// 随机颜色
func RandomColor() -> UIColor {
    // arc4random()
    // random() 有个问题,每次第一次同一时刻随机出来的值都是一样的
    return RGB(r: CGFloat(arc4random()%256), g: CGFloat(arc4random()%256), b: CGFloat(arc4random()%256))
}
 /// 屏幕的宽
let SCREENW = UIScreen.mainScreen().bounds.width
 /// 屏幕的高
let SCREENH = UIScreen.mainScreen().bounds.height

///删除按钮点击通知
let KeyboardDelDidSelectedNotification = "KeyboardDelDidSelectedNotification"