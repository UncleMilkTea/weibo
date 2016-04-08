//
//  StatusDAL.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

//最大混存的秒数

private let MaxCacheTimeinterval: Double = 60 * 60 * 24 * 7

class StatusDAL: NSObject {
    
    //加载数据
    class func loadData (maxId: Int64,sinceId:Int64,completion:(statusDic:[[String:AnyObject]]?)->()){
        
        //先从本地读取
        let localData = checkCacheData(maxId, sinceId: sinceId)
        
        if localData?.count > 0 {
            
            completion(statusDic: localData); return
        }
        
        //如果没有数据就从网络加载
        
        HYKNetWorkingTools.sharedTools.loadStatus(UserAccountViewModel.sharedAccountViewModel.accessToken!, sinceId: sinceId, maxId: maxId) { (responseObject, error) -> () in
            
            if error != nil {
                
                print("加载失败\(error)")
                
                completion(statusDic: nil)
            }
            //加载成功
            
            guard let statusesDict = responseObject?["statuses"] as? [[String : AnyObject]] else{
                return
            }
            // 把请求回来的数据缓存到本地
            StatusDAL.cacheData(statusesDict)
            
        }
    }
    //读取本地保存到数据库的数据
    class func checkCacheData(maxId:Int64,sinceId:Int64)->[[String:AnyObject]]? {
        
        /**
        SELECT statusid,status,userid FROM T_Status
        -- WHERE statusid <= 3952581602669710
        WHERE statusid > 3952581602669710
        AND userid = 5568397831
        ORDER BY statusid DESC
        LIMIT 20
        
        */
        guard let userid = UserAccountViewModel.sharedAccountViewModel.account?.uid else{
            
            print("没有userid"); return nil
            
        }
        
        // 1. 准备sql
        var sql = "SELECT statusid,status,userid FROM T_Status\n"
        
        if maxId > 0 {
            sql += "WHERE statusid <= \(maxId)\n"
        }else{
            sql += "WHERE statusid > \(sinceId)\n"
        }
        // 拼接指定用户的条件
        sql += "AND userid = \(userid)\n"
        // 排序
        sql += "ORDER BY statusid DESC\n"
        // 查询条数
        sql += "LIMIT 20\n"
        print(sql)
        
        //执行查询操作
        let resultSet = SQLiteManager.sharedManager.excRecordSet(sql)
        
        var result = [[String :AnyObject]]()
        
        for dic in resultSet {
            
            let statusDic = try! NSJSONSerialization.JSONObjectWithData(dic["status"]! as! NSData, options: [] ) as! [String : AnyObject]
            
            result.append(statusDic)
        }
        return result
    }
   /// 缓存网络加载的数据到本地
    class func cacheData(statuses:[[String:AnyObject]]) {
        
        guard let userid = UserAccountViewModel.sharedAccountViewModel.account?.uid else{
            
            return
        }
        
        let sql = "INSERT OR REPLACE INTO T_Status (statusid, status, userid) VALUES (?, ?, ?)"
        
        SQLiteManager.sharedManager.queue?.inTransaction({ (db,rollback) -> Void in
            
            for dic in statuses{
                
                let statusid = dic["id"]
                
                let status = try! NSJSONSerialization.dataWithJSONObject(dic, options: [])
                
                let result = db.executeUpdate(sql,withArgumentsInArray: [statusid!,status,userid])
                
                if result == false{
                    
                    // 代表插入某一条数据的时候，失败，需要回滚
                    rollback.memory = true
                    
                    break
                }
            }
        })
    }
    
    /// 清除缓存
    class func clearCache() {
        
        // 要清除距离当前时间7天的时间
        let date = NSDate(timeIntervalSinceNow: -MaxCacheTimeinterval)
        
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en_US")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 7天的前的时间字符串
        let dateString = df.stringFromDate(date)
        // 1. 准备sql
        let sql = "DELETE FROM T_Status WHERE createtime < '\(dateString)';"
        
        
        // 2. 执行sql
        SQLiteManager.sharedManager.queue?.inDatabase({ (db) -> Void in
            
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
                print("清除缓存成功")
            }else{
                print("清除缓存失败")
            }
        })
    }
}
