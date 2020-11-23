//
//  ShareView.swift
//  watermark
//
//  Created by admin on 2020/9/21.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class ShareView: UIView {
    
    
    // 1.创建分享参数
    let shareParames = NSMutableDictionary()
    
    //新浪微博
    @IBAction func sinaWeibo(sender: AnyObject) {
        shareParames.ssdkSetupShareParams(byText: "分享内容",
                                          images : UIImage(named: "dlogo.png"),
                                          url : NSURL(string:"http://mob.com") as URL?,
                                          title : "分享标题",
                                          type : SSDKContentType.image)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.typeSinaWeibo, parameters: shareParames) {
            (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            print(state)
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
        print("end share -----")
    }
    //QQ空间
    @IBAction func qqZone(sender: AnyObject) {
    }
    //QQ好友
    @IBAction func qqFriend(sender: AnyObject) {
    }
    //微信
    @IBAction func weChat(sender: AnyObject) {
    }
    //朋友圈
    @IBAction func wechatTimeline(sender: AnyObject) {
    }
    //支付宝
    @IBAction func aliPaySocial(sender: AnyObject) {
    }
    //点击取消
    @IBAction func cancel(sender: AnyObject) {
//        self.hideView()
    }
}
