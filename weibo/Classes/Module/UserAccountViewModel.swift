//
//  UserAccountViewModel.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/5.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class UserAccountViewModel: NSObject{
    
    var account :UserAccount?
    
    //判断用户是否登录
    
    var userLogin:Bool {
        
        if (accessToken != nil && !self.isExpiresIn) {
            
            return true
            
        }
            return false
    }
    
    var accessToken: String?{
        
        return account?.access_token
        
    }
    
    //判断token是否过期
    var isExpiresIn:Bool{
    
        if NSDate().compare(account!.expiresDate!) == .OrderedAscending {
            return false
        }
    return true
    }
    
    //单例
   static let sharedAccountViewModel :UserAccountViewModel = {
        
        let model = UserAccountViewModel()
        
                // 获取路径
//                let file = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.archive")
//                // 去解档
//                let result = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? UserAccount
                // 赋值account.这里的不能用self调用,因为界面为加载完成无法获取到数据

    
        model.account = model.loadAccount()
        
       return model
        
    }()

     func loadResponseToken(code:String,callback:(isSuccess:Bool)->()){
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        //创建一个参数字典
        let parameters = [
            
            "client_id": WB_APPKEY,
            "client_secret": WB_REDIRECT_Secret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri":WB_REDIRECT_URI
        ]
        
        HYKNetWorkingTools.sharedTools.request(.POST, urlString: urlStr, parameters: parameters) { (responseObject, error) -> () in
            
            if error != nil {
                
                print(error)
                
                callback(isSuccess:false)
                
                return
            }
            
            let account = UserAccount.init(dict: responseObject!)
            
            self.loadUserInfo(account, callback: callback)
    }
}
    private func loadUserInfo(account:UserAccount,callback:(isSuccess:Bool)->()){
        
        let urlStr = "https://api.weibo.com/2/users/show.json"
        
        guard let uid = account.uid ,access_token = account.access_token else{
            
            callback(isSuccess: false)
            
            print("参数不够"); return
        }
        
        let parameters = [
            
            "access_token" : access_token,
            "uid" : uid
        ]
        HYKNetWorkingTools.sharedTools.request(urlString: urlStr, parameters: parameters) { (responseObject, error) -> () in
            
            if error != nil{
                
                callback(isSuccess: false)
                
                return
            }
            
            account.screen_name = responseObject!["screen_name"] as? String
            
            account.avatar_large = responseObject!["avatar_large"] as? String
            
            //归档保存用户信息
            self.saveUserInfo(account)
            
            //给当前model赋值
            self.account = account
            
            //回调闭包成功
            callback(isSuccess: true)

            }
        }

    //保存用户信息
    private func saveUserInfo(account : UserAccount){
    
    NSKeyedArchiver.archiveRootObject(account, toFile: archiveFile)
    
    }
    
    //开始归档(路径拼接)
    private let archiveFile = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.archive")
    
    // 解档
    private func loadAccount() -> UserAccount? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(archiveFile) as? UserAccount
    }
}
