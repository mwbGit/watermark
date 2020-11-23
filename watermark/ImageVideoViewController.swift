//
//  ImageVideoViewController.swift
//  watermark
// 图片合成
//  Created by admin on 2020/10/20.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaComposition
import CLImagePickerTool

class ImageVideoViewController: UIViewController {

    var playerViewController:AVPlayerViewController?
    
    var spinner: UIActivityIndicatorView!
    
    var videoUrl = ""
    var saveBut: UIButton!
    var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "视频合成"
        // 选择
        let selectBut = UIButton.init(frame: .init(x: 20, y: 100, width: 100 , height: 40))
        selectBut.setTitle("选择图片", for: .normal)
        selectBut.setTitleColor(.white, for: .normal)
        selectBut.backgroundColor = .systemBlue
        selectBut.addTarget(self, action: #selector(compose), for: .touchUpInside)
        selectBut.layer.cornerRadius = 5.0
        selectBut.layer.masksToBounds = true
        self.view.addSubview(selectBut)
        
        // 提取
        saveBut = UIButton.init(frame: .init(x: SCREEN_WIDTH - 120, y: 100, width: 100 , height: 40))
        saveBut.setTitle("保存视频", for: .normal)
        saveBut.setTitleColor(.white, for: .normal)
        saveBut.backgroundColor = .systemBlue
        saveBut.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveBut.isHidden = true
        saveBut.layer.cornerRadius = 5.0
        saveBut.layer.masksToBounds = true
        self.view.addSubview(saveBut)

        containerView = UIView(frame: CGRect(x: 5, y: 160, width: SCREEN_WIDTH - 10 , height: SCREEN_HEIGHT - 200))
        self.view.addSubview(containerView)
        
        compose()
    }
    
    // 合成视频
    @objc func compose() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.isHiddenVideo = true

        // 选择照片
        imagePickTool.setupImagePickerWith(MaxImagesCount: 10, superVC: self) {
            (asset,cutImage) in
            var imageArr = [UIImage]()
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {(image,assetItem) in
                imageArr.append(image)
            }, failedClouse: { () in
                PopViewUtil.share.stopLoading()
                self.alert(text:"合成失败")
            })
            
            // 合成
            if !imageArr.isEmpty {
                let composition = MediaComposition()
                composition.picTime = 2
                //有动画
                composition.imagesVideoAnimation(with: imageArr, progress: { (progress) in
                    print("合成进度",progress)
                }, success: {[weak self] (path) in
                    guard let `self` = self else {return}
                    print("合成后地址",path)
                    self.videoUrl = path
                    self.loadPlayer(videoUrl: path)
                }) { (errMessage) in
                    print("合成失败",errMessage ?? "")
                    self.alert(text:"合成失败")
                }
            }
            
        }
        
    }
    
    // 视频保存
    @objc func save() {
        if videoUrl.isEmpty {
            alert(text: "请先选择照片")
            return
        }
        self.saveVideoUrl(string : videoUrl)
    }

    
    // 加载播放器
    func loadPlayer(videoUrl : String) -> Void {
        DispatchQueue.main.async {
            let player = AVPlayer.init(url: URL.init(fileURLWithPath: (videoUrl)))
            self.playerViewController = AVPlayerViewController()
            self.playerViewController!.player = player
            self.containerView?.addSubview(self.playerViewController!.view)
            self.playerViewController?.view.frame = self.containerView!.bounds
            self.addChild(self.playerViewController!)
            self.saveBut.isHidden = false
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
            alert(text:"保存失败")
            print(error)
        }else{
            alert(text:"保存成功")
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
