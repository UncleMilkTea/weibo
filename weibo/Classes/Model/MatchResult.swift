//
//  MatchResult.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/16.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class MatchResult: NSObject {
    
    var captureString: NSString
    var captureRange: NSRange
    
    init(captureString: NSString, captureRange: NSRange) {
        self.captureString = captureString
        self.captureRange = captureRange
    }
}
