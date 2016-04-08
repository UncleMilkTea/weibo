//
//  LoadView.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/3.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol VisitorViewDelegate :NSObjectProtocol{
    
    optional func visitorView(visitorView:VisitorView,loginDidClickButton: UIButton);
}

class VisitorView: UIView {

   weak var delegate:VisitorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        startAnimation()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setPage(imageName:String?, title:String?){
        
        if imageName == nil{
            
            startAnimation()
            
        }else{
            
            circleView.hidden = true
            
            iconView.image = UIImage(named: imageName!)
            
            messageLabel.text = title
            
        }
    }
    //开启旋转画核心动画
    func startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        
        anim.repeatCount = MAXFLOAT
        
        anim.duration = 20
        
        anim.removedOnCompletion = false
        
        //添加动画
        circleView.layer.addAnimation(anim, forKey: nil)
    }
    
    
  @objc private func loginClickBtn(btn:UIButton){
        
        delegate?.visitorView?(self, loginDidClickButton: btn)
        
    }
    //MARK: - 懒加载

    //大图
    private lazy var iconView:UIImageView = UIImageView(image:UIImage(named: "visitordiscover_feed_image_house"))
    //圆圈
    private lazy var circleView:UIImageView = UIImageView(image:UIImage(named: "visitordiscover_feed_image_smallicon"))
    //文字
    private lazy var messageLabel:UILabel = {
        
     let label = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 14)
        
        label.numberOfLines = 2
        
        label.textAlignment = .Center
        
        label.text = "关注一些人,看看有什么惊喜"
       
        return label
    }()
    
    //注册按钮
    private lazy var redistBtn:UIButton = {
        
        let btn = UIButton(textColor: UIColor.darkGrayColor(), fontSize: 14)
        
        btn.addTarget(self, action:"loginClickBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setTitle("注册", forState: .Normal)
        
        btn.setBackgroundImage(UIImage(named: "common_button_white"), forState: .Normal)
       
        return btn
    }()
    
    //登录按钮
    private lazy var loginBtn:UIButton = {
        
        let btn = UIButton(textColor: UIColor.darkGrayColor(), fontSize: 14)
        
        btn.addTarget(self, action:"loginClickBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setTitle("登录", forState: .Normal)
        
        btn.setBackgroundImage(UIImage(named: "common_button_white"), forState: .Normal)
        
        return btn
        }()

    //遮罩层
    private lazy var maskerView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
}

extension VisitorView {
   //第三方框架约束
    private func setupUI(){
        
        backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        //MARK: - 添加子控件
        addSubview(circleView)
        
        addSubview(maskerView)
        
        addSubview(iconView)
        
        addSubview(messageLabel)
        
        addSubview(redistBtn)
        
        addSubview(loginBtn)
        
        //MARK: - 开始设置约束
        
        //首页房子(居中)

        iconView.snp_makeConstraints { (make) -> Void in
            
//            make.centerX.equalTo(self.snp_centerX)
            
//            make.centerY.equalTo(self.snp_centerY)
            
            make.center.equalTo(self)
            
        }
        //圆圈(参照首页居中)
        
        circleView.snp_makeConstraints { (make) -> Void in
            
//            make.centerX.equalTo(iconView.snp_centerX)
//            make.centerY.equalTo(iconView.snp_centerY)
            
            make.center.equalTo(iconView)
        }
        //文字(x居中,宽度,上边距)
        
        messageLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(iconView)
            
            make.top.equalTo(circleView.snp_bottom)
            
            make.width.equalTo(224)
        }
        
        //注册按钮(上,宽,头对齐)
        
        redistBtn.snp_makeConstraints { (make) -> Void in
            
            make.leading.equalTo(messageLabel)
            
            make.width.equalTo(100)
            
            make.top.equalTo(messageLabel.snp_bottom).offset(16)
            
        }
        
        
        //登录按钮(上,宽度,和消息头对齐)

        loginBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(redistBtn)
            
            make.width.equalTo(100)
            
            make.trailing.equalTo(messageLabel.snp_trailing)
        }
        
        //遮罩(参照首页居中)
        
        maskerView.snp_makeConstraints { (make) -> Void in
            
//            make.centerX.equalTo(iconView.snp_centerX)
            
//            make.centerY.equalTo(iconView.snp_centerY)
            
            make.center.equalTo(iconView)
        }
        
    }
    
   //普通约束
    private func setupUI2(){
        
        backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        //MARK: - 添加子控件
        addSubview(circleView)
        
        addSubview(maskerView)
        
        addSubview(iconView)
        
        addSubview(messageLabel)
        
        addSubview(redistBtn)
        
        addSubview(loginBtn)
        
        //MARK: - 开始设置约束
        
        //首页房子
                iconView.translatesAutoresizingMaskIntoConstraints = false
        
                addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
                addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
       
        
        
//        圆圈
        
                circleView.translatesAutoresizingMaskIntoConstraints = false
        
                addConstraint(NSLayoutConstraint(item: circleView, attribute:NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal
                    , toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
                addConstraint(NSLayoutConstraint(item: circleView, attribute:NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal
                    , toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
      
        
//        文字
                messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
                //参照当前View中心对齐
                addConstraint(NSLayoutConstraint(item: messageLabel, attribute:NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal
                    , toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                //参照圆圈距顶部距离
                addConstraint(NSLayoutConstraint(item: messageLabel, attribute:NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal
                    , toItem: circleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
                //
                addConstraint(NSLayoutConstraint(item: messageLabel, attribute:NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal
                    , toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 225))
        
        
        
//        注册按钮(上,左,头对其)
                redistBtn.translatesAutoresizingMaskIntoConstraints = false
        
                addConstraint(NSLayoutConstraint(item: redistBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20))
        
                addConstraint(NSLayoutConstraint(item: redistBtn, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
                addConstraint(NSLayoutConstraint(item: redistBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        
        
        
        
        
//        登录按钮(跟注册按钮等不对齐)
        
                loginBtn.translatesAutoresizingMaskIntoConstraints = false
        
                addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20))
        
                addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        
                addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        
       
//        遮罩
                maskerView.translatesAutoresizingMaskIntoConstraints = false
        
                addConstraint(NSLayoutConstraint(item: maskerView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
                addConstraint(NSLayoutConstraint(item: maskerView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
    }
}


