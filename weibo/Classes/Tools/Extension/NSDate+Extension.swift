//
//  NSDate+Extension.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/9.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func sinaDateWithString(dateString: String?)-> NSDate?{
    
        guard let s = dateString else{
            return nil
        }
        
        let fm = NSDateFormatter()
        
        fm.dateFormat = "EEE MMM dd HH:mm:ss z yyyy"
        fm.locale = NSLocale(localeIdentifier: "en")
        
        return fm.dateFromString(s)
    }
    
    var dateDescription:String?{
        
        let fm = NSDateFormatter()
        
        fm.locale = NSLocale(localeIdentifier: "en")
        
        let calender = NSCalendar.currentCalendar()
        
        if isDateInThisYear(self){
            
            if calender.isDateInToday(self){
                
                let result = -self.timeIntervalSinceNow
                
                if result < 60{
                
                    return "刚刚"
                }else if result < 3600{
                    return "\(Int(result/60))分钟前"
                }else{
                
                return "\(Int(result/3600))小时前"
                }
            }else if calender.isDateInYesterday(self){
                
                fm.dateFormat = "昨天 HH:mm"
                
                return  fm.stringFromDate(self)
            }else{
            
            fm.dateFormat = "MM-dd HH:mm"
                
                return fm.stringFromDate(self)
            }
        }else{
            
            fm.dateFormat = "yyyy-MM-dd"
            
            return fm.stringFromDate(self)
        }
    }
    
    func isDateInThisYear(target:NSDate)->Bool{
        //因为我们只需要判断是否是今年,所以我们只需要将年份的字符串给格式化出来进行对比就可以了
        let currentDate = NSDate()
        
        let fm = NSDateFormatter()
        
        fm.dateFormat = "yyyy"
        
        let currentYearStr = fm.stringFromDate(currentDate)
        
        let targetYearStr = fm.stringFromDate(target)
        
        return currentYearStr == targetYearStr
        
    }
    
    
    
    
    
}
