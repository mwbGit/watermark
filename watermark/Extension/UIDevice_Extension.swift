//
//  UIDevice_Extension.swift
//  XYZShareTool
//
//  Created by 张小杨 on 2019/8/6.
//  Copyright © 2019 张小杨. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

public extension UIDevice {
    // 判断是否为iPhontX系列手机
    static var isIPhoneX: Bool {
        if #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets.bottom > 0
            
        }
        return false
    }
    
    static var getUid :String {
        let keychain = KeychainSwift()
        var cuserId: String!
        
        if let userID = keychain.get("cuserId") {
            cuserId = userID
        } else {
            let uuid = UUID().uuidString
            keychain.set(uuid, forKey: "cuserId")
            cuserId = keychain.get("cuserId") ?? (UIDevice.current.identifierForVendor?.uuidString)!
        }
        print("c_uuid= "+cuserId)
        return cuserId
    }
}
