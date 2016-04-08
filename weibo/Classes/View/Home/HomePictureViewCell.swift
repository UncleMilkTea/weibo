//
//  HomePictureViewCell.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/8.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HomePictureViewCell: UICollectionViewCell {
    
    var statusPicturer:StatusPicturerInfo?{
        
        didSet{
            
            guard let pictureUrl = statusPicturer?.thumbnail_pic else{
                
                return
            }
           image.sd_setImageWithURL(NSURL(string: pictureUrl), placeholderImage: UIImage(named:"timeline_image_placeholder"))
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
        
        contentView.addSubview(image)
        
        image.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(contentView)
        }
    }
    lazy var image:UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.contentMode = .ScaleAspectFill
        
        imageView.clipsToBounds = true
        
        return imageView
        
    }()
}
