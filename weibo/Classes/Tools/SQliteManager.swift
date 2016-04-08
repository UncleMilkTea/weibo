//
//  SQliteManager.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

private let dbName = "status.db"

class SQLiteManager {
    
    //设置单例全局
    static let sharedManager: SQLiteManager = SQLiteManager()
    
    var queue: FMDatabaseQueue?
    
    private init(){
    
    let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent(dbName)
    
    print(path)
        
        //将数据库的路劲加到队列中
        queue = FMDatabaseQueue(path: path)
        
        //创建表
        createTable()
    
    }
    
    func excRecordSet(sql:String) -> [[String:AnyObject]]{
        
        var result = [[String:AnyObject]]()
        
        queue?.inDatabase({ (db) -> Void in
            
            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            
            while resultSet.next(){
                
                var dic = [String:AnyObject]()
                
                for i in 0..<resultSet.columnCount(){
                    
                    let columnName = resultSet.columnNameForIndex(i)
                    
                    let value = resultSet.objectForColumnIndex(i)
                    
                    dic[columnName] = value
                    
                }
                result.append(dic)
            }
           
        })
        return result
    }
    
    
    //创建数据表
    private func createTable(){
    
    let path = NSBundle.mainBundle().pathForResource("db.sql", ofType: nil)
        
    let sql = try! String(contentsOfFile: path!)
        
        queue?.inDatabase({ (db) -> Void in
            if db.executeStatements(sql){
                
                print("建表成功")
            }else{
            
                print("建表失败")
            }
        })
    }
}

