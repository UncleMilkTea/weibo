//
//  HomeToolBar.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/7.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HomeToolBar: UIView {

    private var retweet: UIButton!
    private var comment: UIButton!
    private var unlike: UIButton!
    
    var statusViewModel:StatusViewModel?{
    
        didSet{
           retweet.setTitle(statusViewModel?.repostsCountStr, forState: UIControlState.Normal)
            comment.setTitle(statusViewModel?.commentsCountStr, forState: UIControlState.Normal)
            unlike.setTitle(statusViewModel?.attitudesCountStr, forState: UIControlState.Normal)
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
        
        retweet =  addChildren("timeline_icon_retweet", title: "转发")
        comment = addChildren("timeline_icon_comment", title: "评论")
        unlike = addChildren("timeline_icon_unlike", title: "赞")
        let line1 = addSpliteView(),line2 = addSpliteView()
        
        retweet.snp_makeConstraints { (make) -> Void in
            make.top.leading.bottom.equalTo(self)
            make.width.equalTo(comment)
        }
        comment.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(retweet)
            make.leading.equalTo(retweet.snp_trailing)
            make.width.equalTo(unlike)
        }
        unlike.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(self)
            make.leading.equalTo(comment.snp_trailing)
            make.top.bottom.equalTo(comment)
        }
        line1.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(retweet.snp_trailing)
            make.centerY.equalTo(self)
        }
        line2.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(comment.snp_trailing)
            make.centerY.equalTo(self)
        }
    }
    
    private func addSpliteView()->UIView{
        
        let imageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
        
        addSubview(imageView)
        
        return imageView
    }
    
    private func addChildren(imageName:String,title:String)->UIButton{
        
        let button:UIButton = UIButton(textColor: UIColor.grayColor(), fontSize: 12)
        
        button.setTitle(title, forState: .Normal)
        
        button.setImage(UIImage(named: imageName), forState: .Normal)
        
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), forState: UIControlState.Highlighted)
    
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        
        addSubview(button)
        
        return button
    }
}
