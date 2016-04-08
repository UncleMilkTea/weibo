//
//  StatusPicturerInfo.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/8.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class StatusPicturerInfo: NSObject {

   
    var thumbnail_pic:String?
    
    init(dic:[String:AnyObject]){
        
        super.init()
        
        setValuesForKeysWithDictionary(dic)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
