//
//  MyNetWorkRequest.swift
//  demo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation

enum Method: String {
    case GET = "GET"
    case POST = "POST"
}

/**
 *  网络请求
 */
struct NetWork {
    static func request(_ method: Method, url: String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), callback: @escaping (_ data: AnyObject?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        var manager = NetWorkManager(method: method, url: url, params: params, callback: callback)
        manager.resume()
    }
}

// MARK: - session
class NetWorkManager {
    
    //NSMutableURLRequest
    let method: Method!
    let params: Dictionary<String, AnyObject>
    let url:String!
    var request:NSMutableURLRequest!
    
    //NSURLSession
    let session:URLSession! = URLSession.shared
    let callback: (_ data: AnyObject?, _ response: URLResponse?, _ error: NSError?) -> Void
    var task: URLSessionTask!
    
    
    init(method:Method, url:String, params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), callback: @escaping (_ data: AnyObject?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        self.method = method
        self.params = params
        self.url = url
        self.callback = callback
        self.request = NSMutableURLRequest(url: URL(string: url)!)
    }
    
    //请求并异步返回数据
    func fireTask() {
        //weak let uSelf = self
        self.task = self.session.dataTask(with: request as URLRequest, completionHandler:  {(data, response, error) -> Void  in
            if data == nil {
                return
            }
            let json: AnyObject?
            do {
                json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
            } catch let error {
                print(error)
            }
            self.callback(json, response, error as NSError?)
        })
        task.resume()
    }
    
    func resume() -> Void {
        self.buildRequest()
        self.fireTask()
    }
}

// MARK: - 设置 request  的参数 body
extension NetWorkManager {
    func buildRequest() {
        if self.method == .GET && self.params.count > 0 {
            self.request = NSMutableURLRequest(url: URL(string: url + "?" + buildParams(self.params))!)
        }
         
        request.httpMethod = self.method.rawValue
        
        if self.params.count > 0 {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        self.buildBody()
    }
    
    //非GET
    func buildBody() {
        if self.params.count > 0 && self.method != .GET {
            request.httpBody = buildParams(self.params).data(using: String.Encoding.utf8)
        }
    }
}

// MARK: - 解析 request 的 params
extension NetWorkManager {
    // 从 Alamofire 偷了三个函数
    
    func buildParams(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    
    func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CFString = ":&=;+!@#$()',*" as CFString
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}
