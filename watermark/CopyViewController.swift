//
//  CopyViewController.swift
//  watermark
//
//  Created by admin on 2020/11/20.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import WebKit

class CopyViewController: UIViewController {


        var webView: WKWebView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "隐私协议"

    //         加载内部html privacy agreement
            let fileURL =  Bundle.main.url(forResource: "privacy", withExtension: "html" )
            webView.loadFileURL(fileURL!,allowingReadAccessTo:Bundle.main.bundleURL);
    //
        }
        

        override func loadView() {
            webView = WKWebView()
            view = webView
        }
        
    
}
