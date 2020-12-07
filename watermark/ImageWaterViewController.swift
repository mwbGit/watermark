//
//  ImageWaterViewController.swift
//  watermark
//
//  Created by admin on 2020/11/26.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class ImageWaterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    var imageView: UIImageView!
    var markColor:UIColor = UIColor.orange
    var markFont:UIFont = UIFont.systemFont(ofSize: 30)
    var oldImage:UIImage!
    var textField:UITextField!
    var observer : StoreObserver? //内购监听器

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图片加水印"
        
        let selectImg = UIButton.init(frame: .init(x: 5, y: topHeight, width: 120 , height: 40))
        selectImg.setTitle("选择图片", for: .normal)
        selectImg.setTitleColor(.white, for: .normal)
        selectImg.backgroundColor = .systemBlue
        selectImg.addTarget(self, action: #selector(compose), for: .touchUpInside)
        selectImg.layer.cornerRadius = 5.0
        selectImg.layer.masksToBounds = true
        self.view.addSubview(selectImg)
        
        let addWater = UIButton.init(frame: .init(x: (SCREEN_WIDTH / 2) - 60, y: topHeight, width: 120 , height: 40))
        addWater.setTitle("生成水印", for: .normal)
        addWater.setTitleColor(.white, for: .normal)
        addWater.backgroundColor = .systemBlue
        addWater.addTarget(self, action: #selector(goParse), for: .touchUpInside)
        addWater.layer.cornerRadius = 5.0
        addWater.layer.masksToBounds = true
        self.view.addSubview(addWater)
        
        let saveImg = UIButton.init(frame: .init(x: SCREEN_WIDTH - 125, y: topHeight, width: 120 , height: 40))
        saveImg.setTitle("保存", for: .normal)
        saveImg.setTitleColor(.white, for: .normal)
        saveImg.backgroundColor = .systemBlue
        saveImg.addTarget(self, action: #selector(save), for: .touchUpInside)
        (saveImg).layer.cornerRadius = 5.0
        (saveImg).layer.masksToBounds = true
        self.view.addSubview(saveImg)
        
        textField = UITextField.init(frame: .init(x: 5, y: topHeight + 60, width: 120 , height: 40))
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.textAlignment = .center //水平居中对齐
        textField.clearButtonMode = .always  //编辑后出现清除按钮
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.placeholder = "水印内容"
        textField.text = "-水印-"
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        self.view.addSubview(textField)
        
        imageView =  UIImageView.init(frame: .init(x: 0, y: topHeight + 110, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 240));
        imageView.contentMode = UIView.ContentMode.scaleAspectFit

        self.view.addSubview(imageView)
        self.observer = StoreObserver.shareStoreObserver()
        
        setupFirst()
        setupTwo()
        compose()
    }
    
    //点击空白处关闭键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //某个textview失去了响应者，即收起键盘了
        print(111)
        textField.resignFirstResponder()
        //或注销当前view(或它下属嵌入的text fields)的first responder 状态，即可关闭其子控件键盘
        self.view?.endEditing(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view?.endEditing(false)
        return true
    }
    
    @objc  func save(){
        if (oldImage == nil) {
            UIAlertController.showAlert(message: "请先选择图片", in: self)
            return
        }
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        UIAlertController.showAlert(message: "保存成功", in: self)
    }
    
    
    @objc  func goParse(){
        if (oldImage == nil) {
            UIAlertController.showAlert(message: "请先选择图片", in: self)
            return
        }
        
        imageView.image = getWaterMark(oldImage, icon: nil, title: textField.text!, andMark: markFont, andMark: markColor)
    }
    
    @objc func compose() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController.init()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        } else {
            UIAlertController.showAlert(message: "无图片可选", in: self)
        }
    }
    
    var titles: [(String, UIColor?)] = [
        ("橙色", UIColor.orange),
        ("黄色", UIColor.yellow),
        ("红色", UIColor.red),
        ("蓝色", UIColor.blue),
        ("黑色", UIColor.black),
        ("绿色", UIColor.green),
        ("棕色", UIColor.brown),
        ("紫色", UIColor.purple),
        ("灰色", UIColor.gray),
        ("白色", UIColor.white)
        
    ]
    
    var titles1: [(String, CGFloat?)] = [
        ("小字", 30),
        ("中字", 50),
        ("大字", 70),
        ("特大", 90)
    ]
    
    /// 颜色
    private func setupFirst() {
        let mTextField = UITextField()
        mTextField.isEnabled = false
        mTextField.text = "橙色"
        mTextField.textAlignment = .center //水平居中对齐
        
        let textField = DropBoxTextField(frame: CGRect(x: (SCREEN_WIDTH / 2) - 60, y: topHeight + 60, width: 120, height: 40), customTextField: mTextField)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        /// 设置选项内容
        textField.count = titles.count
        textField.itemForRowAt = { [weak self] (index) -> (String, UIImage?) in
            guard let title = self?.titles[index].0 else {
                return ("", nil)
            }
            return (title, nil);
        }
        textField.didSelectedAt = { (index, title, textField) in
            textField.drawUp()
            self.markColor = self.titles[index].1!
            self.goParse()
        }
        view.addSubview(textField)
    }
    
    /// 字号
    private func setupTwo() {
        let mTextField = UITextField()
        mTextField.isEnabled = false
        mTextField.text = "小字"
        let textField = DropBoxTextField(frame: CGRect(x: SCREEN_WIDTH - 125, y: topHeight + 60, width: 120, height: 40), customTextField: mTextField)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        /// 设置选项内容
        textField.count = titles1.count
        textField.itemForRowAt = { [weak self] (index) -> (String, UIImage?) in
            guard let title = self?.titles1[index].0 else {
                return ("", nil)
            }
            return (title, nil);
        }
        textField.didSelectedAt = { (index, title, textField) in
            textField.drawUp()
            self.markFont = UIFont.systemFont(ofSize: self.titles1[index].1!)
            self.goParse()
        }
        view.addSubview(textField)
    }
    
    func getWaterMark(_ originalImage: UIImage?,icon:UIImage?, title: String, andMark markFont: UIFont, andMark markColor: UIColor) -> UIImage? {
        let HORIZONTAL_SPACE: CGFloat = 130
        let VERTICAL_SPACE: CGFloat = 150
        var font: UIFont? = markFont
        if font == nil {
            font = UIFont.systemFont(ofSize: 23)
        }
        var color: UIColor? = markColor
        if color == nil {
            color = UIColor.blue
        }
        //原始image的宽高
        guard let viewWidth = originalImage?.size.width, let viewHeight = originalImage?.size.height else { return nil }
        //为了防止图片失真，绘制区域宽高和原始图片宽高一样
        UIGraphicsBeginImageContext(CGSize(width: viewWidth, height: viewHeight))
        //先将原始image绘制上
        originalImage?.draw(in: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
        let sqrtLength = sqrt(viewWidth * viewWidth + viewHeight * viewHeight)
        let attrStr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : markColor, NSAttributedString.Key.font: markFont])
        //绘制文字的宽高
        let strWidth = attrStr.size().width
        let strHeight = attrStr.size().height
        
        //开始旋转上下文矩阵，绘制水印文字
        let context = UIGraphicsGetCurrentContext()
        
        //将绘制原点（0，0）调整到源image的中心
        context?.concatenate(CGAffineTransform(translationX: viewWidth / 2, y: viewHeight / 2))
        //以绘制原点为中心旋转
        context?.concatenate(CGAffineTransform(rotationAngle: CGFloat(Double.pi / 7.0)))
        //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
        context?.concatenate(CGAffineTransform(translationX: -viewWidth / 2, y: -viewHeight / 2))
        
        //计算需要绘制的列数和行数
        let horCount: Int = Int(sqrtLength / CGFloat(strWidth + HORIZONTAL_SPACE)) + 1
        let verCount: Int = Int(sqrtLength / CGFloat(strHeight + VERTICAL_SPACE)) + 1
        //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
        let orignX: CGFloat = -(sqrtLength - viewWidth) / 2
        let orignY: CGFloat = -(sqrtLength - viewHeight) / 2
        //在每列绘制时X坐标叠加
        var tempOrignX: CGFloat = orignX
        //在每行绘制时Y坐标叠加
        var tempOrignY: CGFloat = orignY
        let iconW = icon != nil ? strHeight : 0
        let iconL = iconW == 0 ? 0 : iconW + 5
        for i in 0..<horCount * verCount {
            if icon != nil {
                icon?.draw(in: CGRect(x: tempOrignX, y: tempOrignY, width: strHeight, height: strHeight), blendMode: CGBlendMode.hardLight, alpha: 0.9)
            }
            title.draw(in: CGRect(x: tempOrignX+iconL, y: tempOrignY, width: strWidth, height: strHeight), withAttributes: [NSAttributedString.Key.foregroundColor : markColor, NSAttributedString.Key.font: markFont])
            if i % horCount == 0 && i != 0 {
                tempOrignX = orignX + ( i%2 == 0 ? (strWidth+HORIZONTAL_SPACE)*0.5 : 0)//是否隔行错开
                tempOrignY += strHeight + VERTICAL_SPACE
            } else {
                tempOrignX += strWidth + HORIZONTAL_SPACE
            }
        }
        //根据上下文制作成图片
        let finalImg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImg
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        oldImage = selectedImage
        goParse()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
