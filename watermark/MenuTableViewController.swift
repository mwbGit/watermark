//
//  MenuTableViewController.swift
//  watermark
//
//  Created by admin on 2020/9/18.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "水印专家"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        // 关闭夜间模式
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        let identifierNumber:String  = (UIDevice.current.identifierForVendor?.uuidString)!
        print(identifierNumber)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        } else if section == 1 {
            return 3
        }  else if section == 2 {
            return 2
        } else if section == 3 {
            return 2
        } else if section == 4 {
            return 1
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        } else if section == 1 {
            return 20
        } else if section == 2 {
            return 20
        } else if section == 3 {
            return 20
        }else if section == 4 {
            return 20
        }
        return 20
    }
    
    
    // 点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---------\(indexPath.row)----\(indexPath.section)" )
        // 取消被选中状态
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 1:
            if indexPath.row == 1 {
            }
        case 2:
            // 分享
            if (indexPath.row == 0) {
                let pastboard = UIPasteboard.general
                pastboard.string = "https://apps.apple.com/cn/app/id1537228751"
                alert(text:"复制成功，去粘贴分享")
                return
            } else {
                let store = LGStoreProduct()
                store.openStore(currentVc: self, appId: "1537228751")
//                                LGStoreProduct.gotoAppStore(appId: "1519568576")
            }
            break
        case 3:
            print("")
        default:
            break
        }
    }
    
    
    func alert(text:String){
        let alert = UIAlertController.init(title: text, message: "", preferredStyle: .alert)
        
        let okBtn = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: {
        })
    }
    
    
}

