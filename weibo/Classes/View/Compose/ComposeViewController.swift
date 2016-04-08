//
//  ComposeViewController.swift
//  weibo
//
//  Created by 侯玉昆 on 16/3/11.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeViewController: UIViewController {
    
    lazy var isToolBarAnimation:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

      setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //MARK: - 设置UI
    private func setupUI(){
        
        setupNavigation()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(textView)
        
        view.addSubview(toolBarView)
        
        textView.addSubview(pictureView)
        
        textView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        toolBarView.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.bottom.equalTo(self.view)
            make.height.equalTo(40)
        }
        pictureView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(150)
            make.leading.equalTo(10)
            make.width.equalTo(textView.snp_width).offset(-20)
            make.height.equalTo(pictureView.snp_width)
        }
        
        ///监听键盘弹出的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        ///监听表情按钮点击通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emoticonButtonClick:", name: EmoticionsClickBtn, object: nil)
        ///监听删除表情点击通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDelDidSelected", name: KeyboardDelDidSelectedNotification, object: nil)
    }
    //MARK: - 设置导航栏
    private func setupNavigation(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rigthBtn)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: "back")
        
        navigationItem.rightBarButtonItem?.enabled = false
        
        navigationItem.titleView = titleView
    }
    
//MARK: - 懒加载
    //MARK: - 懒加载工具条
    private lazy var toolBarView: ComposeToolBar = {
        
        let toolBar = ComposeToolBar(frame: CGRectZero)
        
        toolBar.composeToolBarClick = { [weak self] (type:ComposeToolBarType) in
            
            switch type {
                
            case .Picture:
                // 选择图片
                self?.selectedPicture()
            case .Mention:
                print("@")
            case .Trend:
                print("#")
            case .Emoticon:
                self?.swithEmoticons()
            case .Add:
                print("加号")
            }
        }
        return toolBar
        }()
    
    //MARK: - 懒加载标题
    private lazy var titleView:UILabel = {
       
        let label = UILabel()
        
        label.numberOfLines = 0
        
        label.textAlignment = .Center
        
        if  let screenName = UserAccountViewModel.sharedAccountViewModel.account?.screen_name {
    
            let text = "发微博\n\(screenName)"
            
            //初始化一个带有属性的文字
            let attrText = NSMutableAttributedString(string: text)
            
            let attrDit = [
                NSForegroundColorAttributeName:UIColor.lightGrayColor(),
                NSFontAttributeName:UIFont.systemFontOfSize(14),
                NSStrokeColorAttributeName:UIColor.redColor(),
                NSStrokeWidthAttributeName:2
            ]
            let range = (text as NSString).rangeOfString(screenName)
            
            // 添加属性
            attrText.addAttributes(attrDit, range: range)
            
            label.attributedText = attrText
        }else{
        
            label.text = "发微博"
        }
        label.sizeToFit()
        return label
    }()
    
    //MARK: - 懒加载占位符
    private lazy var textView: ComposeTextView = {
        
        let textView = ComposeTextView(frame: CGRectZero, textContainer: nil)
        
        textView.placeholder = "听说下雨天音乐和辣条更配哟~"
        
        textView.font = UIFont.systemFontOfSize(15)
        
        textView.delegate = self ; textView.alwaysBounceVertical = true
        // 键盘取消第一响应者方式,拖拽但有警告
        //textView.keyboardDismissMode = .OnDrag
        
        return textView
        }()
    
    //MARK: - 懒加载发送按钮
    private lazy var rigthBtn : UIButton = {
       
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Disabled)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
        btn.setTitle("发送", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.frame.size = CGSize(width: 40, height: 30)
        btn.addTarget(self, action: "sendWeiBo", forControlEvents: .TouchUpInside)
        return btn
    }()
    
    //MARK: - 懒加载图片添加框
    private lazy var pictureView:ComposePictureView = {
    
        let view = ComposePictureView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.selectPic = {[weak self] in

            let vc = UIImagePickerController()
            
            vc.delegate = self
            
            self?.presentViewController(vc, animated: true, completion: nil)
        }
        
        return view
    }()
    
    //MARK: - 懒加载表情键盘
    private lazy var emoticionsKeyBoard:HYKEmoticionsView = HYKEmoticionsView(frame: CGRect(x: 0, y: 0, width: SCREENW, height: 228))
}


//MARK: - 代理方法
extension ComposeViewController:UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        // 调用配图控件的addImage的方法就可以了//压缩图片
        pictureView.addImage(image.scaleToWidth(600))
        

    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func textViewDidChange(textView: UITextView) {
        
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        view.endEditing(true)
    }
}
//MARK: - 方法拓展
extension ComposeViewController{
    //MARK: - 表情键盘
   private func swithEmoticons (){
        
    if textView.inputView == nil{
        
        textView.inputView = emoticionsKeyBoard
        
        toolBarView.isKeyBoardSystem = false
    }else{
        
        textView.inputView = nil
        
        toolBarView.isKeyBoardSystem = true
    }
    //取消第一响应者,会发送键盘frame改变的通知,由于我们监听过此通知,所以composetoolBar会执行一个0.25秒的往下的动画,而在0.25秒的动画还没有执行完毕的时候,我们又成为了第一响应者,这个时候又发送了一个键盘frame改变的通知,所以就造成抖动,解决方法就是,第一次取消第一响应的时候不需要去执行动画.
    isToolBarAnimation = false
    
    textView.resignFirstResponder()
    
    isToolBarAnimation = true

    textView.becomeFirstResponder()
    }
    
    //MARK: - 发表图片微博
    private func pubilcPicture(){
        
        HYKNetWorkingTools.sharedTools.pubilcPicture(textView.emoticonText, image: pictureView.imageArr.first!) { (responseObject, error) -> () in
            
            if error != nil{
                SVProgressHUD.showErrorWithStatus("发表失败")
                return
            }
            SVProgressHUD.showSuccessWithStatus("发表成功")

        }
    }
    //MARK: - 发表文字微博
    private func pubilcText(){
        
        HYKNetWorkingTools.sharedTools.pubilcText(textView.emoticonText) { (responseObject, error) -> () in
            
            if error != nil{
                SVProgressHUD.showErrorWithStatus("发表失败")
                return
            }
            SVProgressHUD.showSuccessWithStatus("发表成功")
            }
    }
    
    //MARK: - 监听表情点击
    @objc private func emoticonButtonClick(noti:NSNotification){
        
        textView.insertEmoticiond(noti.userInfo!["emoticions"]! as! Emoticons)
    }
    
    // MARK: - 监听键盘弹出
    @objc private func KeyboardWillChangeFrame(noti:NSNotification){
        //防止键盘切换跳动
        if isToolBarAnimation == false {
            
            return
        }
        
        let endFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey]! as! NSValue).CGRectValue()
        
        let dureTime = (noti.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber).doubleValue
        
        self.toolBarView.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(endFrame.origin.y - SCREENH)
        }
        
        UIView.animateWithDuration(dureTime) { () -> Void in
            
            self.toolBarView.layoutIfNeeded()
        }
    }
    //MARK: - 监听返回
    @objc private func back (){
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: - toolBar的上传图片按钮
    @objc private func selectedPicture(){
        
        let vc = UIImagePickerController()
        
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    //MARK: - 监听发送微博按钮
    @objc private func sendWeiBo(){
        
        if pictureView.imageArr.count > 0 {
            
            pubilcPicture()
        }else{
            
            pubilcText()
        }
    }
    //MARK: - 监听表情键盘的删除按钮
    @objc private func keyboardDelDidSelected(){
        
        textView.deleteBackward()
    }
}
