//
//  UIViewController_Extension.swift
//  XYZShareTool
//
//  Created by 张小杨 on 2019/8/6.
//  Copyright © 2019 张小杨. All rights reserved.
//

import UIKit
public extension UIViewController {
    
    /// 屏幕宽高
    var kScreenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var kScreenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    /// 顶部安全区域偏移量
    var kSafeAreaTopInset: CGFloat {
        return UIDevice.isIPhoneX ? 44 : 20
    }
    
    /// 底部安全区域偏移量
    var kSafeAreaBottomInset: CGFloat {
        return UIDevice.isIPhoneX ? 34 : 0
    }
    
    var kNavigationBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 88 : 64
    }
    
    var kTabBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 49+34 : 49
    }
    
    var isVip: Bool {
        return UserDefaults.standard.bool(forKey: "vip")
    }
    
    func setVip(val:Bool) {
        UserDefaults.standard.set(val, forKey: "vip")
    }
    var limit: Bool {
        return UserDefaults.standard.integer(forKey: "times") >= 1
    }
    
    var increase: Bool {
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "times") + 1 , forKey: "times")
        return true
    }
    
    var showTips:String {
        return UserDefaults.standard.string(forKey: "vipTips") ?? ""
    }
    
    func setTips(val:String) {
        UserDefaults.standard.set(val, forKey: "vipTips")
    }
}

