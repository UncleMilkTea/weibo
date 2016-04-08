//
//  HYKNetWorkingTools.swift
//  ASN Swift封装
//
//  Created by 侯玉昆 on 16/3/5.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import AFNetworking

enum HYKRequestMethod: String {
    
    case GET = "GET"
    
    case POST = "POST"
    
}
//MARK: - 基本数据请求
class HYKNetWorkingTools: AFHTTPSessionManager {
    
    typealias HYKRequestCallBack = (responseObject:[String:AnyObject]?,error: NSError?)->()
    
  //单例对象方法
    static let sharedTools :HYKNetWorkingTools = {
       
        let tools = HYKNetWorkingTools()
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
        
    }()
    
    
    /**
    *  请求数据的方法
    */
    func request(method: HYKRequestMethod? = .GET,urlString: String, parameters: AnyObject?, callBack: HYKRequestCallBack){
        
        let success = { (dataTask: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            guard let responseDict = responseObject as?
                [String : AnyObject] else{
                    
               callBack(responseObject: nil, error: NSError(domain: "com.houyukun", code: 1001, userInfo: ["message":"返回的数据不是字典"]))
                    
                    return
            }
            
            callBack(responseObject: responseDict, error: nil)
        }
        
        let failure = {(dataTasks:NSURLSessionDataTask?, error:NSError)in
            
            callBack(responseObject: nil, error: error)
            
        }
        
        if method == .GET {
            
            self.GET(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        }else {
            
                self.POST(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
//MARK: - 发送微博的方法
extension HYKNetWorkingTools{
    ///发送图片微博
    func pubilcPicture(status:String,image:UIImage,callback:HYKRequestCallBack){
        
        guard let accessToken = UserAccountViewModel.sharedAccountViewModel.accessToken else{
            
            callback(responseObject: nil, error: NSError(domain: "com.houyukun", code: 1002, userInfo: ["errormag":"accesstoken为nil"]))
            
            return
        }
        
        let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json"
        
        let parameters = [
            "access_token" :accessToken,
            "status": status
        ]
        POST(urlStr, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
            
            let data = UIImagePNGRepresentation(image)!
            /**
            - 参数1:name -> 接口里面对应该文件的字段
            - 参数2:fileName ->
            - 参数3:mimeType --> 告诉后台我要传给你的文件是什么类型的
            - 大类型/小类型
            - image/png text/html text/json
            - 如果不知道是什么类型的话: application/octet-stream
            */
            formData.appendPartWithFileData(data, name: "pic", fileName: "asda", mimeType: "application/octet-stream")
            
            },progress: nil, success: { (_, responseObject) -> Void in
                
                guard let dic = responseObject as? [String:AnyObject] else{
                    
                    callback(responseObject: nil, error: NSError(domain: "com.houyukun", code: 1001, userInfo: ["message":"返回的数据不是字典"]))
                    return
                }
                callback(responseObject: dic, error: nil)
                
            }) { (_, error) -> Void in
                
                callback(responseObject: nil, error: error)
                
        }
    }
    ///发送文字微博
    func pubilcText(status:String, callback:HYKRequestCallBack){
        
        guard let accessToken = UserAccountViewModel.sharedAccountViewModel.accessToken else{
            
            callback(responseObject: nil, error: NSError(domain: "com.houyukun", code: 1002, userInfo: ["errormag":"accesstoken为nil"]))
            
            return
        }
        
        let urlStr = "https://upload.api.weibo.com/2/statuses/upldate.json"
        
        let parameters = [
            "access_token" :accessToken,
            "status": status
        ]
        request(.POST, urlString: urlStr, parameters: parameters , callBack: callback)
    }
}

//MARK: - accesstoken请求
extension HYKNetWorkingTools{
    
    /// 载入账户信息
    func loadAccessToken(code:String ,finish:HYKRequestCallBack){
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        //创建一个参数字典
        let parameters = [
            
            "client_id": WB_APPKEY,
            "client_secret": WB_REDIRECT_Secret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri":WB_REDIRECT_URI
        ]
        
        request(urlString: urlStr, parameters: parameters, callBack: finish)
        
    }
    /// 请求用户信息
    func loadUserInfo(uid: String, accessToken: String, finished: HYKRequestCallBack) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        // 定义参数
        let params = [
            "uid": uid,
            "access_token": accessToken
        ]
        request(urlString: urlString, parameters: params, callBack: finished)
    }
}

//MARK: - 微博首页数据请求
extension HYKNetWorkingTools{
    
    func loadStatus(accessToken: String, sinceId: Int64 = 0, maxId: Int64 = 0, finished: HYKRequestCallBack) {
        // 请求地址
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        // 请求参数
        let params = [
            "access_token": accessToken,
            "since_id": "\(sinceId)",
            "max_id": "\(maxId)"
        ]
        request(.GET, urlString: urlString, parameters: params, callBack: finished)
    }
}
















