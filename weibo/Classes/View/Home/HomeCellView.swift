//
//  HomeCellView.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SnapKit
import YYText


let cellHeadImageMargin:CGFloat = 8

class HomeCellView: UIView {
    
    var bottomConstraint:Constraint?
    
    var statusViewModel:StatusViewModel?{
        
        didSet{
            
            if let urlStr = statusViewModel?.statsus?.user?.profile_image_url,let url = NSURL(string: urlStr){
                
                nameImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default"))
                
            }
            nameLabel.text = statusViewModel?.statsus?.user?.screen_name
            timeLabel.text = statusViewModel?.createAtText
            sourceLabel.text = statusViewModel?.sourceText
            verifiedImage.image = statusViewModel?.verifiedImage
            VIP.image = statusViewModel?.membershipImage
            contentLabel.attributedText = statusViewModel!.originalAttributedString
            
            self.bottomConstraint?.uninstall()
            
            if let picUrl = statusViewModel?.statsus?.pic_urls where picUrl.count>0{
                
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
        
        addSubview(nameImage)
        addSubview(nameLabel)
        addSubview(VIP)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(verifiedImage)
        addSubview(contentLabel)
        addSubview(originality)
                
        nameImage.snp_makeConstraints { (make) -> Void in
            make.leading.top.equalTo(cellHeadImageMargin)
            make.size.equalTo(CGSizeMake(35, 35))
        }
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameImage)
            make.leading.equalTo(nameImage.snp_trailing).offset(cellHeadImageMargin)
        }
        VIP.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel.snp_trailing).offset(cellHeadImageMargin)
            make.centerY.equalTo(nameLabel)
        }
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(nameImage)
        }
        sourceLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(timeLabel.snp_trailing).offset(cellHeadImageMargin)
            make.top.equalTo(timeLabel)
        }
        verifiedImage.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(nameImage.snp_bottom).offset(-3)
            make.centerX.equalTo(nameImage.snp_trailing).offset(-3)
        }
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(nameImage)
            make.top.equalTo(nameImage.snp_bottom).offset(cellHeadImageMargin)
            make.trailing.equalTo(self).offset(-cellHeadImageMargin)
        }
        originality.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(cellHeadImageMargin)
//            make.trailing.equalTo(self).offset(-cellHeadImageMargin)
        }
        self.snp_makeConstraints { (make) -> Void in
          self.bottomConstraint = make.bottom.equalTo(originality).offset(cellHeadImageMargin).constraint
        }
    }
    
    //头像
   private lazy var nameImage :UIImageView = UIImageView(image: UIImage(named: "avatar_default_small"))
    //认证
   private lazy var verifiedImage :UIImageView = UIImageView(image: nil)
    //名字
   private lazy var nameLabel :UILabel = {
       let name = UILabel(textColor: UIColor.blackColor(), fontSize: 16)
        
        name.text = "苏格Suger"
      return name
    }()
    //VIP
   private lazy var VIP :UIImageView = UIImageView(image: UIImage(named: "common_icon_membership_expired"))
    //时间
   private lazy var timeLabel :UILabel = {
        let time = UILabel(textColor: UIColor.orangeColor(), fontSize: 11)
        
        time.text = "刚刚"
        return time
        }()
    //来源
   private lazy var sourceLabel :UILabel = {
        let souurce = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 11)
        
        souurce.text = "来治猩猩的你"
        return souurce
        }()
    
    //内容
   private lazy var contentLabel :YYLabel = {
    
        let content = YYLabel()
    
        content.font = UIFont.systemFontOfSize(14)
    
        content.textColor = UIColor.blackColor()
    
        content.text = "十亿青年十亿兵，国耻岂待儿孙平。愿提十万虎狼旅，越马扬刀入东京。宁可大陆不长草，也要收复钓鱼岛。哪怕华夏遍地坟，也要杀光日本人。"
    
        content.numberOfLines = 0
    
//        content.preferredMaxLayoutWidth = 10
    
        return content
        }()
    
    //原创微博配图
    private lazy var originality :HomePictureView = {
        
       let origina = HomePictureView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        
        origina.backgroundColor = self.backgroundColor
        
        return origina
     }()
}
