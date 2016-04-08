//
//  UILabel + EXtension.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/3.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

//通过类扩展来实现方法的??
extension UILabel{
    
    convenience init(textColor:UIColor,fontSize:CGFloat){
        
        self.init()
        
        self.textColor = textColor
        
        self.font = UIFont.systemFontOfSize(fontSize)
    }
    
}
