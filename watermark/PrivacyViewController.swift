//
//  NewDetailViewController.swift
//  demo16
//
//  Created by admin on 2020/9/4.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import WebKit

let SCREEN_WIDTH : CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.size.height

class PrivacyViewController: UIViewController {
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
