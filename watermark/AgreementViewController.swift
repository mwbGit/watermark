//
//  AgreementViewController.swift
//  watermark
//
//  Created by admin on 2020/9/22.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import WebKit

class AgreementViewController: UIViewController {

     var webView: WKWebView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "用户协议"
    //         加载内部html privacy agreement
            let fileURL =  Bundle.main.url(forResource: "agreement", withExtension: "html" )
            webView.loadFileURL(fileURL!,allowingReadAccessTo:Bundle.main.bundleURL);
    //
        }
        
        

        override func loadView() {
            webView = WKWebView()
            view = webView
        }

}
