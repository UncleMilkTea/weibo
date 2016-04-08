//
//  StatusListViewModel.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SDWebImage

class StatusListViewModel: NSObject {

    var statusArray:[StatusViewModel]?
    
    //数据是否加载成功,并且加载了多少条
    func loadData(isPullUp:Bool ,finish: (isSucceed: Bool,count: Int)->()){
        
        var maxid :Int64 = 0
        var sinceId :Int64 = 0
        
        if isPullUp{
            
             maxid = statusArray?.last?.statsus?.id ?? 0
            //由于数据重复,需要判断最后一条数据减一个
            if maxid != 0{
                
                maxid--
            }else{
                
                sinceId = statusArray?.last?.statsus?.id ?? 0
            }
        }
//        //如果是上拉加载就去加载max_id
//        let parameters = [
//            "access_token":UserAccountViewModel.sharedAccountViewModel.accessToken!,
//            "max_id":"\(maxid)",
//            "sinceId":"\(sinceId)"
//        ]
//        
//        HYKNetWorkingTools.sharedTools.request(.GET, urlString: url, parameters: parameters) { (responseObject, error) -> () in
//            
//            if error != nil {
//                
//                finish(isSucceed: false,count: 0)
//                return
//            }
//            
//            // 取到微博字典的数据进行遍历字典转模型
//            let dict = responseObject!["statuses"] as! [[String:AnyObject]]
        
        StatusDAL.loadData(maxid, sinceId: sinceId) { (statusDic) -> () in
            
            if statusDic == nil{
                
                finish(isSucceed: false, count: 0); return
            }
            
            if self.statusArray == nil{
                
                self.statusArray = [StatusViewModel]()
            }
            
            // 初始化一个临时数组
            var array = [StatusViewModel]()
            
            // 字典转模型
            for dic in statusDic! {
                
                let viewModel = StatusViewModel(status:Status(dic: dic))
                
                array.append(viewModel)
            }
            // 赋值
            //第一次运行如果为空实例化数组
            if self.statusArray == nil {
                
                self.statusArray = [StatusViewModel]()
                
            }
            if isPullUp{
                self.statusArray! = self.statusArray!+array
                
            }else{//若果是上拉加载就把数据夹在数组后买你否则就加载数组后面
                
                self.statusArray! = array + self.statusArray!
            }
            
            //先不通知外界,先把但张图片下载到缓存中,然后通知界面刷新数据(缓存单张图片)
            
            self.cacheSingleImage(array,finish: finish)
        }
    }
    /// 缓存单张图片
    private func cacheSingleImage(viewModel:[StatusViewModel],finish:(isSucceed:Bool,count:Int)->()){
    
        let group = dispatch_group_create()
        
        let queue = dispatch_get_main_queue()
        //获得url
        for value in viewModel {
            
            var urls = value.statsus?.pic_urls
            
            if  urls == nil || urls!.count == 0 {
                
              urls = value.statsus?.retweeted_status?.pic_urls
                
            }
        
            //判断urls是否只有一张图片,就去下载图片
            if urls?.count == 1{
               
                guard let urlString = urls?.first?.thumbnail_pic else{
                    continue
                }
                dispatch_group_enter(group)
            SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: urlString), options: [], progress: nil, completed: { (image, error, _, _, url) -> Void in
            
                    dispatch_group_leave (group)
                })
            }
        }
        //注册观察组
        dispatch_group_notify(group, queue) { () -> Void in
            print("所有单张图片都下载完成")
            
            finish(isSucceed: true,count: viewModel.count)
        }
    }
}
