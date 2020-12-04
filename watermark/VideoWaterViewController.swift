//
//  VideoWaterViewController.swift
//  watermark
//
//  Created by admin on 2020/12/3.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import AVKit
import AVFoundation

class VideoWaterViewController: UIViewController ,  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    override func viewDidLoad() {
        title = "视频加水印"
        super.viewDidLoad()
        
        //创建一个ContactAdd类型的按钮
        
        let button:UIButton = UIButton(type:.system)
        
        button.frame = CGRect(x:10, y:150, width:100, height:30)
        
        button.setTitle("选择视频", for:.normal)
        
        button.addTarget(self, action:#selector(selectVideo), for:.touchUpInside)
        
        self.view.addSubview(button)
        
        containerView = UIView(frame: CGRect(x: 5, y: 160, width: SCREEN_WIDTH - 10 , height: SCREEN_HEIGHT - 200))
        containerView.contentMode = UIView.ContentMode.scaleAspectFit
        self.view.addSubview(containerView)
    }
    
    
    
    //选择视频
    
    @objc func selectVideo() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //初始化图片控制器
            
            let imagePicker = UIImagePickerController()
            
            //设置代理
            
            imagePicker.delegate = self
            
            //指定图片控制器类型
            
            imagePicker.sourceType = .photoLibrary
            
            //只显示视频类型的文件
            
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            
            //不需要编辑
            
            imagePicker.allowsEditing = false
            
            //弹出控制器，显示界面
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            
            print("读取相册错误")
            
        }
        
    }
    
    
    
    //选择视频成功后代理
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //获取视频路径（选择后视频会自动复制到app临时文件夹下）
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        //        let image = info[.originalImage] as! UIImage
        
        let pathString = videoURL.relativePath
        
        print("视频地址：\(pathString)")
        
        //图片控制器退出
        self.dismiss(animated: true, completion: {})
        
        //播放视频文件
        
//        reviewVideo(videoURL)
        
        let wavideo = WAVideoBox()
        let img = UIImage.init(named: "vip")
        
        wavideo.appendVideo(byPath: pathString)
        wavideo.appendWaterMark(img, absoluteRect: CGRect.init(x: 100, y: 300, width: 100, height: 100))
        let videoPath = getTempPath()
        wavideo.asyncFinishEdit(byFilePath: videoPath) { (NSError) in
            print("============")
//            DispatchQueue.main.async {
                let player = AVPlayer.init(url: URL.init(fileURLWithPath: videoPath))
                self.playerViewController = AVPlayerViewController()
                self.playerViewController!.player = player
                self.containerView?.addSubview(self.playerViewController!.view)
                self.playerViewController?.view.frame = self.containerView!.bounds
                self.addChild(self.playerViewController!)
                print("+++++++++++++++++")
//            }
        }
    
    }
    
    var containerView: UIView!
    var playerViewController:AVPlayerViewController?
    
    func getTempPath () -> String {
        return NSTemporaryDirectory() + "/temp.mov"
    }
    func jKRemovefile(folderName: NSString){
      let fileManager: FileManager = FileManager.default
      let filePath = "\(folderName)"
      //移除文件
      try! fileManager.removeItem(atPath: filePath)
    }
    
    //视频播放
    
    func reviewVideo(_ videoURL: URL) {
        
        //定义一个视频播放器，通过本地文件路径初始化
        
        let player = AVPlayer(url: videoURL)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            
            playerViewController.player!.play()
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}
