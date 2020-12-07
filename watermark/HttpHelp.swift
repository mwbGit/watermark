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
class HttpHelp : UITableViewController{
    
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
    
    func synchronousGet() -> Bool {
            var identifierNumber:String  = (UIDevice.current.identifierForVendor?.uuidString)!
            let infoDictionary = Bundle.main.infoDictionary
            let majorVersion: String? = infoDictionary! ["CFBundleShortVersionString"] as? String
            let sign = identifierNumber + "watermarksafe"

            // 1、创建URL对象；
            let url:URL! = URL(string:"http://api.mengweibo.com/api/video/info?version=" + majorVersion! + "&deviceId=" + identifierNumber + "&sign=" + sign.md5);
            
            // 2、创建Request对象
            // url: 请求路径
            // cachePolicy: 缓存协议
            // timeoutInterval: 网络请求超时时间(单位：秒)
            let urlRequest:URLRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
            
            // 3、响应对象
            var response:URLResponse?
            
            // 4、发出请求
            do {
                
                let received =  try NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
                let dic = try JSONSerialization.jsonObject(with: received, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary //(必须写as! NSDictionary 不然会出错)
                let json = JSON(dic)
                
                print(json["data"]["vipUser"])
                // vip用户
                if let vip = json["data"]["vipUser"].bool {
                    setVip(val: vip)
                }
                if let vipDate = json["data"]["vipDate"].string {
                    setTips(val: vipDate)
                } else {
                    setTips(val: "")
                }

                if let status1 = json["data"]["status"].int {
                    print("status ok \(status1)")
                    return status1 == 102
                }
            } catch let error{
                print(error.localizedDescription);
            }
            return false
        }
}
