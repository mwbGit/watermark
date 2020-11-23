//
//  ViewController.swift
//  watermark
//
//  Created by admin on 2020/9/17.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var lable: UILabel!
        
    var menuVc:MenuTableViewController?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuView" {
            print("------")
            menuVc = (segue.destination as! MenuTableViewController)
            menuVc?.textField = textField
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "水印专家"
        lable.text = "提示:复制短视频链接地址到输入框"

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        // 关闭夜间模式
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        // 本地数据
        //        let defaults = UserDefaults.standard
        //        if let stringOne = defaults.string(forKey: defaultsKeys.keyOne) {
        //            print(stringOne) // Some String Value
        //        }
        let defaults = UserDefaults.standard
        print(defaults.bool(forKey: "status"))
        if defaults.bool(forKey: "status") {
            
            let optionMenu = UIAlertController(title: "获取Pro", message: "一次性解锁全部功能，新用户专享3天免费试用，可以随时取消订阅", preferredStyle: .alert)
            // 2
            let actionOK = UIAlertAction(title: "免费试用", style: .default) { action -> Void in
                print("actionOK")
                UserDefaults.standard.set(true, forKey: "status")
            }
            let cancelAction = UIAlertAction(title: "了解更多", style: .cancel) { action -> Void in
                print("Cancel")
                let store = LGStoreProduct()
                store.openStore(currentVc: self, appId: "1519568576")
            }
            
            optionMenu.addAction(actionOK)
            optionMenu.addAction(cancelAction)
            
            // 3
            present(optionMenu, animated: true, completion: nil)
            
        }
        
        // 接切板
        if let paste = UIPasteboard.general.string {
            if (textField.text?.count == 0 && !paste.isEmpty &&  (paste.contains("http://") || paste.contains("https://"))) {
                let optionMenu = UIAlertController(title: "要使用剪切板中链接？", message: nil, preferredStyle: .alert)
                // 2
                let actionOK = UIAlertAction(title: "使用", style: .default) { action -> Void in
                    self.textField.text = paste
                }
                let cancelAction = UIAlertAction(title: "忽略", style: .cancel) { action -> Void in
                }
                
                optionMenu.addAction(actionOK)
                optionMenu.addAction(cancelAction)
                // 3
                present(optionMenu, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func clean(_ sender: Any) {
        textField.text = ""
        let md5 =  "Some thing".md5
        print(md5)
    }
    
    
}
