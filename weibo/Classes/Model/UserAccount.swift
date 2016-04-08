//
//  UserAccount.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {

    /**
    {
    "access_token": "ACCESS_TOKEN",
    "expires_in": 1234,
    "remind_in":"798114",
    "uid":"12341234"
    }
    
    */
    /**
    // 用户的id
    var uid: String?
    // 生命周期(秒数)
    var expires_in: Int = 0
    // 访问令牌
    var access_token: String?
    // 过期时间
    var remind_in: String?
    // 当前用户的昵称
    var screen_name: String?
    // 用户头像地址（大图），180×180像素
    var avatar_large: String?
    */
    
    /// 访问令牌
    var access_token :String?
    /// 过期时间
    var remind_in :String?
    /// 过期时间
    var expiresDate : NSDate?
    /// 生命周期
    var expires_in :Double = 0 {
        didSet{
            
            expiresDate = NSDate().dateByAddingTimeInterval(expires_in)
        }
    }
    /// 用户ID
    var uid :String?
    /// 当前用户的昵称
    var screen_name: String?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    //MARK: - KVC
    
    init(dict:[String : AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /**
    归档
    */
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(remind_in, forKey: "remind_in")
        
    }
    
    /**
    *  解档
    */
    
    required init?(coder aDecoder: NSCoder) {
        
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        remind_in = aDecoder.decodeObjectForKey("remind_in") as? String
        
        
    }
    
    /// 重写description方法
    override var description : String {
        
        let key = ["uid","expires_in","access_token"]
        
        return dictionaryWithValuesForKeys(key).description
    }
    

}
