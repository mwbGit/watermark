//
//  GuideViewController.swift
//  watermark
//
//  Created by admin on 2020/11/21.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "去水印教程"
        // Do any additional setup after loading the view.
        let step1 = UILabel()
        step1.text = "步骤1：进入短视频平台，点击分享。"
        step1.font = UIFont.systemFont(ofSize: 15)
        step1.frame = CGRect(x: 5, y: 10, width: SCREEN_WIDTH, height: 30)
        containerView.addSubview(step1)
        let image1 = UIImageView()
        image1.image = UIImage.init(named: "step1")
        image1.frame = CGRect(x:5, y: 50, width: SCREEN_WIDTH - 10, height: (SCREEN_WIDTH - 10) * 2.18)
        containerView.addSubview(image1)
        let height = image1.frame.height;
        
        let step2 = UILabel()
        step2.text = "步骤2：点击复制链接。"
        step2.font = UIFont.systemFont(ofSize: 15)
        step2.frame = CGRect(x: 5, y: height + 60, width: SCREEN_WIDTH, height: 30)
        containerView.addSubview(step2)
        let image2 = UIImageView()
        image2.image = UIImage.init(named: "step2")
        image2.frame = CGRect(x: 5, y: height + 90, width: SCREEN_WIDTH - 10, height: height)
        containerView.addSubview(image2)
        
        let step3 = UILabel()
        step3.text = "步骤3：打开水印专家，点击视频去水印，粘贴链接。"
        step3.font = UIFont.systemFont(ofSize: 15)
        step3.frame = CGRect(x: 5, y: height + height + 100, width: SCREEN_WIDTH, height: 40)
        step3.numberOfLines = 0
        step3.lineBreakMode = NSLineBreakMode.byWordWrapping
        containerView.addSubview(step3)
        let image3 = UIImageView()
        image3.image = UIImage.init(named: "step3")
        image3.frame = CGRect(x: 5, y: height + height + 140, width: SCREEN_WIDTH - 10, height: height)
        containerView.addSubview(image3)
        
    }
    
    
}
