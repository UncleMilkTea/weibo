//
//  UserInfo.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/7.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class UserInfo: NSObject {

    ///名称
    var screen_name: String?
    ///头像
    var profile_image_url: String?
    ///认证类型
    var verified_type: Int = -1
    ///微博会员
    var mbrank: Int = 0
    
    init(dict:[String:AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
