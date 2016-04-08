
//
//  StatusViewModel.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/7.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import YYText

class StatusViewModel: NSObject {
    
    // 当前发这条微博的用户的认证图标
    var verifiedImage: UIImage?
    // 会员图标
    var membershipImage: UIImage?
    //转发数
    var repostsCountStr:String?
    //评论数
    var commentsCountStr:String?
    //点赞数
    var attitudesCountStr:String?
    //转发微博的内容
    var retweetedText:String?
    // 格式化的来源字符串
    var sourceText: String?
    // 原创微博显示的富文本内容
    var originalAttributedString: NSMutableAttributedString?
    // 转发微博的富文本内容
    var retweetAttributedString: NSMutableAttributedString?
    // 创建时间字符串
    var createAtText: String?{
        get{
            return statsus?.createdDate?.dateDescription
        }
    }
        
    var statsus:Status?
    
    init(status:Status) {
        super.init()
        
        self.statsus = status
        
        //MARK: - 设置认证
        // 拿到 status 里面的认证类型,去生成对应的认证图标
        
        let verifiedType = status.user?.verified_type ?? -1
        
        switch verifiedType {
        case 1:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:// 企业认证
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220: // 达人
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        //MARK: - 设置会员图标
        if let mbrank = status.user?.mbrank where mbrank > 0 {
            membershipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        repostsCountStr = stringWithCount(statsus!.reposts_count, deflautCount: "转发")
        commentsCountStr = stringWithCount(statsus!.comments_count, deflautCount: "评论")
        attitudesCountStr = stringWithCount(statsus!.attitudes_count, deflautCount: "赞")
        
        if let screenName = statsus?.retweeted_status?.user?.screen_name,text = statsus?.retweeted_status?.text{
            
            retweetedText = "@\(screenName):\(text)"
            
            retweetAttributedString = dealStatusText(retweetedText)
            
        }else{
            
            retweetedText = "该微博已经删除"
        }
        //处理来源字符串
        dealSourceText(status.source)
        originalAttributedString = dealStatusText(status.text)
        
    }
    
    //MARK: - 正则表达式处理微博内容
    private func dealStatusText(text:String?)->NSMutableAttributedString? {
        
        guard let string = text else{
            return nil
        }
        let originalAttr = NSMutableAttributedString(string: string)
        // 定义一个数组保存匹配结果
        var matchResults = [MatchResult]()
        //匹配中英文字符表情
        let regex = "\\[[a-zA-Z0-9\\u2E80-\\u9FFF]+\\]"
        
        (string as NSString).enumerateStringsMatchedByRegex(regex) { (captureCount, captureString, captureRange, stop) -> Void in
            
            let matchResult = MatchResult(captureString: captureString.memory!, captureRange: captureRange.memory)
            
            matchResults.append(matchResult)
        }
        // 倒着遍历匹配的结果,替换表情
        for result in matchResults.reverse() {
            
            // 通过表情字符串找到对应的表情模型
            if let emoticon = HYKEmoticonTools.sharedEmoticonTools.emoticonsWithChs(result.captureString as String) {
                
                // 通过字体大小取到图片显示的大小
                let imageWH = UIFont.systemFontOfSize(15).lineHeight
                
                // 生成图片
                let image = UIImage(named: "\(emoticon.folderName!)/\(emoticon.png!)", inBundle: HYKEmoticonTools.sharedEmoticonTools.emoticonsBoundle, compatibleWithTraitCollection: nil)
                
                // 初始化 文字附件
                let attachment = HYKTextAttachment()
                attachment.image = image
                attachment.bounds = CGRect(x: 0, y: -4, width: imageWH, height: imageWH)
                
                // 初始化 NSAttributedString -> 带有表情图片的attr
                let attr = NSAttributedString(attachment: attachment)
                
                // 将指定位置的文字字符串替换成上一步生成的表情字符串
                originalAttr.replaceCharactersInRange(result.captureRange, withAttributedString: attr)
            }
        }
        // 添加字体大小和颜色的属性
        originalAttr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: NSMakeRange(0, originalAttr.length))
        originalAttr.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, originalAttr.length))
        
        // 匹配网址
        let urlRegex = "([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>.',;]*)?"
        addHighLightedText(urlRegex, attributedString: originalAttr)
        
        // 匹配@xxxx,中文,英文,数字,_,-
        let atRegex = "@[\\u2E80-\\u9FFFa-zA-Z0-9_\\-]+"
        addHighLightedText(atRegex, attributedString: originalAttr)
        
        
        // 匹配话题 : # 不能出现# #
        let topPicRegex = "#[^#]+#"
        addHighLightedText(topPicRegex, attributedString: originalAttr)

        
        return originalAttr
    }
    
    //MARK: - 显示高亮字符
    private func addHighLightedText(regex: String, attributedString: NSMutableAttributedString){
    
        (attributedString.string as NSString).enumerateStringsMatchedByRegex(regex) { (count, catureString, catureRange, stop) -> Void in
            
            attributedString.addAttribute(NSForegroundColorAttributeName,value: RGB(r: 52, g: 105, b: 164), range: catureRange.memory)
            
            let border = YYTextBorder(fillColor: RGB(r: 152, g: 206, b: 255), cornerRadius: 3)
            
            border.insets = UIEdgeInsetsZero
            
            let highlighted = YYTextHighlight()
            
            highlighted.userInfo = ["text":catureString.memory!]
            
            highlighted.setColor(RGB(r: 52, g: 105, b: 164))
            
            highlighted.setBackgroundBorder(border)
            
            attributedString.yy_setTextHighlight(highlighted, range: catureRange.memory)
        }
    }
    //MARK: - 微博来源截取
    private func dealSourceText(source:String?){
    
      guard  let s = statsus?.source else{
        
            return
        }
        if let start = s.rangeOfString("\">")?.endIndex{
            
            if let end = s.rangeOfString("</")?.startIndex{
                
                sourceText = "来自 \(s.substringWithRange(start..<end))"
            }
        }
    }
    //MARK: - 转发评论数量显示逻辑
    private func stringWithCount(count:Int,deflautCount:String)->String{
        
        /**
        以转发来说,如果有转发数据,那么就显示对应数量
        - 如果低于10000 --> 直接显示数字
        - 如果低于10900 --> 显示1万
        - 如果高于11000(12003) --> 显示 1.x 万
        */
        
        if count < 10000{
            if count == 0{
                return deflautCount
            }else{
               return "\(count)"
            }
            
        }else{
            
            let result = CGFloat(count/1000)/10
            
            let resultStr = "\(result)万"
            
            if resultStr.containsString(".0"){
                
                return resultStr.stringByReplacingOccurrencesOfString(".0",withString:"")
            }
            return resultStr
        }
    }
}
