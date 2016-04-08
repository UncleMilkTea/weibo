//
//  ComposePictureView.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/12.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

let ComposePictureIdentifier = "ComposePictureIdentifier"

class ComposePictureView: UICollectionView {
    
    //定义一个选择图片的闭包,在点击添加按钮
    var selectPic:(()->())?
    
    var imageArr : [UIImage] = [UIImage]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(){
        
        backgroundColor = UIColor.whiteColor()
     
        self.registerClass(ComposePictureViewCell.self, forCellWithReuseIdentifier: ComposePictureIdentifier)
       
        self.delegate = self
        
        self.dataSource = self
    }
    /// 外界添加图片
    func addImage (image:UIImage){
        
        imageArr.append(image)
        
        hidden = false
        
        self.reloadData()
        
    }
    override func layoutSubviews() {
        
        let itemMargin:CGFloat = 5
        
        let itemW = CGFloat(Int((self.frame.width - 2 * itemMargin)/3))
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width:itemW, height: itemW)
        
        layout.minimumInteritemSpacing = itemMargin
        
        layout.minimumLineSpacing = itemMargin
        
        super.layoutSubviews()

    }
}

//MARK: -  数据源方法
extension ComposePictureView:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (imageArr.count == 0 || imageArr.count == 9) ? imageArr.count : imageArr.count+1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ComposePictureIdentifier, forIndexPath: indexPath) as! ComposePictureViewCell
        if indexPath.item == imageArr.count{
            
            cell.image = nil
        }else{
            
            cell.image = imageArr[indexPath.item]
        }
        
        cell.delebuttonClickClose = { [weak self] (cell:ComposePictureViewCell) in
            
            if let indexPath = self?.indexPathForCell(cell){
                
                self?.imageArr.removeAtIndex(indexPath.item)
                
                self?.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item == imageArr.count{
            
            selectPic?()
        }
    }
}
//MARK: -  自定义cell
private class ComposePictureViewCell:UICollectionViewCell{
    
    ///定义一个闭包在点击删除按钮时候调用
    var delebuttonClickClose:((cell:ComposePictureViewCell)->())?
    
    var image : UIImage? {
        
        didSet{
        deleteButton.hidden = image == nil
            
            if image != nil{
                imageView.image = image
                
                imageView.highlightedImage = image
            }else{
                //设置加号按钮
                imageView.image = UIImage(named: "compose_pic_add")
                imageView.highlightedImage = UIImage(named: "compose_pic_add_highlighted")
            }
        }
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
     
        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
        
        deleteButton.snp_makeConstraints { (make) -> Void in
            make.top.trailing.equalTo(contentView)
        }
    }
    
    @objc private func delebuttonClick(){
        
        delebuttonClickClose?(cell:self)
    }
    
    // MARK: - 懒加载控件
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        }()
    
    // 删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: "delebuttonClick", forControlEvents: UIControlEvents.TouchUpInside)
        button.setImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        return button
        }()
}
