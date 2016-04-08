
//
//  UIImage+Extension.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/13.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit


extension UIImage{
        ///将图片等比例缩放到指定宽度
        func scaleToWidth (width:CGFloat) -> UIImage{
        
            if self.size.width <= 600{
                
                return self
            }
            //根据传入的宽度计算出输出高度
            
            let height = width * self.size.height / self.size.width
            
            let rect = CGRect(origin: CGPointZero, size: CGSize(width: width, height: height))
            
            UIGraphicsBeginImageContext(rect.size)
            
            self.drawInRect(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return image
    }
}
