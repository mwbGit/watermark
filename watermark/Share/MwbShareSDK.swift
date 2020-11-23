//
//  ShareSDK.swift
//  watermark
//
//  Created by admin on 2020/9/22.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class MwbShareSDK : NSObject {
    
let shareParames = NSMutableDictionary()

 func share() {
        shareParames.ssdkSetupShareParams(byText: "分享内容",
                                           images : UIImage(named: "dlogo.png"),
                                           url : NSURL(string:"http://mob.com") as URL?,
                                            title : "分享标题",
                                             type : SSDKContentType.image)

        //2.进行分享
        ShareSDK.share(SSDKPlatformType.typeWechat, parameters: shareParames) {
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
}
