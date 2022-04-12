//
//  MenuTableViewController.swift
//  watermark
//
//  Created by admin on 2020/9/18.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var open = false
    var status = 0
    var date = 2021010907
    var observer : StoreObserver? //内购监听器
    var productIdArray = [String]() //存放内购产品
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "水印助手"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        // 关闭夜间模式
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.observer = StoreObserver.shareStoreObserver()
        
        //内购数据
        self.productIdArray = ["105", "106"]
        //获取所有的商品
        self.observer?.requestProductDataWithIds(productIds: self.productIdArray)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            if status == 0 {
                let http:HttpHelp = HttpHelp()
                open = dateIsAfter(date) && http.synchronousGet()
                status = 1
            }
            if open {
                return 1
            }
        } else if section == 1 {
            return 4
        }  else if section == 2 {
            return 3
        } else if section == 3 {
            return 2
        } else if section == 4 {
            return 1
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0 && open) {
            return 20
        }
        return 5
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
                UIAlertController.showAlert(message: "复制成功，去粘贴分享")
                return
            } else if (indexPath.row == 1) {
                let store = LGStoreProduct()
                //                store.openStore(currentVc: self, appId: "1537228751")
                store.goAppStore()
            }
            break
        case 3:
            print("")
            //            let secondView = VideoWaterViewController()
            //            self.navigationController?.pushViewController(secondView , animated: true)
        //跳转
        default:
            break
        }
    }
    
    fileprivate func dateIsAfter(_ dateNum: Int) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHH"
        formatter.timeZone = TimeZone(abbreviation: "CHN")
        if let current = Int(formatter.string(from: Date())), current >= dateNum {
            return true
        }else {
            return false
        }
    }
    
}

