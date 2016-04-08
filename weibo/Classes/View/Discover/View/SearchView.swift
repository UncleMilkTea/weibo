//
//  SearchView.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    //右边缘约束
    @IBOutlet weak var rigthEdge: NSLayoutConstraint!
    
    //取消按钮
    @IBOutlet weak var cancelBtn: UIButton!
    
   //搜索框
    @IBOutlet weak var searchFiled: UITextField!
    
    //创建一个可以快速创建的类方法
    class func searchView() ->SearchView {
        
        return NSBundle.mainBundle().loadNibNamed("Search", owner: nil, options: nil).last! as! SearchView

    }
    
    @IBAction func searchFiledBeginEdit(sender: AnyObject) {
        //调整右边缘
        rigthEdge.constant = cancelBtn.frame.width
        //动画
        UIView.animateWithDuration(0.3) { () -> Void in
            
            self.searchFiled.layoutIfNeeded()
        }
        
        
    }
    @IBAction func clickCancelButton(sender: AnyObject) {
        //调整右边缘
        rigthEdge.constant = 0
        //取消第一响应者
        searchFiled.resignFirstResponder()
        //动画
        UIView.animateWithDuration(0.3) { () -> Void in
            
            self.searchFiled.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        
        leftView.frame.size = CGSize(width: self.frame.height, height: self.frame.height)
        
        searchFiled.leftView = leftView
        
        searchFiled.leftViewMode = .Always
        
    }
    
    
    
    //懒加载搜索图片
    private lazy var leftView :UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "searchbar_textfield_search_icon"))
        
        imageView.contentMode = .Center
        
        return imageView
    
    }()
    
    
    
    
}
