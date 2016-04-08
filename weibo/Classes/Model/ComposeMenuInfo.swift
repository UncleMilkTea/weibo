//
//  ComposeMenuInfo.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/9.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class ComposeMenuInfo: NSObject {

    var icon: String?
    
    var title: String?
    
    var targetVc: String?
    
    init(dic:[String:AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dic)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
}
