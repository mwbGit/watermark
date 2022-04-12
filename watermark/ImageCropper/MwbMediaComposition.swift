//
//  MwbMediaComposition.swift
//  MwbMediaComposition
//
//  Created by 闫明 on 2019/1/16.
//  Copyright © 2019 闫明. All rights reserved.
//

import UIKit
import AVFoundation
public class MwbMediaComposition: NSObject {
    /// 视频合成后地址 默认 tmp/imagesComposition.mp4
    public var outputPath: String?
    /// 视频分辨率
    public var naturalSize: CGSize = CGSize(width: 720, height: 1280)
    /// 每张图片展示的时间
    public var picTime: Float = 3
    /// 帧率
    public var frameNumber: Int = 25
    /// 视频背景 本地地址 默认black.mp4
    public var videoResource: String?
    /// 视频原音静音
    public var isMute: Bool = false
    public typealias SuccessBlock = (String)->()
    public typealias ProgressBlock = (Float)->()
    public typealias FailureBlock = (String?)->()
    internal var timer: Timer?
    internal var assetExport: AVAssetExportSession?
    /// 视频时长 /s
    internal var duration: Float = 0
    internal var progress: ProgressBlock?
    internal var success: SuccessBlock?
    internal var failure: FailureBlock?
    deinit {
        timerDeinit()
    }
}
extension MwbMediaComposition {
    
    /// 图片合成视频 切换特效
    ///
    /// - Parameters:
    ///   - images: 图片数组
    ///   - progress: 进度回调
    ///   - success: 成功回调 合成视频地址
    ///   - failure: 失败回调
    public func imagesVideoAnimation(with videoAsset:AVURLAsset, progress: ProgressBlock?, success: SuccessBlock?, failure: FailureBlock?){
        guard let videoPath = videoResource == nil ? Bundle.main.path(forResource: "black", ofType: "mp4") : videoResource else {
            failure?("资源出错")
            return
        }
        //视频的时长 - (图片个数 * 每张图片的展示时间) 目前默认背景视频3分钟 仅支持不超过3分钟
//        let tempDuration = Float(images.count) * picTime + Float(0.1 * Float(images.count))
//        self.duration = tempDuration > 180.0 ? 180.0 : tempDuration
        self.progress = progress
        self.failure = failure
        self.success = success
        self.outputPath = NSTemporaryDirectory() + "imagesComposition.mp4"
//        let videoAsset = AVURLAsset(url: URL(fileURLWithPath: videoPath))
        let mutableComposition = AVMutableComposition()
        guard let videoCompositionTrack = mutableComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid), let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first else {
            failure?("视频轨道出错")
            return
        }
        //合成视频时间
//        let endTime = CMTime(value: CMTimeValue(videoAsset.duration.timescale * Int32(duration)), timescale: videoAsset.duration.timescale)
        let endTime = CMTimeRange(start: .zero, duration: videoAsset.duration)

//        let timeR = CMTimeRangeMake(start: .zero, duration: endTime)
        do {
            try videoCompositionTrack.insertTimeRange(endTime, of:videoAssetTrack , at:.zero)
        }catch {
            failure?(error.localizedDescription)
            return
        }
        //创建合成指令
        let videoCompostionInstruction = AVMutableVideoCompositionInstruction()
        //设置时间范围
        videoCompostionInstruction.timeRange = CMTimeRange(start: .zero, duration: videoAsset.duration)
        //创建层指令，并将其与合成视频轨道相关联
        let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoCompositionTrack)
        videoLayerInstruction.setTransform(videoAssetTrack.preferredTransform, at: .zero)
        videoLayerInstruction.setOpacity(0, at: videoAssetTrack.asset!.duration)
        videoCompostionInstruction.layerInstructions = [videoLayerInstruction]
        //创建视频组合
        var isVideoAssetPortrait = false;
               let videoTransform = videoAssetTrack.preferredTransform;
               if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
                   isVideoAssetPortrait = true;
               }
               if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
                   isVideoAssetPortrait = true;
               }
        let naturalSize:CGSize;
        if(isVideoAssetPortrait){
            naturalSize = CGSize(width: videoAssetTrack.naturalSize.height, height: videoAssetTrack.naturalSize.width);
        } else {
            naturalSize = videoAssetTrack.naturalSize;
        }
        let renderWidth = naturalSize.width;
        let renderHeight = naturalSize.height;
        let mutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.renderSize = CGSize(width: renderWidth, height: renderHeight);
        //设置帧率
        mutableVideoComposition.frameDuration = CMTime(value: 1, timescale: CMTimeScale(frameNumber))
        mutableVideoComposition.instructions = [videoCompostionInstruction]
       
        addWaterLayer(mutableVideoComposition, size: mutableVideoComposition.renderSize)
        
//        addLayer(mutableVideoComposition, imgs: images)
        setupAssetExport(mutableComposition, videoCom: mutableVideoComposition)
    }
    
    public func addWaterLayer(_ composition: AVMutableVideoComposition, size:CGSize)
    {
        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height);
//        bgLayer.masksToBounds = true
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        
        let subtitle1Text = CATextLayer()
        
        let fontName:CFString = "Noteworthy-Light" as CFString
        subtitle1Text.font = CTFontCreateWithName(fontName, 20, nil)
        subtitle1Text.fontSize = 36
        subtitle1Text.frame = CGRect(x: (size.width - 80)/2, y: (size.height-80)/2, width: 200, height: 180);
        subtitle1Text.alignmentMode = CATextLayerAlignmentMode.center
        subtitle1Text.foregroundColor = UIColor.blue.cgColor
        subtitle1Text.backgroundColor = UIColor.blue.cgColor
        subtitle1Text.string = "哈哈这是水印"
        subtitle1Text.isWrapped = true
        subtitle1Text.contentsScale = UIScreen.main.scale
        bgLayer.addSublayer(subtitle1Text)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(bgLayer)

        composition.animationTool = AVVideoCompositionCoreAnimationTool.init(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    /// 图片合成视频 没效果
    public func imagesVideo(with images:[UIImage?], progress: ProgressBlock?, success: SuccessBlock?, failure: FailureBlock?){
        //先将图片转换成CVPixelBufferRef
        let imgs = images.compactMap { (image) -> CVPixelBuffer? in
            guard let image = image else {return nil}
            let newImage = self.fitImage(image)
            let buffer = newImage.mc_pixelBufferRef(size: self.naturalSize)
            return buffer
        }
        do {
            self.outputPath = NSTemporaryDirectory() + "imagesComposition.mp4"
            let path = setupPath()
            let size = self.naturalSize
            let outputURL = URL(fileURLWithPath: path)
            let assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mov)
            let outPutSettingDic = [
                AVVideoCodecKey: AVVideoCodecH264,
                AVVideoWidthKey: size.width * UIScreen.main.scale,
                AVVideoHeightKey: size.height * UIScreen.main.scale
                ] as [String : Any]
            let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: outPutSettingDic)
            let sourcePixelBufferAttributes = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA] as [String : Any]
            let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributes)
            if assetWriter.canAdd(videoWriterInput){
                assetWriter.add(videoWriterInput)
                assetWriter.startWriting()
                assetWriter.startSession(atSourceTime: CMTime.zero)
            }
            var index = -1
            let frame: Int = self.frameNumber
            //总时间
            let seconds: Float64 = Float64(self.picTime) * Float64(imgs.count)
            let start = CFAbsoluteTimeGetCurrent()
            videoWriterInput.requestMediaDataWhenReady(on: DispatchQueue.global()) {
                while videoWriterInput.isReadyForMoreMediaData{
                    //Thread.sleep(forTimeInterval: 0.1)
                    index = index + 1
                    if index >= imgs.count * frame {
                        videoWriterInput.markAsFinished()
                        assetWriter.finishWriting(completionHandler: {
                            let end = CFAbsoluteTimeGetCurrent()
                            print("无特效图片合成耗时", end - start)
                            success?(path)
                        })
                        break
                    }
                    let idx = index / frame
                    let buffer = imgs[idx]
                    let time = CMTime(value: CMTimeValue(index), timescale: CMTimeScale(frame))
                    if adaptor.append(buffer , withPresentationTime: time) {
                        
                        if index <= images.count * frame {
                            let p = Float(index) / Float(imgs.count * frame)
                            // print(index, imgs.count * frame, p)
                            progress?(p)
                        }
                    }else {
                        print("写入CVPixelBufferRef失败")
                    }
                }
            }
        } catch {
            failure?(error.localizedDescription)
            return
        }
    }
}
extension MwbMediaComposition {
    internal func setupAssetExport(_ mutableComposition: AVMutableComposition, videoCom: AVMutableVideoComposition?, audioMix: AVMutableAudioMix? = nil){
        let path = setupPath()
        self.assetExport = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileType.mp4
        assetExport?.outputURL = URL(fileURLWithPath: path)
        assetExport?.shouldOptimizeForNetworkUse = true
        assetExport?.videoComposition = videoCom
        assetExport?.audioMix = audioMix
        setupTimer()
        let start = CFAbsoluteTimeGetCurrent()
        assetExport?.exportAsynchronously(completionHandler: {[weak self] in
            guard let `self` = self, let export = self.assetExport else {return}
            self.timerDeinit()
            switch export.status {
            case .completed:
                self.success?(path)
                let end = CFAbsoluteTimeGetCurrent()
                print("合成耗时", end - start)
                break
            default:
                print(export.status)
                self.failure?("合成失败")
                break
            }
        })
    }
}
// MARK: - 图片切换效果
extension MwbMediaComposition {
    private func addLayer(_ composition: AVMutableVideoComposition, imgs: [UIImage?]){
        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
        bgLayer.position = CGPoint(x: naturalSize.width / 2, y: naturalSize.height / 2)
        var imageLayers: [CALayer] = []
        for temp in imgs {
            let imageL = CALayer()
            imageL.contents = temp?.cgImage
            imageL.bounds = CGRect(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
            imageL.contentsGravity = .resizeAspect
            imageL.backgroundColor = UIColor.black.cgColor
            imageL.anchorPoint = CGPoint.init(x: 0, y: 0)
            bgLayer.addSublayer(imageL)
            imageLayers.append(imageL)
        }
        positionAni(layers: imageLayers)
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(bgLayer)
//        let subtitle1Text = CATextLayer()
//        //        subtitle1Text.font = CFTypeRef.
//        subtitle1Text.fontSize = 36
//        subtitle1Text.frame = CGRect(x: 0, y: 0, width: naturalSize.width, height: 100);
//        subtitle1Text.alignmentMode = CATextLayerAlignmentMode.center
//        subtitle1Text.foregroundColor = UIColor.red.cgColor
//        subtitle1Text.string = "哈哈  这是水印"
//        parentLayer.addSublayer(subtitle1Text)
        parentLayer.isGeometryFlipped = true
        composition.animationTool = AVVideoCompositionCoreAnimationTool.init(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
       
    }
    private func positionAni(layers: [CALayer]){
        for (index, layer) in layers.enumerated() {
            let animation = CABasicAnimation()
            animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            animation.isRemovedOnCompletion = false
            animation.beginTime = 0.1 + Double(picTime * Float(index))
            animation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: naturalSize.width * CGFloat(index), y: 0))
            animation.toValue = NSValue.init(cgPoint: CGPoint.init(x: 0, y: 0))
            animation.duration = 0.1
            animation.fillMode = .both
            layer.add(animation, forKey: "position")
        }
    }
    private func positionAni1(layer: CATextLayer){
            let animation = CABasicAnimation()
            animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            animation.isRemovedOnCompletion = false
            animation.beginTime = 0.1 + 0
            animation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: naturalSize.width * 0, y: 0))
            animation.toValue = NSValue.init(cgPoint: CGPoint.init(x: 0, y: 0))
            animation.duration = 0.1
            animation.fillMode = .both
            layer.add(animation, forKey: "position")
        
    }

}
// MARK: - Timer
extension MwbMediaComposition {
    private func setupTimer(){
        self.timer = Timer(timeInterval: 0.05, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: .common)
    }
    @objc private func timerAction(){
        guard let export = self.assetExport else { return }
        self.progress?(export.progress)
    }
    private func timerDeinit(){
        self.timer?.invalidate()
        self.timer = nil
    }
}
extension MwbMediaComposition {
    private func setupPath() -> String{
        var path = NSTemporaryDirectory() + "imagesComposition.mp4"
        if let outputPath = outputPath {
            path = outputPath
        }
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(atPath: path)
        }
        return path
    }
    private func fitImage(_ image: UIImage) -> UIImage{
        guard let bg = UIImage(named: "canvas") else {return image}
        UIGraphicsBeginImageContextWithOptions(bg.size, false, UIScreen.main.scale)
        bg.draw(in: CGRect(x: 0, y: 0, width: bg.size.width, height: bg.size.height))
        let imageScale = image.size.width / image.size.height
        let bgScale = CGFloat(9) / CGFloat(16)
        if imageScale > bgScale {//上下黑边
            let h = bg.size.width * image.size.height / image.size.width
            image.draw(in: CGRect(x: 0, y: (bg.size.height - h) / 2, width: bg.size.width, height: h))
        }else if imageScale < bgScale{//左右黑边
            image.draw(in: CGRect(x: 0, y: 0, width: bg.size.width, height: bg.size.height))
        }else {
            image.draw(in: CGRect(x: 0, y: 0, width: bg.size.width, height: bg.size.height))
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
}
extension MwbMediaComposition {
    public func imagePicker(url: URL, progress: ProgressBlock?, success: SuccessBlock?, failure: FailureBlock?){
        self.progress = progress
        let urlAsset = AVURLAsset(url: url)
        
        self.assetExport = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality)
        let outputPath = NSTemporaryDirectory() + "imagePickerComposition.mp4"
        if FileManager.default.fileExists(atPath: outputPath) {
            try? FileManager.default.removeItem(atPath: outputPath)
        }
        self.assetExport?.outputFileType = AVFileType.mp4
        self.assetExport?.outputURL = URL(fileURLWithPath: outputPath)
        setupTimer()
        let start = CFAbsoluteTimeGetCurrent()
        assetExport?.exportAsynchronously(completionHandler: {[weak self] in
            guard let `self` = self, let export = self.assetExport else {return}
            self.timerDeinit()
            switch export.status {
            case .completed:
                success?(outputPath)
                let end = CFAbsoluteTimeGetCurrent()
                print("合成耗时", end - start)
                break
            default:
                print(export.status)
                failure?("合成失败")
                break
            }
        })
    }
}
