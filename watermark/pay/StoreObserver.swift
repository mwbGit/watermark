//
//  StoreObserver.swift
//  SwiftStoreKit
//
//  Created by 孙翠花 on 2020/5/12.
//  Copyright © 2020 孙翠花. All rights reserved.
//

import UIKit
import StoreKit

let  ProductsLoadedSucessNotification = "ProductsLoadedSucess"  //产品加载成功
let  ProductPurchaseFailedNotification = "ProductPurchaseFailed" //失败
let  ProductPurchasedNotification = "ProductPurchased" //购买
let  ProductRestoreNotification = "ProductRestore" //重新购买

let VERIFY_RECEIPT_URL = "https://buy.itunes.apple.com/verifyReceipt"
let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"

class StoreObserver: NSObject,SKProductsRequestDelegate, SKPaymentTransactionObserver {

    static var putchaseArray = [SKProduct]() //存放内购产品

    //内购单例
    static var  storeObserver : StoreObserver?
    class func shareStoreObserver() ->StoreObserver {
        if storeObserver == nil {
            storeObserver = StoreObserver()
        }
        return storeObserver!
    }
    
    //创建监听
  public  func create() {
        SKPaymentQueue.default().add(self)
    }
    
    //销毁监听
   public func destroy() {
        SKPaymentQueue.default().remove(self)
    }
    
    //判断能否支付
   public func canMakePay() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    //请求所有的产品
   public func requestProductDataWithIds(productIds:Array<String>) {
        
        if canMakePay() == true {
            print("允许程序内购买")
            let setProductIds = NSSet(array: productIds) as! Set<String>
            // 2.向苹果发送请求，请求所有可买的商品
            // 2.1.创建请求对象
            let productsRequest = SKProductsRequest(productIdentifiers: setProductIds)
            // 2.2.设置代理(在代理方法里面获取所有的可卖的商品)
            productsRequest.delegate = self
            // 2.3.开始请求
            productsRequest.start()
        }else{
            print("不允许程序内购买")
        }
    }
    
    //按照价格从低到高排序
    func soreWithPrice(products : Array<SKProduct>) -> Array<SKProduct> {
       var result = products
        for index in 0 ..< (result.count - 1) {
            let firstInt = result[index].price as! Int
            let priceInt = result[index + 1].price as! Int
            if firstInt > priceInt {
                let temp = result[index]
                result[index] = result[index + 1]
                result[index + 1] = temp
            }
        }
        return result
    }
    
    //SKProductsRequestDelegate 获取产品代理
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let productsArray = response.products
        print("无效产品Product ID:\(response.invalidProductIdentifiers)")
        
        if productsArray.count <= 0 {
            print("没有有效的产品")
            return
        }else {
            //打印内购产品信息
            for productInfo in productsArray {
                print("内购产品信息")
                print("SKProduct 描述信息：\(productInfo.description)")
                print("localizedTitle 产品标题：\(productInfo.localizedTitle)")
                print("localizedDescription 产品描述信息：：\(productInfo.localizedDescription)")
                print("price 价格：\(productInfo.price)")
                print("productIdentifier Product id：\(productInfo.productIdentifier)")
            }
            StoreObserver.putchaseArray = productsArray
//            let soreProductsArray = soreWithPrice(products: productsArray)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ProductsLoadedSucessNotification), object: productsArray)
        }
    }
    public func count () -> Int {
        return StoreObserver.putchaseArray.count
    }
    
    public func canBuy () -> Bool {
        return !StoreObserver.putchaseArray.isEmpty
    }
    
    //产品请求失败
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ProductPurchaseFailedNotification), object: nil,userInfo: ["code":error.localizedDescription])
    }
    
    // 购买对应的产品
//    public func buyProduct(product: SKProduct) {
//        let  payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//    }
    
    public func buyProduct(index: Int) {
        if canBuy() && index < StoreObserver.putchaseArray.count {
            let  sKProduct = StoreObserver.putchaseArray[index]
            let  payment = SKPayment(product: sKProduct)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    let defaults = UserDefaults.standard

    //SKPaymentTransactionObserver   交易代理
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if SKPaymentTransactionState.purchasing == transaction.transactionState {
                print("-----商品添加进列表 --------")
            }else if SKPaymentTransactionState.deferred == transaction.transactionState {
                print("-----交易延期—－－－－")
            }else if SKPaymentTransactionState.purchased == transaction.transactionState {
                print("-----交易完成 --------")
                defaults.set(true, forKey: "vip")
                completeTransaction(transaction: transaction)
            }else if SKPaymentTransactionState.failed == transaction.transactionState {
                print("-----交易失败 --------")
                failedTransaction(transaction: transaction)
            }else if SKPaymentTransactionState.restored == transaction.transactionState {
                print("-----已经购买过该商品 --------")
                defaults.set(true, forKey: "vip")
                restoreTransaction(transaction: transaction)
            }
        }
    }
    
    //以下是交易状态
    
    //交易完成在这里完成苹果验证
    func completeTransaction(transaction:SKPaymentTransaction){
//        let environmentStr = String(data: transaction, encoding: .utf8)
         // 验证凭据，获取到苹果返回的交易凭据
         // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        let receiptURL = Bundle.main.appStoreReceiptURL
        
         // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOf: receiptURL!)
         
        // 发送网络POST请求，对购买凭据进行验证
        var urls : URL?
        let receiptURLString = receiptURL?.absoluteString
        if receiptURLString?.contains("sandbox") == true { //判断是沙盒路径还是正式环境
            urls = URL(string: ITMS_SANDBOX_VERIFY_RECEIPT_URL)
        }else{
            urls = URL(string: VERIFY_RECEIPT_URL)
        }
         
         // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
        var requset = URLRequest(url: urls!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        requset.httpMethod = "POST"
        
         // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
         // 传输的是BASE64编码的字符串
         /**
             BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
             BASE64是可以编码和解码的
         */
        
         let encodeStr = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
         
         let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\"}")
//         print(payload)
        let payloadData = payload.data(using: String.Encoding.utf8.rawValue)
        
        requset.httpBody = payloadData;
        weak var weakSelf = self //避免循环引用
        let result = URLSession.shared.dataTask(with: requset) { (data, response, error) in
            if data == nil{
                print("验证失败")
                return
            }
            
            if response == nil {
                print("验证失败")
                return
            }
            
            let dict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            if dict != nil {
//                print(dict!)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ProductPurchasedNotification), object: nil)
            weakSelf?.finishTransaction(transaction: transaction)
 
            
        }
        
        result.resume()
         
    }
    
    //交易结束
    func finishTransaction(transaction:SKPaymentTransaction){
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    //交易失败
    func failedTransaction(transaction:SKPaymentTransaction) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ProductPurchaseFailedNotification), object: nil,userInfo: ["code":transaction.error!.localizedDescription])
        print(transaction.error as Any)
        finishTransaction(transaction: transaction)
    }
    
    //交易恢复处理
    func restoreTransaction(transaction:SKPaymentTransaction) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ProductRestoreNotification), object: nil)
        print("已经购买过该商品 --- 交易恢复处理")
        
    }
}





