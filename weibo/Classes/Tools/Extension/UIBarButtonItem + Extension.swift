//
//  UIBarButtonItem + Extension.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(imageName: String? = nil, title: String? = nil, target: AnyObject?, action: Selector) {
        
        self.init()
        
        let button = UIButton()
        
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        if let tit = title  {
            
            button.setTitle(tit, forState: .Normal)
            
            button.setTitleColor(UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1), forState: UIControlState.Normal)
            
            button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
            
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
        }
        if let name = imageName {
            
            button.setImage(UIImage(named: name), forState: UIControlState.Normal)
            
            button.setImage(UIImage(named: "\(name)_highlighted"), forState: UIControlState.Highlighted)
        }
        button.sizeToFit()

        customView = button
    }
}
