//
//  ComposeTextField.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/11.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

@IBDesignable
class ComposeTextView: UITextView {

    @IBInspectable var placeholder : String? {
        
        didSet{
            
            placeHolderLabel.text = placeholder
        }
    }
    
   override var font : UIFont? {
        didSet{
            
            placeHolderLabel.font = font
            
        }
    }
    
    override var text : String? {
        
        didSet{
            
            placeHolderLabel.hidden = hasText()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupUI()
    }
     /// 通过xib创建的时候调用
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI(){
        
        addSubview(placeHolderLabel)
        
        // 添加约束
        placeHolderLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(5)
            make.top.equalTo(8)
            make.width.equalTo(SCREENW - 10)
        }
        
        //监听文字改变
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChanged", name: UITextViewTextDidChangeNotification, object: nil)
    }
    @objc private func textDidChanged() {
        
        placeHolderLabel.hidden = hasText()
    }
    
    /**
    销毁通知
    */
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    private lazy var placeHolderLabel:UILabel = {
        
        let label = UILabel(textColor: UIColor.lightGrayColor(), fontSize: 12)
        
        label.numberOfLines = 0
        
        return label
        }()
    
}
