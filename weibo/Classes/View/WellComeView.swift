//
//  WellComeView.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SDWebImage


class WellComeView: UIViewController {

    override func viewDidLoad() {
        
       setupUI()
        
    }
    
    private func setupUI(){
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(iconImage)
        view.addSubview(nameLabel)
        
        iconImage.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(200)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
     
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(iconImage)
            make.top.equalTo(iconImage.snp_bottom).offset(20)
        }
    }
    
    //执行动画,一定要在界面加载完成之后执行动画
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        iconImage.snp_updateConstraints(closure: { (make) -> Void in
            
             make.top.equalTo(view).offset(100)
            
            })
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                
                UIView.animateWithDuration(1, animations: { () -> Void in
                    
                    self.nameLabel.alpha = 1

                    }, completion: { (_) -> Void in
                        //执行界面跳转
                        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootVCNotification, object: self)
                })
        }
    }
    
    //MARK: - 懒加载控件
    
    private lazy var iconImage:UIImageView = {
        let image = UIImageView()
        
        image.layer.cornerRadius = 45
        image.layer.masksToBounds = true
        let headWebImage = UserAccountViewModel.sharedAccountViewModel.account?.avatar_large
        //Sd_webimage
        image.sd_setImageWithURL(NSURL(string: headWebImage!), placeholderImage:UIImage(named: "avatar_default_big"))
        
      return image
    }()
    
    private lazy var nameLabel:UILabel = {
        
        let name = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 18)
        
        name.text = "欢迎回来"
        name.sizeToFit()
        name.alpha = 0
        
        return name
    }()
}
