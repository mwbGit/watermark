//
//  MenuTableViewController.swift
//  watermark
//
//  Created by admin on 2020/9/18.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuTableViewController: UITableViewController {
    var open = false
    var status = 0
    var date = 20201205
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
        let identifierNumber:String  = (UIDevice.current.identifierForVendor?.uuidString)!
        
        self.observer = StoreObserver.shareStoreObserver()
        self.observer?.create()
        
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
                setTips(val: false)
                open = dateIsAfter(date) && synchronousGet()
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
                store.openStore(currentVc: self, appId: "1537228751")
                //                                LGStoreProduct.gotoAppStore(appId: "1519568576")
            }
            break
        case 3:
            print("")
        case 4:
            let secondView = VideoWaterViewController()
//            self.navigationController?.pushViewController(secondView , animated: true)
        //跳转
        default:
            break
        }
    }
    
    // 同步请求
    func synchronousGet() -> Bool {
        let identifierNumber:String  = (UIDevice.current.identifierForVendor?.uuidString)!
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion: String? = infoDictionary! ["CFBundleShortVersionString"] as? String
        let sign = identifierNumber + "watermarksafe"

        // 1、创建URL对象；
        let url:URL! = URL(string:"http://api.mengweibo.com/api/video/info?version=" + majorVersion! + "&deviceId=" + identifierNumber + "&sign=" + sign.md5);
        
        // 2、创建Request对象
        // url: 请求路径
        // cachePolicy: 缓存协议
        // timeoutInterval: 网络请求超时时间(单位：秒)
        let urlRequest:URLRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        
        // 3、响应对象
        var response:URLResponse?
        
        // 4、发出请求
        do {
            
            let received =  try NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
            let dic = try JSONSerialization.jsonObject(with: received, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary //(必须写as! NSDictionary 不然会出错)
            let json = JSON(dic)
            
            // vip用户
            if let vip = json["data"]["vipUser"].bool {
                if !isVip {
                    setVip(val: vip)
                }
            }

            if let status1 = json["data"]["status"].int {
                print("status ok \(status)")
                setTips(val: status1 == 102)
                return status1 == 102
            }
        } catch let error{
            print(error.localizedDescription);
        }
        return false
    }
    
    
    fileprivate func dateIsAfter(_ dateNum: Int) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        formatter.timeZone = TimeZone(abbreviation: "CHN")
        if let current = Int(formatter.string(from: Date())), current >= dateNum {
            return true
        }else {
            return false
        }
    }
}

