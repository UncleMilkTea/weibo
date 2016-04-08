//
//  HomeRetweetView.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/7.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SnapKit
import YYText

class HomeRetweetView: UIView {
    
    var bottomConstraint:Constraint?

    var statusViewModel:StatusViewModel?{
    
    didSet{
    
//        contentLabel.text = statusViewModel?.retweetedText
        
        contentLabel.attributedText = statusViewModel!.retweetAttributedString
        
        self.bottomConstraint?.uninstall()
        
        if let picUrl = statusViewModel?.statsus?.retweeted_status?.pic_urls where picUrl.count>0{
            
            originality.picUrl = picUrl
            
            originality.hidden = false
            
            self.snp_makeConstraints(closure: { (make) -> Void in
                
                bottomConstraint = make.bottom.equalTo(originality).offset(cellHeadImageMargin).constraint
            })
            
        }else{
            
            originality.hidden = true
            
            self.snp_makeConstraints(closure: { (make) -> Void in
                
                bottomConstraint = make.bottom.equalTo(contentLabel).offset(cellHeadImageMargin).constraint
            })
          }
       }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        
        backgroundColor = UIColor(white: 246/255, alpha: 1)
        addSubview(contentLabel)
        addSubview(originality)
        
        
        contentLabel.snp_makeConstraints { (make) -> Void in
            
            make.leading.top.equalTo(self).offset(cellHeadImageMargin)
            make.trailing.equalTo(self).offset(-cellHeadImageMargin)
        }
        originality.snp_makeConstraints { (make) -> Void in
            
            make.leading.equalTo(contentLabel)
            
            make.top.equalTo(contentLabel.snp_bottom).offset(cellHeadImageMargin)
        }
        self.snp_makeConstraints { (make) -> Void in
           bottomConstraint =  make.bottom.equalTo(originality).offset(cellHeadImageMargin).constraint
           
        }
    }
    
    private lazy var contentLabel:YYLabel={
        
        let content = YYLabel()
        
        content.font = UIFont.systemFontOfSize(14)
        
        content.textColor = UIColor.blackColor()
        
        content.text = "转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转转"
        
        content.numberOfLines = 0
        
//        content.preferredMaxLayoutWidth = 2
        
        return content
    }()
    
    //转发微博配图
    private lazy var originality :HomePictureView = HomePictureView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
}
