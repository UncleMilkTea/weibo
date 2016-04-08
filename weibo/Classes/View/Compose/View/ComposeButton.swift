//
//  ComposeButton.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/9.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class ComposeButton: UIButton {
    
    var menuInf:ComposeMenuInfo? {
        
        didSet{
            setImage(UIImage(named: menuInf!.icon!), forState: .Normal)
            
            setTitle(menuInf!.title, forState: .Normal)
            
        }
    }
    
    
    /// 重写按钮高亮效果
    override var highlighted:Bool{
        get{
        return false
        }set{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        // 文字居中
        titleLabel?.textAlignment = .Center
        // 文字颜色
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        // 文字大小
        titleLabel?.font = UIFont.systemFontOfSize(16)
        // 让图片原样显示
        imageView?.contentMode = .Center
    }
    /**
    布局子控件
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame.size = CGSize(width: self.frame.width, height: self.frame.width)
        imageView?.frame.origin = CGPointZero
        
        titleLabel?.frame = CGRect(x: 0, y: self.frame.width, width: self.frame.width, height: self.frame.height-self.frame.width)
    }
}
