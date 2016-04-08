//
//  VisitorTableViewController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/3.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {
    
    var userLogin:Bool = UserAccountViewModel.sharedAccountViewModel.userLogin
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //判断一下用户是否登录在加载Loadview的方法里判断调用父类方法
    override func loadView() {
        
        if userLogin {
            
            super.loadView()
            
        }else{
            
            view = visitorView
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", target: self, action: "login")
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", target: self, action: "login")
        }
    }

 lazy var visitorView:VisitorView = {
    
    let v = VisitorView()
    
    v.delegate = self
    
    return v
    
    }()
    
    @objc private func login (){
    
    presentViewController(HYKNavigationController(rootViewController:OAuthController()), animated: true) { () -> Void in
        }
    }
}

extension VisitorTableViewController :VisitorViewDelegate{
    
    func visitorView(visitorView: VisitorView, loginDidClickButton: UIButton) {
        
        login()
    }
}



