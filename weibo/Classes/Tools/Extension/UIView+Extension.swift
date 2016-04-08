
//
//  UIView+Extension.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

extension UIView{
    //边线宽度
 @IBInspectable var borderWidth : CGFloat{
        
        get{
            return layer.borderWidth
    }set{
        layer.borderWidth = newValue
    }
  }
    //边线颜色
    @IBInspectable var borderColor : UIColor?{
        get{
            guard let color = layer.borderColor else{
                
                return nil
            }
            return UIColor(CGColor: color)
        }set{
            
            layer.borderColor = newValue?.CGColor
        }
    }
    //控件圆角
    @IBInspectable var cornerRadius : CGFloat{
        get{

            return layer.cornerRadius
        }set{
            
            layer.cornerRadius = newValue
            
            layer.masksToBounds = newValue > 0
        }
    }
}