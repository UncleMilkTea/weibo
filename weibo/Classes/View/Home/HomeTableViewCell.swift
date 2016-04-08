//
//  HomeTableViewCell.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    
    /// 原创微博
    private lazy var homeCellView:HomeCellView = HomeCellView()
    /// 底部转发评论
    private lazy var toolBarView:HomeToolBar = HomeToolBar()
    /// 转发微博视图
    private lazy var retweetView:HomeRetweetView = HomeRetweetView()
    // toolBar的顶部约束
    var toolBarTopConstraint: Constraint?
    
    var statusViewModels:StatusViewModel?{
        
        didSet{
            
            homeCellView.statusViewModel = statusViewModels
            toolBarView.statusViewModel = statusViewModels
            
            self.toolBarTopConstraint?.uninstall()
            
            if statusViewModels!.statsus!.retweeted_status != nil{
            
                self.retweetView.statusViewModel = self.statusViewModels
                
                self.retweetView.hidden = false
                
                self.toolBarView.snp_updateConstraints(closure: { (make) -> Void in
                    
                    self.toolBarTopConstraint = make.top.equalTo(self.retweetView.snp_bottom).constraint
                    
                    })
                
            }else{
                
                self.retweetView.hidden = true
                
                self.toolBarView.snp_updateConstraints(closure: { (make) -> Void in
                    
                    self.toolBarTopConstraint = make.top.equalTo(self.homeCellView.snp_bottom).constraint
                    
                })
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupUI(){
        
        selectionStyle = .None
        
        contentView.addSubview(homeCellView)
        contentView.addSubview(retweetView)
        contentView.addSubview(toolBarView)
        
        homeCellView.snp_makeConstraints { (make) -> Void in
            
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(contentView).offset(cellHeadImageMargin)
        }
        retweetView.snp_makeConstraints { (make) -> Void in
            
            make.leading.trailing.equalTo(homeCellView)            
            make.top.equalTo(homeCellView.snp_bottom)

        }
        toolBarView.snp_makeConstraints { (make) -> Void in
            
            make.leading.trailing.equalTo(homeCellView)
          self.toolBarTopConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
            make.height.equalTo(35)
        }
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(toolBarView)        }
    }
}
