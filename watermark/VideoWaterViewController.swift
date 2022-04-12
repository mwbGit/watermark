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
import NSGIF
import LLVideoEditor
import CLImagePickerTool

class VideoWaterViewController: UIViewController{
    
    var containerView: UIView!

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
        
        let url = "http://v26-dy.ixigua.com/1706bd9da7b0c217b9cd17c210c8b260/5fbb694f/video/tos/cn/tos-cn-ve-15/cfec3abb65784ef3bb5ef13d1f440668/?a=1128&br=4893&bt=1631&cr=0&cs=0&cv=1&dr=0&ds=3&er=&l=202011231448170101980662183417904E&lr=&mime_type=video_mp4&qs=0&rc=Mzd2PGh3NnA7eDMzZ2kzM0ApNmk4PDk1ZTw6Nzs1Zzc3aWc0b2JiaV5lNnBfLS0xLS9zczE0MS8xNC0xX2BfNF4xXl86Yw%3D%3D&vl=&vr="
        let url2:URL! = URL(string:url);
        
        
//        NSGIF.optimalGIFfromURL(url2 , loopCount: 0) { (gifUrl) in
//            print("Any", gifUrl?.absoluteString)
//            let data = NSData(contentsOf: gifUrl!)
//
//            UIImageWriteToSavedPhotosAlbum(UIImage.init(data: data as! Data)!, nil, nil, nil)
//            UIAlertController.showAlert(message: "ok!")
//        }
        
        print("start------")
        selectVideo()
//        videoAddWatermarkVideoUrl(videoUrl: url)
        print("ok------")
    }
    
    @objc func selectVideo1() {
        
    }
    
    //选择视频
    @objc func selectVideo() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.isHiddenImage = true
        // 选择照片
        imagePickTool.setupImagePickerWith(MaxImagesCount: 1, superVC: self) {
            (asset,cutImage) in
            
            let aa = asset[0]
            
            CLImagePickerTool.convertAssetToAvPlayerItem(asset: asset[0], successClouse: { (playerItem) in
                DispatchQueue.main.async(execute: {
                        // 执行你的操作
                    let urlAsset:AVURLAsset = playerItem.asset as! AVURLAsset;
                    let composition = MwbMediaComposition()
                    //有动画
                    composition.imagesVideoAnimation(with: urlAsset, progress: { (progress) in
                        print("合成进度",progress)
                    }, success: {[weak self] (path) in
                        guard let `self` = self else {return}
                        print("合成后地址",path)
                    }) { (errMessage) in
                        print("合成失败",errMessage ?? "")
                        UIAlertController.showAlert(message:"合成失败")
                    }
                })
            }, failedClouse: {
                
            }) { (progress) in
                print("视频下载进度\(progress)")
            }
        }
    }
   
    func setupPath() -> String{
        var path = NSTemporaryDirectory() + UUID().uuidString + ".mov"
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(atPath: path)
        }
        return path
    }
    

    
    
    
}
