//
//  WaterViewController.swift
//  watermark
// 去水印
//  Created by admin on 2020/10/19.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire
import SwiftyJSON
import MediaPlayer
import WebKit
import StoreKit
import CLImagePickerTool

class WaterViewController: UIViewController,UITextFieldDelegate {
        
    var containerView: UIView!
    var save: UIButton!
    var clean: UIButton!
    var textField: UITextField!
    var playerViewController:AVPlayerViewController?
    var spinner: UIActivityIndicatorView!
    
    var videoUrl = ""
    var observer : StoreObserver? //内购监听器
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "短视频提取"
        
        // 提取
        let goBut = UIButton.init(frame: .init(x: SCREEN_WIDTH - 70, y: topHeight, width: 65 , height: 50))
        goBut.setTitle("提取", for: .normal)
        goBut.setTitleColor(.white, for: .normal)
        goBut.backgroundColor = .systemBlue
        goBut.addTarget(self, action: #selector(goParse), for: .touchUpInside)
        self.view.addSubview(goBut)
        
        // 链接输入框
        textField = UITextField.init(frame: .init(x: 5, y: topHeight, width: SCREEN_WIDTH - 75 , height: 50))
        textField.borderStyle = UITextField.BorderStyle.line
        textField.textAlignment = .center //水平居中对齐
        textField.clearButtonMode = .always  //编辑后出现清除按钮
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.placeholder = "请将短视频链接粘贴至此"
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        self.view.addSubview(textField)
        
        
        containerView = UIView(frame: CGRect(x: 0, y: topHeight + 60, width: SCREEN_WIDTH, height: BOTTOM_HEIGHT - 80 - topHeight - 60))
        containerView.contentMode = UIView.ContentMode.scaleAspectFit

        
        self.view.addSubview(containerView)
        
        // 警示说明
        let remark = UILabel()
        remark.text = "《链接去水印仅供个人测试，严禁商业用途。视频版权归作者所有，本应用不存储任何视频和图片》"
        remark.font = UIFont.systemFont(ofSize: 8)
        remark.frame = CGRect(x: 5, y: BOTTOM_HEIGHT - 40, width: SCREEN_WIDTH - 10 , height: 40)
        remark.numberOfLines = 0
        remark.lineBreakMode = NSLineBreakMode.byWordWrapping
        remark.textAlignment = NSTextAlignment.center
        self.view.addSubview(remark)
        
        save = UIButton.init(frame: .init(x: 10, y: BOTTOM_HEIGHT - 70, width: SCREEN_WIDTH - 20 , height: 40))
        save.setTitle("保存视频到相册", for: .normal)
        save.setTitleColor(.white, for: .normal)
        save.addTarget(self, action: #selector(saveVideo), for: .touchUpInside)
        save.backgroundColor = .systemBlue
        save.isHidden = true
        save.layer.cornerRadius = 5.0
        save.layer.masksToBounds = true
        self.view.addSubview(save)
        
        // lodding
        spinner = UIActivityIndicatorView.init(style: .whiteLarge)
        spinner.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        spinner.center = (UIApplication.shared.keyWindow?.center)!
        spinner.color = UIColor.black
        self.view.addSubview(spinner)
        //剪切板
        paste()
        
        self.observer = StoreObserver.shareStoreObserver()
        self.observer?.create()
    }
    
    //销毁
    deinit {
        self.observer?.destroy()
        print("销毁了1")
    }
    
    //点击空白处关闭键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //某个textview失去了响应者，即收起键盘了
        textField.resignFirstResponder()
        //或注销当前view(或它下属嵌入的text fields)的first responder 状态，即可关闭其子控件键盘
        self.view?.endEditing(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view?.endEditing(false)
        return true
    }
    
    //保存
    @objc func saveVideo() {
        if videoUrl.isEmpty {
            UIAlertController.showAlert(message:"请先提取视频")
            return
        }
        if checkStatus() {
            spinner.startAnimating()
            loadData(videoUrl: videoUrl);
            increase
        }
    }
    
    // 订阅
    func checkStatus() -> Bool {
        if !limit {
            return true
        }
        if isVip {
            return true
        }
        if !observer!.canBuy() {
            return true
        }
        
        let optionMenu = UIAlertController(title: "获取Pro", message: "一次性解锁全部功能，新用户专享3天免费试用，可以随时取消", preferredStyle: .alert)
        // 2
        let actionOK = UIAlertAction(title: "免费使用", style: .default) { action -> Void in
            print("actionOK")
            // 购买
            self.observer?.buyProduct(index: 0)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            print("Cancel")
//            let store = LGStoreProduct()
//            store.openStore(currentVc: self, appId: "1519568576")
        }
        
        optionMenu.addAction(actionOK)
        optionMenu.addAction(cancelAction)
        
        // 3
        present(optionMenu, animated: true, completion: nil)
        return false
    }
    
    // 剪切板
    func paste() -> Void {
        if let paste = UIPasteboard.general.string {
            if (textField.text?.count == 0 && !paste.isEmpty &&  (paste.contains("http://") || paste.contains("https://"))) {
                let optionMenu = UIAlertController(title: "要使用剪切板上链接？", message: paste, preferredStyle: .alert)
                // 2
                let actionOK = UIAlertAction(title: "使用", style: .default) { action -> Void in
                    self.textField.text = paste
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                }
                
                optionMenu.addAction(actionOK)
                optionMenu.addAction(cancelAction)
                // 3
                present(optionMenu, animated: true, completion: nil)
            }
            
        }
    }
    
    // 加载播放器
    func loadPlayer(videoUrl : String) -> Void {
        let player = AVPlayer(url: URL(string: videoUrl)! as URL)
        playerViewController = AVPlayerViewController()
        playerViewController!.player = player
        containerView?.addSubview(playerViewController!.view)
        playerViewController?.view.frame = containerView!.bounds
        addChild(self.playerViewController!)
        save.isHidden = false
    }
    
    //提取
    @objc func goParse() {
        if spinner.isAnimating {
            UIAlertController.showAlert(message:"请等待，正在处理中")
            return
        }
        parse()
    }
    
    
    //    // 播放
    //    @IBAction func play(_ sender: Any) {
    //        if videoUrl.isEmpty {
    //            alert(text:"请先提取视频")
    //            return
    //        }
    //
    //        playerViewController?.player?.play()
    //    }
    
    // 去水印
    func parse() {
        //校验
        if let text = textField.text {
            if( text.count == 0 ) {
                UIAlertController.showAlert(message:"请输入视频地址")
                return
            }
        }
        
        // 截取地址
        let url = getUrl(text : textField.text!)
        if url.isEmpty {
            UIAlertController.showAlert(message:"视频地址不正确")
            return
        }
        if spinner.isAnimating {
            UIAlertController.showAlert(message:"请等待，正在处理中")
            return
        }

        do {
            // 解析
            spinner.startAnimating()
            let sign = url + "watermarksafe"
            let identifierNumber = UIDevice.getUid
            let infoDictionary = Bundle.main.infoDictionary
            let majorVersion: String? = infoDictionary! ["CFBundleShortVersionString"] as? String

            Alamofire.request("http://api.mengweibo.com/api/video/parse?version=" + majorVersion!, method: HTTPMethod.get,
                              parameters: ["deviceId" : identifierNumber,"version1": majorVersion,
                                           "sign":sign.md5, "url":url,"source":"watermark"]).responseJSON {
                                            (response) in
                                            switch response.result.isSuccess {
                                            case true:
                                                if let value = response.result.value {
                                                    let json = JSON(value)
                                                    if let videoUrl1 = json["data"]["playAddr"].string {
                                                        // 找到地址
                                                        print("return：",videoUrl1)
                                                        self.videoUrl = videoUrl1
                                                        // 加载视频
                                                        self.loadPlayer(videoUrl:self.videoUrl)
                                                    } else {
                                                        print("return err：",json["msg"])
                                                        UIAlertController.showAlert(message:json["msg"].string!, in: self)
                                                    }
                                                }
                                                break
                                            case false:
                                                print(response.result.error)
                                                break
                                            }
                                            self.spinner.stopAnimating()
            }
            
        } catch {
            UIAlertController.showAlert(message: "解析异常，请稍后再试")
        }
        
    }
    
    
    let pro = UIProgressView()
    var cancelledData : Data?//用于停止下载时,保存已下载的部分
    var downloadRequest:DownloadRequest!//下载请求对象
    var destination:DownloadRequest.DownloadFileDestination!//下载文件的保存路径

    func loadData(videoUrl: String) {
        //下载的进度条显示
        Alamofire.download(videoUrl).downloadProgress(queue: DispatchQueue.main) { (progress) in
            self.pro.setProgress(Float(progress.fractionCompleted), animated: true)//下载进度条
        }
        
        //下载存储路径
        self.destination = {_,response in
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
            let fileUrl = documentsUrl?.appendingPathComponent(response.suggestedFilename!)
            print(fileUrl)

            return (fileUrl!,[.removePreviousFile, .createIntermediateDirectories] )
        }
        print("--------------")
        print(self.destination.debugDescription)
        print("--------------")
        self.downloadRequest = Alamofire.download(videoUrl, to: self.destination)
        
        self.downloadRequest.responseData(completionHandler: downloadResponse)
    }
    
    //根据下载状态处理
    func downloadResponse(response:DownloadResponse<Data>){
        switch response.result {
        case .success:
            self.saveVideoUrl(string: (response.destinationURL?.path)!)
        case .failure:
            //            self.cancelledData = response.resumeData//意外停止的话,把已下载的数据存储起来
            self.spinner.stopAnimating()
        }
    }
    
    //将下载的网络视频保存到相册
    func saveVideoUrl(string:String) {
        if string != ""{
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(string){
                UISaveVideoAtPathToSavedPhotosAlbum(string, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    ///将下载的网络视频保存到相册
    @objc func video(videoPath: String, didFinishSavingWithError error: NSError, contextInfo info: AnyObject) {
        
        if error.code != 0{
            UIAlertController.showAlert(message:"保存失败")
            print(error)
        }else{
            UIAlertController.showAlert(message:"已保存至相册")
            let vc = AVPlayerViewController()
            vc.player = AVPlayer.init(url: URL.init(fileURLWithPath: (videoPath)))
            vc.player?.play()
            self.present( vc, animated: true) {
            }
        }
        self.spinner.stopAnimating()
    }
    
    func getUrl(text:String) -> String{
        var urls = [String]()
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:
                NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            // 匹配字符串，返回结果集
            let res = dataDetector.matches(in: text,
                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                           range: NSMakeRange(0, text.count))
            // 取出结果
            for checkingRes in res {
                urls.append((text as NSString).substring(with: checkingRes.range))
            }
        }
        catch {
            print(error)
        }
        
        if urls.isEmpty {
            return ""
        } else{
            return urls[0]
        }
    }
    
    
}
