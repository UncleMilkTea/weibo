
//
//  Status.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class Status: NSObject {
    /// 微博id,iphone 5 是32位系统,ID范围超过int32位系统
    var id:Int64 = 0
    /// 微博内容
    var text: String?
    /// 微博来源
    var source :String?
    /// 微博用户信息
    var user :UserInfo?
    /// 转发数量
    var reposts_count: Int = 0
    /// 评论数量
    var comments_count: Int = 0
    /// 点赞数量
    var attitudes_count: Int = 0
    /// 转发微博
    var retweeted_status: Status?
    /// 微博配图
    var pic_urls = [StatusPicturerInfo]()
    /// 微博创建时间
    var createdDate:NSDate?
    /// 微博发表时间
    var created_at :String?{
        didSet{
            createdDate = NSDate.sinaDateWithString(created_at)
        }
    }

    init(dic:[String:AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "user" {
            
            guard let v =  value as? [String:AnyObject] else{
                
                return
            }
            user = UserInfo(dict: v)
            /**
            *  转发微博
            */
        }else if key == "retweeted_status"{
            
            guard let v = value as? [String: AnyObject] else {
                return
            }
            retweeted_status = Status(dic: v)
            /**
            *  原创微博配图
            */
        }else if key == "pic_urls"{
            
            var tempArray = [StatusPicturerInfo]()
            
            guard let values = value as? [[String:AnyObject]] else{
                
                return
            }
            
            for v in values {
                
            tempArray.append(StatusPicturerInfo(dic: v))
            }
            pic_urls = tempArray
            
        }else{
                
              super.setValue(value, forKey: key)
            }
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
