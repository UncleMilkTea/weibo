//
//  ComposeView.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/9.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import pop

class ComposeView: UIView {
    
    var target : UIViewController?
    
    /// 存放按钮的数组
    var btnArray:[ComposeButton] = [ComposeButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
    
    backgroundColor = RANDOMCOLOR
        
    frame = UIScreen.mainScreen().bounds
    /// 磨砂的背景图
    let backImage = UIImageView(image:(getScreenShot().applyLightEffect()))

        addSubview(backImage); addSubview(sloganView)
        
        // 添加约束
        sloganView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(100)
        }
        addChildButton()
    }
    
    /**
    给界面添加子控件按钮
    */
    func addChildButton(){
        
        let btnW:CGFloat = 80 , btnH:CGFloat = 110 , margin = (SCREENW - 3*btnW)/4
        
        let arr = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("compose.plist",
            ofType: nil)!)!
    
        var composeInfo = [ComposeMenuInfo]()
        
        for dic in arr {

            let info = ComposeMenuInfo(dic: (dic as! [String:AnyObject]))
            
            composeInfo.append(info)
        }
        
        for (i,value) in composeInfo.enumerate(){
            
            let btn = ComposeButton()
            
            //添加按钮的点击事件
            btn.addTarget(self, action: "composeClickBtn:", forControlEvents: .TouchUpInside)
            
            btn.tag = i; btn.menuInf = value; addSubview(btn)
            
            btnArray.append(btn)
            /// 行和列
            let col = CGFloat(i % 3), row = CGFloat(i / 3) ,
            
            btnX = btnW * col + (col + 1) * margin,
            
            btnY = row * (margin + btnH) + SCREENH
            
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
        }
    }
    
    @objc private func composeClickBtn(btn:ComposeButton){
        
        UIView.animateWithDuration(1, animations: { () -> Void in
                for value in self.btnArray{
                    
                value.alpha = 0
                
                value.transform = value == btn ? CGAffineTransformMakeScale(2, 2) : CGAffineTransformMakeScale(0.02, 0.02)
                }
            }, completion: { (_) -> Void in
                /**
                *  要想显示莫大界面的时候一定要在点击+按钮的时候将当前控制器Main传进来
                */
                let targetVc = NSClassFromString(btn.menuInf!.targetVc!) as! UIViewController.Type
                
            self.target?.presentViewController(HYKNavigationController(rootViewController: targetVc.init()), animated: true, completion: { () -> Void in
                    
                    self.removeFromSuperview()
            })
        })
    }
    
    //定义一个展示控制器的方法
    func show(target:UIViewController){
        
        self.target = target
        
        target.view.addSubview(self)
    }
    
    
    /**
    当要加载到父类控件上的时候执行动画
    */
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        buttonComeback(true)
    }
    /**
    获取截图
    */
     func getScreenShot()->UIImage{
        
        let rect = UIScreen.mainScreen().bounds
        let window = UIApplication.sharedApplication().keyWindow!
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        //将图形上下文渲染到上下文中
        window.drawViewHierarchyInRect(rect, afterScreenUpdates: false)
        //获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回图片
        return image
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        buttonComeback(false)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
                self.removeFromSuperview()
        }
    }
    
    
    //点击加号按钮弹出按钮动画方法
    private func buttonComeback(isOn:Bool){
        
        let array = isOn ? btnArray : btnArray.reverse()
        
        for(index,value) in array.enumerate(){
            
            let animation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
            
            animation.toValue = NSValue(CGPoint: CGPoint(x: value.center.x, y: value.center.y+(isOn ? -330 : 330)))
            
            animation.springBounciness = 10
            
            animation.springSpeed = 10
            
            animation.beginTime = CACurrentMediaTime() + Double(index)*0.01
            
            value.pop_addAnimation(animation, forKey: nil)
        }
    }
    /// 懒加载广告
    private lazy var sloganView:UIImageView = UIImageView(image: (UIImage(named: "compose_slogan")))

}
