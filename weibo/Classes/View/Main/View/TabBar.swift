//
//  TabBar.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class TabBar: UITabBar {

    var composeBtnBack:(()->())?
    
   override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    setUpUI()
    
    }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
  private func setUpUI(){
    
    backgroundImage = UIImage(named: "tabbar_background")
    
    addSubview(composeButton)

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let itemW = self.frame.width/5
        
        var  index = 0
        
        for value in self.subviews{
            
            if value.isKindOfClass(NSClassFromString("UITabBarButton")!){
            
                let x = CGFloat (index) * itemW
                
                value.frame.size.width = itemW
                
                value.frame.origin.x = x
            
                index++
            
                if index == 2 {
                    
                    index++
                }
            }
        }
    composeButton.center = CGPoint(x: self.center.x, y: self.bounds.height/2)
        
    }
    
    func clickComposeButton() {
        
       composeBtnBack?()
        
    }
    
    //MARK - 懒加载
    lazy var composeButton : UIButton = {
        
        let button = UIButton()
        
        button.addTarget(self, action: "clickComposeButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState:UIControlState.Normal)
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        button.setBackgroundImage (UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        
        button.setBackgroundImage (UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        button.sizeToFit()
        
       return button
    }()

}








