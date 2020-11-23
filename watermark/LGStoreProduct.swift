//
//  LGStoreProduct.swift
//  watermark
//
//  Created by admin on 2020/9/21.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import StoreKit

class LGStoreProduct: NSObject {
    static let share = LGStoreProduct()
    public override init() { super.init()}
    private var parentVc:UIViewController?
    
    //App Store 评价
    func openStore(currentVc: UIViewController, appId: String)  {
        parentVc = currentVc
        currentVc.present(self.storeVc, animated: true, completion: nil)
        storeVc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appId], completionBlock: {
            (result, error) in
            if result && error == nil {
                print("链接加载成功！！！")
                
            } else {
                print(error as Any)
            }
        })
    }
    
    
    lazy var storeVc: SKStoreProductViewController = {
        let storeVc = SKStoreProductViewController()
        storeVc.delegate = self as? SKStoreProductViewControllerDelegate
        return storeVc
    }()
    
    //内部评价
    static func gotoAppStore(appId: String) {
        if #available(iOS 10.3 , *) {
            SKStoreReviewController.requestReview()
        } else {
            let openStr = "itms-apps://itunes.apple.com/app/id\(appId)?action=write-review"
            if UIApplication.shared.canOpenURL(URL(string: openStr)!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: openStr)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.canOpenURL(URL(string: openStr)!)
                }
            } else {
                print("无法打开链接")
            }
        }
    }
}

