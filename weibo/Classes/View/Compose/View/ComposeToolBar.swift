//
//  ComposeToolBar.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/11.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

enum ComposeToolBarType : Int{
    
    case Picture = 0, Mention, Trend, Emoticon, Add
    
}

@available(iOS 9.0, *)
class ComposeToolBar: UIStackView {
    
    //定义一个属性来切换表情键盘的图标
    var isKeyBoardSystem: Bool = true{
        didSet{
            let btn = viewWithTag(ComposeToolBarType.Emoticon.rawValue) as! UIButton
            var imageName = "compose_keyboardbutton_background"
            
            if isKeyBoardSystem {
                //系统键盘显示笑脸
                imageName = "compose_emoticonbutton_background"
            }
            btn.setImage(UIImage(named: imageName), forState: .Normal)
            btn.setImage(UIImage(named: "\(imageName)Highlighted"), forState: .Highlighted)
        }
    }
    
    
    var composeToolBarClick :((type:ComposeToolBarType)->())?

    override init(frame: CGRect) {
        super.init(frame: frame);setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        
        distribution = .FillEqually
        
        addChildButton("compose_toolbar_picture", type: .Picture)
        addChildButton("compose_mentionbutton_background", type: .Mention)
        addChildButton("compose_trendbutton_background", type: .Trend)
        addChildButton("compose_emoticonbutton_background", type: .Emoticon)
        addChildButton("compose_add_background", type: .Add)
    }
    
    private func addChildButton(imageName:String,type:ComposeToolBarType){
        
        let btn = UIButton(type: .Custom);btn.tag = type.rawValue
        
        btn.setBackgroundImage(UIImage(named: "compose_toolbar_background"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "compose_toolbar_background"), forState: .Highlighted)
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: "\(imageName)_highlighted"), forState: .Highlighted)
        btn.addTarget(self, action: "childButtonClick:", forControlEvents: .TouchUpInside)
        
        addArrangedSubview(btn)
    }
    ///按钮点击的事件
    @objc private func childButtonClick(btn:UIButton){
        
        composeToolBarClick?(type:ComposeToolBarType(rawValue: btn.tag)!)
    }
}
