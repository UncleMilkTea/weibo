
//
//  UIButton + Extension.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/3.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

extension UIButton{
    
    convenience init(textColor:UIColor, fontSize:CGFloat){
        self.init()
        
        setTitleColor(textColor, forState: .Normal)
        
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
}

