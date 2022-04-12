//
//  VipViewController.swift
//  watermark
//
//  Created by admin on 2020/11/27.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import StoreKit
import WebKit
import Alamofire
import SwiftyJSON
import CLImagePickerTool

class VipViewController: UIViewController {
    
    var observer : StoreObserver? //内购监听器
    var imageView: UIImageView!
    let defaults = UserDefaults.standard
    var productPricesArray = [String]() //存放内购产品
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "超级会员"
        self.observer = StoreObserver.shareStoreObserver()
        self.productPricesArray = ["30", "90"]
        self.observer?.create()

        let http:HttpHelp = HttpHelp()
        http.synchronousGet()
        
        //内购之后的状态--产品交易完成
        NotificationCenter.default.addObserver(self, selector: #selector(productPurchased(nofi:)), name: NSNotification.Name(rawValue: "ProductPurchased"), object: nil)
        //内购之后的状态--产品交易失败
        NotificationCenter.default.addObserver(self, selector: #selector(productPurchaseFailed(nofi:)), name: NSNotification.Name(rawValue: "ProductPurchaseFailed"), object: nil)
        //内购之后的状态--产品交易恢复
        NotificationCenter.default.addObserver(self, selector: #selector(productRestored(nofi:)), name: NSNotification.Name(rawValue: "ProductRestore"), object: nil)
        
        
        imageView =  UIImageView.init(frame: .init(x:0, y: topHeight - 10 , width: SCREEN_WIDTH, height: UIDevice.isIphoneXLater() ? 210 : 200));
        imageView.image = UIImage.init(named: "vip")
        self.view.addSubview(imageView)
        showShop(hh: imageView.frame.maxY)
        
        let newL = UILabel()
        newL.text = showTips
        print(newL.text)
        newL.font = UIFont.systemFont(ofSize: 14)
        newL.textColor = UIColor.red
        newL.frame = CGRect(x: 15, y: imageView.frame.maxY + 85, width: SCREEN_WIDTH - 30 , height: 30)
        //        remark.textColor = UIColor.gray
        newL.textAlignment = NSTextAlignment.center
        self.view.addSubview(newL)
        // 试用
        let goBut = UIButton.init(frame: .init(x: 10, y: newL.frame.maxY + 5, width: SCREEN_WIDTH - 20 , height: 50))
        goBut.setTitle("立即订阅", for: .normal)
        goBut.setTitleColor(.white, for: .normal)
        goBut.backgroundColor = UIColor.orange
        goBut.layer.cornerRadius = 5.0
        goBut.layer.masksToBounds = true
        goBut.tag = 0
        goBut.addTarget(self, action: #selector(rechargeBtn(sender:)), for: .touchUpInside)
        self.view.addSubview(goBut)
        
        let rk = "连续订阅说明：\n.订阅周期：订阅周期是一个月/一年；\n.订阅付款：用户确认购买并付款后计入iTunes账户；\n.取消订阅：如需取消订阅，请在当前订阅到期24小时以前，手动在iTunes/App Id 设置管理中关闭自动续订功能;\n.续订：苹果iTunes账户会在到期前24小时内扣款，除非在当前订阅之前24小时外关闭订阅;\n.在线咨询：qq[452426885]"
        let vip = UILabel()
        vip.font = UIFont.systemFont(ofSize: 13)
        vip.frame = CGRect(x: 15, y: goBut.frame.maxY + 20, width: SCREEN_WIDTH - 30 , height: 150)
        vip.textColor = UIColor.gray
        vip.numberOfLines = 0 // 换行
        vip.lineBreakMode = NSLineBreakMode.byWordWrapping
        vip.textAlignment = NSTextAlignment.left
        self.view.addSubview(vip)
        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: rk)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 5 //大小调整
        attributedString1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle1, range: NSMakeRange(0, rk.count))
        vip.attributedText = attributedString1
        vip.sizeToFit()
        
        // 条款和隐私
        let tk = UIButton.init(frame: .init(x: 10, y: BOTTOM_HEIGHT - 40, width: 70 , height: 30))
        tk.setTitle("| 条款 | ", for: .normal)
        tk.setTitleColor(.gray, for: .normal)
        tk.addTarget(self, action: #selector(jump1), for: .touchUpInside)
        tk.titleLabel?.font = UIFont.systemFont(ofSize: 12)//设置字体大小
        self.view.addSubview(tk)
        
        let ys = UIButton.init(frame: .init(x: kScreenWidth - 80, y: BOTTOM_HEIGHT - 40, width: 70 , height: 30))
        ys.setTitle("| 隐私 |", for: .normal)
        ys.setTitleColor(.gray, for: .normal)
        ys.addTarget(self, action: #selector(jump2), for: .touchUpInside)
        ys.titleLabel?.font = UIFont.systemFont(ofSize: 12)//设置字体大小
        self.view.addSubview(ys)

//        UserDefaults.standard.set(false, forKey: "vip")
        if isVip || !(observer?.canBuy())! {
            goBut.setTitle("您已是超级会员", for: .normal)
            return
        }
    }
    
    var productButArray = [UIButton(), UIButton()]
    
    func showShop (hh : CGFloat) {
//        self.productPricesArray = [UIButton(), UIButton()]

        for i in 0 ..< StoreObserver.putchaseArray.count {
            let product = StoreObserver.putchaseArray[i]
            let btu = productButArray[i]
            btu.backgroundColor = .white
            btu.layer.masksToBounds = true
            btu.layer.cornerRadius = 10
            btu.layer.borderWidth = 1
            btu.tag = i
            btu.addTarget(self, action: #selector(changeColor(sender:)), for: .touchUpInside)
            if i == 0 {
               btu.backgroundColor = UIColor.init(red: 255/255.0, green: 204/255.0, blue: 153/255.0, alpha: 1)
            }
            btu.layer.borderColor = UIColor.blue.cgColor
            self.view.addSubview(btu)
                
            let studayLabel = UILabel()
            studayLabel.text = product.localizedTitle
            studayLabel.textAlignment = .center
            studayLabel.font = UIFont.systemFont(ofSize: 16)
            btu.addSubview(studayLabel)
                
            let renLabel = UILabel()
            renLabel.text = "￥" + product.price.stringValue
            renLabel.textAlignment = .center
            renLabel.font = UIFont.systemFont(ofSize: 15)
            btu.addSubview(renLabel)
                
            let x : CGFloat =  ((SCREEN_WIDTH - CGFloat(44) ) / 2 + CGFloat(20)) * CGFloat(i % 2) + 12
            let width = (SCREEN_WIDTH - CGFloat(44) ) / 2
            btu.frame = CGRect(x: x, y: hh + 10, width: width, height: 75)
            studayLabel.frame = CGRect(x: 0, y: (75-37)/2, width: width, height: 17)
            renLabel.frame = CGRect(x: 0, y: (75-37)/2 + 23, width: width, height: 14)
        }
    }
    
    @objc func jump1 () {
        //实例化一个将要跳转的viewController
        let secondView = AgreementViewController()
        //跳转
        self.navigationController?.pushViewController(secondView , animated: true)
    }
    
    @objc func jump2 () {
        //实例化一个将要跳转的viewController
        let secondView = PrivacyViewController()
        //跳转
        self.navigationController?.pushViewController(secondView , animated: true)
    }
    
    //销毁
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.observer?.destroy()
        print("销毁了")
        PopViewUtil.share.stopLoading()
    }
    
    
    @objc func changeColor (sender:UIButton) {
        if sender.tag == 1 {
            let btu = productButArray[0]
            btu.backgroundColor = .white
        } else {
            let btu = productButArray[1]
            btu.backgroundColor = .white
        }
        idx = sender.tag
        let btu = productButArray[sender.tag]
        btu.backgroundColor = UIColor.init(red: 255/255.0, green: 204/255.0, blue: 153/255.0, alpha: 1)
    }
    var idx:Int = 0
    
    //点击购买
    @objc func rechargeBtn (sender:UIButton) {
        if isVip {
            UIAlertController.showAlert(message: "您已经是超级会员")
            return
        }
        PopViewUtil.share.showLoading();
        self.observer?.buyProduct(index: idx)
    }

    
    //实现通知监听方法---支付成功 并且第一次验证成功
    @objc func productPurchased(nofi : Notification) {
        print("购买成功")
        setVip(val: true)
        report()
        UIAlertController.showTitleAlert(title:"成功", message: "1分钟内生效",in: self)
        PopViewUtil.share.stopLoading()
    }
    
    //实现通知监听方法---- 重新购买
    @objc func productRestored(nofi : Notification) {
        print("重新购买。。。。")
        setVip(val: true)
        report()
        UIAlertController.showTitleAlert(title:"成功", message: "1分钟内生效",in: self)
        PopViewUtil.share.stopLoading()
    }
    
    //实现通知监听方法---- 失败
    @objc func productPurchaseFailed(nofi : Notification) {
        let code = nofi.userInfo!["code"] as! String
        print("购买失败。。。。")
        report()
        UIAlertController.showTitleAlert(title:"订阅失败", message: code,in: self)
        PopViewUtil.share.stopLoading()
    }
    
    func report() {
        do {
            let receiptURL = Bundle.main.appStoreReceiptURL
            //购买凭据
            let receiptData = NSData(contentsOf: receiptURL!)
            let encodeStr = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                        
            // 解析
            let infoDictionary = Bundle.main.infoDictionary
            let majorVersion: String? = infoDictionary! ["CFBundleShortVersionString"] as? String

            let identifierNumber = UIDevice.getUid
            let sign = identifierNumber + "watermarksafe"
            let encodeStr1: String = encodeStr ?? ""
            Alamofire.request("http://api.mengweibo.com/api/video/report?version=" + majorVersion!, method: HTTPMethod.post,
                              parameters: ["deviceId" : identifierNumber,
                                           "sign":sign.md5, "source":"watermark", "receiptData":encodeStr1]).responseJSON {
                                            (response) in
                                            
                                            switch response.result.isSuccess {
                                            case true:
                                                if let value = response.result.value {
                                                    let json = JSON(value)
                                                    if let vipUser = json["data"]["vipUser"].bool {
                                                        self.setVip(val: vipUser)
                                                        print("return vipUser：",vipUser)
                                                    } else {
                                                        print("return err：",json["msg"])
                                                    }
                                                }
                                                break
                                            case false:
                                                print(response.result.error)
                                                break
                                            }
            }
            
        } catch {
            print("report err")
        }
    }
}

