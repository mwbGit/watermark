//
//  QrCodeViewController.swift
//  watermark
//
//  Created by admin on 2020/10/13.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class QrCodeViewController: UIViewController {
    
    @IBOutlet weak var textFilel: UITextField!
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "二维码生成"
        image.image = UIImage.init(named: "qrCode")
    }
    
    
    @IBAction func but(_ sender: Any) {
        print("-- but")
        //校验
        if let text = textFilel.text {
            if( text.count == 0 ) {
                alert(text:"请输入二维码内容")
                return
            }
        }
        
        let imageFile = self.image.image!
        UIImageWriteToSavedPhotosAlbum(imageFile, nil, nil, nil)
        alert(text:"成功")
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
    
    func alert(text:String){
        let alert = UIAlertController.init(title: text, message: "", preferredStyle: .alert)
        
        let okBtn = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: {
        })
    }
}
