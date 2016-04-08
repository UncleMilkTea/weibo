//
//  HomePicture.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/8.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SDWebImage

private let HomePictureViewIdentifer = "HomePictureViewIdentifer"
private let itemMarign:CGFloat = 5
private let itemWith = CGFloat(Int(SCREENW-2*itemMarign-2*cellHeadImageMargin)/3)

let clickImgNotifi = "clickImgNotification"

class HomePictureView: UICollectionView {
    
    var picUrl:[StatusPicturerInfo]?{
        
        didSet{
            
            label.text = "\(picUrl?.count ?? 0)"
            
            self.snp_updateConstraints { (make) -> Void in
                
                 make.size.equalTo(self.sizeWithCount(picUrl?.count ?? 0))
            }
            
            // 刷新数据
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func setupUI(){
        
        backgroundColor = UIColor(white: 246/255, alpha: 1)
        
        self.dataSource = self
        self.delegate = self
        
        registerClass(HomePictureViewCell.self, forCellWithReuseIdentifier: HomePictureViewIdentifer)
        
        let flayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        flayout.itemSize = CGSizeMake(itemWith, itemWith)
        
        flayout.minimumInteritemSpacing = itemMarign
        
        flayout.minimumLineSpacing = itemMarign
        
        addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        
    }
    
       //判断是否完全显示出来
    private func sizeWithCount(count:Int)->CGSize{
        
        if count == 1{
            //从内存中读取下载好的图片
          if let img = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl?.first?.thumbnail_pic){
            
            //设置最小高度,等比拉伸
            
            var size = img.size
            
            if size.width < 80{
                
                size.height = 80 / size.width * size.height
                
                size.width = 80
                
            }
            
            let layout = self.collectionViewLayout as!UICollectionViewFlowLayout
            
            //需要在返回之前这只条目的大小
            layout.itemSize = size
            
            //返回图片的大小已经查过itemSize报错
            return size
            }
        }
        
        let layout = self.collectionViewLayout as!UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: itemWith, height: itemWith)
        //行
        let col = count == 4 ? 2 : (count > 3 ? 3 : count)
        //列
        let row = (count - 1)/3+1
        
        let w = CGFloat (col) * itemWith + CGFloat (col-1)*itemMarign
        let h = CGFloat (row) * itemWith + CGFloat (row-1)*itemMarign
        
        return CGSizeMake(w, h)
        
        }
    
     lazy var label:UILabel = UILabel(textColor: UIColor.blackColor(), fontSize: 40)

}

// MARK: - 数据源方法
extension HomePictureView: UICollectionViewDataSource,UICollectionViewDelegate ,SDPhotoBrowserDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let browers = SDPhotoBrowser()
        
        browers.sourceImagesContainerView = self
        
        browers.imageCount = (picUrl?.count)!
        
        browers.currentImageIndex = indexPath.item
        
        browers.delegate = self
        
        browers.show()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrl?.count ?? 0
    }
    
    // 返回cell的方法
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 从缓存里面取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HomePictureViewIdentifer, forIndexPath: indexPath) as! HomePictureViewCell
        
        // 设置数据
        cell.statusPicturer = picUrl![indexPath.item]
        
        return cell
    }
    
    func photoBrowser(browser: SDPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        
        return NSURL(string: (picUrl![index].thumbnail_pic?.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle"))!)
        
            }
    func photoBrowser(browser: SDPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        
        let cell = cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? HomePictureViewCell
        
        return cell?.image.image

    }
}

