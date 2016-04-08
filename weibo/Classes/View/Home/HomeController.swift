//
//  HomeController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/2.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeController: VisitorTableViewController {
    
    private lazy var refesh:RefreshControl = RefreshControl()
    
    let identifier :String = "cell"
    
   lazy var statuListViewModel:StatusListViewModel = StatusListViewModel()
    
 
    ///下拉刷新提示控件
    private lazy var pullDownTipLabel:UILabel = {
       
        let label = UILabel(textColor: UIColor.whiteColor(), fontSize: 12)
        
        label.frame.size = CGSizeMake(SCREENW,35)
        
        label.backgroundColor = UIColor.orangeColor()
        
        label.hidden = true; label.textAlignment = .Center
        
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !userLogin{
            
            visitorView.setPage(nil, title: nil)
            
            return
        }
        setUpUI()
    }
    
   private func setUpUI (){
    
    self.navigationController?.view.insertSubview(pullDownTipLabel, belowSubview: (navigationController?.navigationBar)!)
    
    // 设置pullDownTipLabel的Y值
    pullDownTipLabel.frame.origin.y = CGRectGetMaxY(navigationController!.navigationBar.frame) - pullDownTipLabel.frame.height
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch", title: nil, target: nil, action:nil )
        
    navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: "push")
    
    tableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: identifier)
    //先写死行高
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    tableView.separatorStyle = .None
    tableView.backgroundColor = UIColor(white: 239/255, alpha: 1)
    tableView.tableFooterView = pullUpView
//    refreshControl = UIRefreshControl()//系统刷新控件
//    refreshControl?.addTarget(self, action: "loadData", forControlEvents:UIControlEvents.ValueChanged )
    
    
    refesh.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
    
    tableView.addSubview(refesh)
    
    loadData()
    
    }
    private func refresh(){//刷新方法
        
        self.pullUpView.stopAnimating()
        //停止刷新
        refesh.endRefreshing()
    }
    
   @objc private func loadData() {
        
        statuListViewModel.loadData(pullUpView.isAnimating(), finish:
            { (isSuccess,count)->() in
                
                if isSuccess {
                    
                    self.tableView.reloadData()
                  
                    if !self.pullUpView.isAnimating() {
                        
                        self.pullDownTipLabelView(count)
                    }
                    
                    SVProgressHUD.showSuccessWithStatus("刷新成功")
                }else{
                    
                    SVProgressHUD.showErrorWithStatus("数据载入错误")
                }
                
                self.refresh()
        })
    }
    
    func push(){
        navigationController?.pushViewController(TestViewConreoller(), animated: true)
    }
    
    private var pullUpView:UIActivityIndicatorView = {
        
        let flower = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        
        flower.backgroundColor = UIColor.yellowColor()
        
        return flower
          
    }()
    
    private func pullDownTipLabelView(count:Int){
        
        if pullDownTipLabel.hidden == false {
            
            return
        }
        let contenText = count == 0 ? "没有数据le" : "加载了\(count)条数据"
        
        pullDownTipLabel.text = contenText
        
        pullDownTipLabel.hidden = false
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            
                self.pullDownTipLabel.frame.origin.y += self.pullDownTipLabel.frame.height
            
            }) { (_) -> Void in
                
                self.pullDownTipLabel.frame.origin.y -= self.pullDownTipLabel.frame.height
                
                self.pullDownTipLabel.hidden = true
        }
    }
}

extension HomeController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return  statuListViewModel.statusArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        cell.statusViewModels = statuListViewModel.statusArray![indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == statuListViewModel.statusArray!.count-1 && pullUpView.isAnimating() == false {
            //让菊花转
            self.pullUpView.startAnimating()
            //加载数据
            //需要判断从哪停止菊花转
            loadData()
        }
    }
}