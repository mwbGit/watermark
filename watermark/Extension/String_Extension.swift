//
//  ViewController.swift
//  watermark
//
//  Created by admin on 2020/10/16.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import CommonCrypto
extension String {
    var md5: String
    {
        let ccharArray = self.cString(using: String.Encoding.utf8)
        
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        CC_MD5(ccharArray, CC_LONG(ccharArray!.count - 1), &uint8Array)
        
        return uint8Array.reduce("") { $0 + String(format: "%02x", $1)
        }
    }
}
