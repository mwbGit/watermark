//
//  QrCodeViewController.swift
//  watermark
//
//  Created by admin on 2020/10/13.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class QrCodeViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textFilel: UITextField!
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "二维码生成"
        image.image = UIImage.init(named: "qrCode")
        
        let selectImg = UIButton.init(frame: .init(x: kScreenWidth / 2 - 50, y: BOTTOM_HEIGHT - 150, width: 100 , height: 40))
        selectImg.setTitle("保存图片", for: .normal)
        selectImg.setTitleColor(.white, for: .normal)
        selectImg.backgroundColor = .systemBlue
        selectImg.addTarget(self, action: #selector(but1), for: .touchUpInside)
        selectImg.layer.cornerRadius = 5.0
        selectImg.layer.masksToBounds = true
        self.view.addSubview(selectImg)
        textFilel.returnKeyType = UIReturnKeyType.done
        textFilel.delegate = self
    }
    
    //点击空白处关闭键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //某个textview失去了响应者，即收起键盘了
        textFilel.resignFirstResponder()
        //或注销当前view(或它下属嵌入的text fields)的first responder 状态，即可关闭其子控件键盘
        self.view?.endEditing(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view?.endEditing(false)
        return true
    }
    
    @objc func but1() {
        //校验
        if let text = textFilel.text {
            if( text.count == 0 ) {
                UIAlertController.showAlert(message: "请输入二维码内容")
                return
            }
        }
        
        let imageFile = self.image.image!
        UIImageWriteToSavedPhotosAlbum(imageFile, nil, nil, nil)
        UIAlertController.showAlert(message: "保存成功")
    }
    
    @IBAction func input(_ sender: Any) {
        if( textFilel.text!.count == 0 ) {
            return
        }
        var ourl = "https://api.pwmqr.com/qrcode/create/?url="
        ourl += textFilel.text!
        let newUrl = ourl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: newUrl)
        let data = try! Data(contentsOf: url!)
        image.image = UIImage(data: data)
    }
}
