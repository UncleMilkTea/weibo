//
//  AppDelegate.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let userLogin = UserAccountViewModel.sharedAccountViewModel.userLogin
        
        window?.rootViewController =  userLogin ? WellComeView():MainViewController()
        
        window?.makeKeyAndVisible()
        
        self.obsver = NSNotificationCenter.defaultCenter().addObserverForName(SwitchRootVCNotification, object:  nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (noti) -> Void in
            
            if noti.object!.isKindOfClass(OAuthController.self){
                
                self.window?.rootViewController = WellComeView()
                
            }else{
                
                self.window?.rootViewController = MainViewController()
            }
        })
        
        return true
    }
    
    var obsver : NSObjectProtocol?
    // 析构函数,与 OC 中的 dealloc 类似,当对象将要销毁的时候会调用这个方法
    // 一般在这个方法里面做: 移除通知,释放某对象的内存,移除观察者
    
    deinit{
        
    NSNotificationCenter.defaultCenter().removeObserver(obsver!)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
// 进入到后台的时候，去清除数据
    func applicationDidEnterBackground(application: UIApplication) {
         StatusDAL.clearCache()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

