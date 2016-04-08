//
//  RefreshControl.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/9.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
//定义刷新控件的状态
enum RefreshControlState:Int{
//正常状态
case Normal = 0,
    //下拉状态
    Pulling,
    //刷新状态
    Refresh
}

private var refreshHeight:CGFloat = 35

private var scroll: UIScrollView?

class RefreshControl: UIControl {
    
    //设置控件当前状态
    var refreshState:RefreshControlState = .Normal{
        
        didSet{
            switch refreshState {
                
            case .Normal:
                // 箭头显示,菊花隐藏
                arrowIamge.hidden = false
                indicatorView.stopAnimating()
                //  箭头调头
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.arrowIamge.transform = CGAffineTransformIdentity
                })
                //  文字改变
                label.text = "下拉刷新"
                // 判断上一次状态是刷新中状态,那么进入到Normal状态就需要去减去InsetTop
                if oldValue == .Refresh {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                    scroll?.contentInset.top -= refreshHeight
                    })
                }
            case .Pulling:
               
                // 1. 文字改变
                label.text = "松开刷新"
               
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.arrowIamge.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    })
                
            case .Refresh:
                // 0. 箭头隐藏,菊花显示
                arrowIamge.hidden = true
                
                indicatorView.startAnimating()
                
                // 1. 文字改变
                label.text = "正在刷新数据"
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    scroll?.contentInset.top += refreshHeight
                })
                //发送值改变事件
                sendActionsForControlEvents(.ValueChanged)
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
        
//        backgroundColor = UIColor.redColor()
    
        //由于没有设置frame租要手动设置
        frame = CGRectMake(0, -refreshHeight, SCREENW, refreshHeight)
//      scroll?.contentInset.top += refreshHeight
        
        addSubview(label)
        addSubview(arrowIamge)
        addSubview(indicatorView)
        
        
        arrowIamge.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self).offset(-50)
            make.centerY.equalTo(self)
        }
        indicatorView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(arrowIamge)
        }
        label.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(arrowIamge.snp_trailing).offset(cellHeadImageMargin)
            make.centerY.equalTo(arrowIamge)
        }
    }
    
    // 结束刷新要调用的方法
    func endRefreshing(){
        refreshState = .Normal
        
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let scrollView = newSuperview as? UIScrollView{
            
            //添加监听滚动
            
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.Old,.New], context: nil)
            
            scroll = scrollView
            
            frame.size.width = scrollView.frame.width
        }
    }
    //当某个对象身上的值发生改变的时候就会调用
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let contentInsetTop = scroll!.contentInset.top
        let contentOffsetY = scroll!.contentOffset.y
        let conditionValue =  -contentInsetTop - refreshHeight
        //监听用户是否在拖动
        if scroll!.dragging {
            
            if contentOffsetY <= conditionValue && refreshState == .Normal{
                
                refreshState = .Pulling
                
                print("松手刷新")
            }else if refreshState == .Pulling && contentOffsetY > conditionValue{
            
            refreshState = .Normal
            }
        }else {
            
            if refreshState == .Pulling {
                
                refreshState = .Refresh
            }
        }
    }
    deinit{
        
        scroll!.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    private lazy var arrowIamge:UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    
    private lazy var indicatorView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private lazy var label:UILabel = {
        
        let label = UILabel(textColor: UIColor.grayColor(), fontSize: 14)
        
        label.text = "正在刷新"
        
        return label
        }()
}

//监听控制器的滚动
//使用kvo来实现
//当要被移动到某个父控件上得时候调用
//析构函数用来移除监听



