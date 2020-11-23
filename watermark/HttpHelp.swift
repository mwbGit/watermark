//
//  HttpHelp.swift
//  watermark
//
//  Created by admin on 2020/9/17.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

import Foundation
import Alamofire
import SwiftyJSON
class HttpHelp {
    
    var videoUrl : String?
    
    let parameters:Dictionary = ["lianjie":"https://v.douyin.com/JAN2aMB/"]
    let headers = ["Content-Type":"application/x-www-form-urlencoded"]
    
    func postVideo(adress:String, completion: (String?) -> ()) {
        var video = ""
        Alamofire.request("http://api.mengweibo.com/api/video/parse", method: HTTPMethod.get,
                          parameters: ["sign":"phoneNumber", "url":adress]).responseJSON {
                            (response) in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = JSON(value)
                                    if let videoUrl = json["data"]["playAddr"].string {
                                        // 找到电话号码
                                        print("return：",videoUrl)
                                        video = videoUrl
                                    }
                                }
                                break
                            case false:
                                print(response.result.error)
                                break
                            }
                            
        }
        
        print("请求完成")
        completion(video)
    }
    
    func post(adress:String, completion: @escaping (String?) -> ()) {
        print("GET adress:",adress)
        
        // 请求地址
        let url = "https://www.douyintool.cn/post.php"
        //         let url = "http://mengweibo.com/pet/search?order=level"
        
        // 设置请求参数
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        // 填入json数据
        var paramString = "lianjie=" + adress
        // 装入request
        request.httpBody =  paramString.data(using: String.Encoding.utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        // 发送请求
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            // 处理返回数据
            if let data = data {
                do {
                    
                    let ok =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                    
                    let code:Int=ok["code"] as! Int
                    
                    if(code==0){
                        let jsonObject:AnyObject?=ok["data"] as AnyObject
                        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []){
                            
                            let newStr = String(data: jsonData, encoding: String.Encoding.utf8)
                            
                            let ok =  try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as AnyObject
                            
                            print(ok["video"] as! String)
                            self.videoUrl = ok["video"] as! String
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                semaphore.signal()
                
            }
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print("请求完成")
        completion(self.videoUrl)
    }
    
}
