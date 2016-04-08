//
//  DiscoverController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class DiscoverController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            visitorView.setPage("visitordiscover_image_message", title: "最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            
            return
        }
        
       let titleView = SearchView.searchView()

        titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 35)
        
        navigationItem.titleView = titleView

    }

}