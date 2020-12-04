//
//  ImageCutViewController.swift
//  watermark
// 9宫格
//  Created by admin on 2020/10/19.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit


class ImageCutViewController: UIViewController {
    var pNum:Int? = 4
    
    var avaterImageView1: UIImageView!
    var avaterImageView2: UIImageView!
    var avaterImageView3: UIImageView!
    var avaterImageView4: UIImageView!
    var avaterImageView5: UIImageView!
    var avaterImageView6: UIImageView!
    var avaterImageView7: UIImageView!
    var avaterImageView8: UIImageView!
    var avaterImageView9: UIImageView!
    
    var avaterImageView11: UIImageView!
    var avaterImageView12: UIImageView!
    var avaterImageView13: UIImageView!
    var avaterImageView14: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.title = "图片九宫格"
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
        //4宫格
        var w = (kScreenWidth - 20) / 2
        avaterImageView11 = UIImageView.init(frame: .init(x: 10, y: topHeight2 + 100, width: w, height: w))
        avaterImageView12 = UIImageView.init(frame: .init(x: w + 11, y: topHeight2 + 100, width: w, height: w))
        avaterImageView13 = UIImageView.init(frame: .init(x: 10, y: topHeight2 + 101 + w, width: w, height: w))
        avaterImageView14 = UIImageView.init(frame: .init(x: w + 11, y: topHeight2 + 101 + w, width: w, height: w))
        
        w = (kScreenWidth - 20) / 3
        // 1-3
        avaterImageView1 = UIImageView.init(frame: .init(x: 10, y: topHeight2 + 100, width: w, height: w))
        avaterImageView1.image = UIImage.init(named: "default-image")
        avaterImageView2 = UIImageView.init(frame: .init(x: w + 11, y: topHeight2 + 100, width: w, height: w))
        avaterImageView2.image = UIImage.init(named: "default-image")
        avaterImageView3 = UIImageView.init(frame: .init(x: w + w + 12, y: topHeight2 + 100, width: w, height: w))
        avaterImageView3.image = UIImage.init(named: "default-image")
        
        // 4-6
        avaterImageView4 = UIImageView.init(frame: .init(x: 10, y: topHeight2 + 101 + w, width: w, height: w))
        avaterImageView4.image = UIImage.init(named: "default-image")
        avaterImageView5 = UIImageView.init(frame: .init(x: w + 11, y: topHeight2 + 101 + w, width: w, height: w))
        avaterImageView5.image = UIImage.init(named: "default-image")
        avaterImageView6 = UIImageView.init(frame: .init(x: w + w + 12, y:topHeight2 + 101 + w, width: w, height: w))
        avaterImageView6.image = UIImage.init(named: "default-image")
        
        // 6-9
        avaterImageView7 = UIImageView.init(frame: .init(x: 10, y: topHeight2 + 102 + w + w, width: w, height: w))
        avaterImageView7.image = UIImage.init(named: "default-image")
        avaterImageView8 = UIImageView.init(frame: .init(x: w + 11, y: topHeight2 + 102 + w + w, width: w, height: w))
        avaterImageView8.image = UIImage.init(named: "default-image")
        avaterImageView9 = UIImageView.init(frame: .init(x: w + w + 12, y:topHeight2 + 102 + w + w, width: w, height: w))
        avaterImageView9.image = UIImage.init(named: "default-image")
        
        //        avaterImageView1 = UIImageView.init(frame: .init(x: (kScreenWidth - 160)/2, y: 240, width: 100, height: 100))
        //        avaterImageView1.image = UIImage.init(named: "default-image")
        //        avaterImageView1.layer.cornerRadius  = 80
        //        avaterImageView1.layer.masksToBounds = true
        
        view.addSubview(avaterImageView1)
        view.addSubview(avaterImageView2)
        view.addSubview(avaterImageView3)
        view.addSubview(avaterImageView4)
        view.addSubview(avaterImageView5)
        view.addSubview(avaterImageView6)
        view.addSubview(avaterImageView7)
        view.addSubview(avaterImageView8)
        view.addSubview(avaterImageView9)
        view.addSubview(avaterImageView11)
        view.addSubview(avaterImageView12)
        view.addSubview(avaterImageView13)
        view.addSubview(avaterImageView14)
        
        let button = UIButton.init(frame: .init(x: kScreenWidth - 140 , y: topHeight3 , width: 100, height: 40))
        button.setTitle("九宫格", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(uploadAvaterImg9(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        view.addSubview(button)
        
        let button4 = UIButton.init(frame: .init(x: 40, y: topHeight3, width: 100, height: 40))
        button4.setTitle("四宫格", for: .normal)
        button4.setTitleColor(.white, for: .normal)
        button4.backgroundColor = .systemBlue
        button4.addTarget(self, action: #selector(uploadAvaterImg4(_:)), for: .touchUpInside)
        button4.layer.cornerRadius = 5.0
        button4.layer.masksToBounds = true
        view.addSubview(button4)
        
    }
    
    @objc func uploadAvaterImg9(_ sender: UIButton) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
        pNum = 9
        
    }
    
    @objc func uploadAvaterImg4(_ sender: UIButton) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
        pNum = 4
        
    }
    
    @objc func saveAvaterImg(_ sender: UIButton) {
        if pNum == 4 {
            UIImageWriteToSavedPhotosAlbum(avaterImageView11.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView12.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView13.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView14.image!, nil, nil, nil)
        } else {
            UIImageWriteToSavedPhotosAlbum(avaterImageView1.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView2.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView3.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView4.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView5.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView6.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView7.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView8.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(avaterImageView9.image!, nil, nil, nil)
        }
        UIAlertController.showAlert(message:"保存成功")
    }
}

extension ImageCutViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)
        let image = info[.originalImage] as! UIImage
        
        let cropperImage = RImageCropperViewController.init(num : pNum! ,originalImage: image, cropFrame: CGRect.init(x: (kScreenWidth - 300)/2, y: (kScreenHeight - 300)/2, width: 300, height: 300), limitScaleRatio: 30)
        cropperImage.delegate = self
        navigationController?.pushViewController(cropperImage, animated: true)
    }
    
}

extension ImageCutViewController : RImageCropperDelegate {
    func imageCropper(cropperViewController: RImageCropperViewController, didFinished editImg: [UIImage]) {
        if pNum == 4 {
            avaterImageView11.image = editImg[0]
            avaterImageView12.image = editImg[1]
            avaterImageView13.image = editImg[2]
            avaterImageView14.image = editImg[3]
            avaterImageView11.isHidden = false
            avaterImageView12.isHidden = false
            avaterImageView13.isHidden = false
            avaterImageView14.isHidden = false
            avaterImageView1.isHidden = true
            avaterImageView2.isHidden = true
            avaterImageView3.isHidden = true
            avaterImageView4.isHidden = true
            avaterImageView5.isHidden = true
            avaterImageView6.isHidden = true
            avaterImageView7.isHidden = true
            avaterImageView8.isHidden = true
            avaterImageView9.isHidden = true
        } else {
            avaterImageView1.image = editImg[0]
            avaterImageView2.image = editImg[1]
            avaterImageView3.image = editImg[2]
            avaterImageView4.image = editImg[3]
            avaterImageView5.image = editImg[4]
            avaterImageView6.image = editImg[5]
            avaterImageView7.image = editImg[6]
            avaterImageView8.image = editImg[7]
            avaterImageView9.image = editImg[8]
            
            avaterImageView11.isHidden = true
            avaterImageView12.isHidden = true
            avaterImageView13.isHidden = true
            avaterImageView14.isHidden = true
            
            avaterImageView1.isHidden = false
            avaterImageView2.isHidden = false
            avaterImageView3.isHidden = false
            avaterImageView4.isHidden = false
            avaterImageView5.isHidden = false
            avaterImageView6.isHidden = false
            avaterImageView7.isHidden = false
            avaterImageView8.isHidden = false
            avaterImageView9.isHidden = false
        }
        cropperViewController.navigationController?.popViewController(animated: false)
        
        let button = UIButton.init(frame: .init(x: (kScreenWidth)/2 - 50 , y: topHeight + kScreenWidth + 150, width: 100, height: 40))
        button.setTitle("保存图片", for: .normal)
        button.addTarget(self, action: #selector(saveAvaterImg(_:)), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        view.addSubview(button)
        
    }
    
    func imageCropperDidCancel(cropperViewController: RImageCropperViewController) {
        cropperViewController.navigationController?.popViewController(animated: false)
        
    }

}
