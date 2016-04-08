//
//  OAuthController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/5.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SVProgressHUD

 let WB_APPKEY = "2690314476"
 let WB_REDIRECT_URI = "http://www.youku.com/"
 let WB_REDIRECT_Secret = "26075c7c2640c6b51eb503c7a1c8cdc8"

class OAuthController: UIViewController {
    
    private lazy var OAuthurl:NSURL = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(WB_APPKEY)&redirect_uri=\(WB_REDIRECT_URI)")!
    
    override func loadView() {
        super.loadView()
        
        webView.loadRequest(NSURLRequest(URL: OAuthurl ))
        
        view = webView
    }
    
     override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    @objc private func setupUI(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem( title: "返回", target: self, action: "login")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem( title: "自动填充", target: self, action: "autoFill")
        
        navigationItem.title = "新浪微博"
        
    }
    
   @objc private func login(){
    
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @objc private func autoFill(){
        
        let jsStr = "document.getElementById('userId').value='';document.getElementById('passwd').value=''"
        
        webView.stringByEvaluatingJavaScriptFromString(jsStr)
    }
    
    //MARK: - 懒加载
    
    lazy var webView :UIWebView = {
        
        let webView = UIWebView()
        
        webView.delegate = self
        
        return webView
        
        }()
}

extension OAuthController:UIWebViewDelegate{
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let url = request.URL else {
            
            return true
        }
        
        let urlStr = url.absoluteString
        
        //判断网址是否正确
        if urlStr.hasPrefix(WB_REDIRECT_URI) {
            
            let code = url.query?.substringFromIndex("code=".endIndex)
            
        UserAccountViewModel.sharedAccountViewModel.loadResponseToken(code!, callback: { (isSuccess) -> () in
                
                if isSuccess {
                //执行界面跳转跳转之前要把moda先销毁了
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    print("跳转到欢迎界面,利用通知给appdelegate切换")
                    NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootVCNotification, object: self, userInfo: nil)
                })
                    
                }else{
                   
                  SVProgressHUD.showErrorWithStatus("登录失败")
                }
            })
         
            return false
        }
        return true
    }
}
