//
//  MLImageDowloader.swift
//  demo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit

/// Progress update block of downloader. 下载进度
public typealias MLImageDownloaderProgressBlock = DownloadProgressBlock

/// Completion block of downloader.
public typealias MLImageDownloaderCompletionHandler = ((_ image: UIImage?, _ error: NSError?, _ cacheType: CacheType?,  _ imageURL: URL?, _ originalData: Data?) -> ())

//回调
typealias CallbackPair = (progressBlock: MLImageDownloaderProgressBlock?, completionHander: MLImageDownloaderCompletionHandler?)


private let defaultDownloaderName = "default"
private let instance = MLImageDowloader(name: defaultDownloaderName)

/// 回调
class MLImageCallbacks  {
    var callbacks = [CallbackPair]()
    var responseData = NSMutableData()
}



class MLImageDowloader {
    
    /// The duration before the download is timeout. Default is 15 seconds.
    var downloadTimeout: TimeInterval = 15.0
    
    var requestsUsePipeling = false
    
    
    var session: URLSession?
    var sessionDataTask: URLSessionDataTask?
    var sessionHandler:MLImageDownloaderSessionHandler?
    
    var fetchLoads = [URL:MLImageCallbacks]() //所有的加载
    
    
    
    
    var sessionConfiguration = URLSessionConfiguration.ephemeral {
        didSet {
            session = URLSession(configuration: sessionConfiguration, delegate: sessionHandler, delegateQueue: OperationQueue.main)
        }
    }
    
    /// 单例
    class var defaultDownloader:MLImageDowloader{
        return instance
    }
    
    
    /**
     初始化
     
     - parameter name: The name for the downloader. It should not be empty.
     
     - returns: MLImageDowloader object
     */
    init(name:String){
        sessionHandler = MLImageDownloaderSessionHandler()
        session = URLSession(configuration: sessionConfiguration, delegate: sessionHandler, delegateQueue: OperationQueue.main)
    }
}

// MARK: - dowloader
extension MLImageDowloader {
    func downloaderImage(_ URL: Foundation.URL,
                         progressBlock: @escaping MLImageDownloaderProgressBlock,
                         completionHandler:@escaping MLImageDownloaderCompletionHandler) -> Void
    {
        /// 构建 request
        var request = URLRequest(url: URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: downloadTimeout)
        request.httpShouldUsePipelining = requestsUsePipeling
    
        /// 构建 dataTask
        sessionDataTask = session?.dataTask(with: request)
        sessionDataTask?.priority = URLSessionTask.defaultPriority
        self.sessionHandler?.downloadHolder = self
        sessionDataTask?.resume()
        
        //注册回调
        registerProgressBlock(progressBlock, completionHandler: completionHandler, URL: URL)
    }
}

// MARK: - register callback
extension MLImageDowloader {
    internal func registerProgressBlock(_ progressBlock:@escaping MLImageDownloaderProgressBlock,completionHandler:@escaping MLImageDownloaderCompletionHandler, URL:Foundation.URL){
        
        //本次加载数据的回调
        let callBacks = self.fetchLoads[URL] ?? MLImageCallbacks()
        let callbackPair = CallbackPair(progressBlock: progressBlock, completionHander: completionHandler)
        callBacks.callbacks.append(callbackPair)
        
        //注册回调
        self.fetchLoads[URL] = callBacks
        
    }
    
    func fetchLoadForKey(_ URL: Foundation.URL) -> MLImageCallbacks? {
        var fetchLoad: MLImageCallbacks?
//        dispatch_sync(barrierQueue, { () -> Void in
            fetchLoad = self.fetchLoads[URL]
//        })
        return fetchLoad
    }
}




// MARK: - NSURLSessionDataDelegate 实现
class MLImageDownloaderSessionHandler: NSObject,URLSessionDataDelegate {
    var downloadHolder: MLImageDowloader?
    /**
     This method is exposed since the compiler requests. Do not call it.
     */
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }
    
    /**
     This method is exposed since the compiler requests. Do not call it.
     */
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        guard let downloader = downloadHolder else {
            return
        }
        //添加数据
        if let URL = dataTask.originalRequest?.url, let fetchLoad = downloader.fetchLoadForKey(URL) {
            fetchLoad.responseData.append(data)
            for callbackPair in fetchLoad.callbacks {
                DispatchQueue.main.async(execute: { () -> Void in
                    (callbackPair.progressBlock?(Int64(fetchLoad.responseData.length), dataTask.response!.expectedContentLength, (data as NSData) as Data))!
                })
            }
        }
    }
    
    /**
     This method is exposed since the compiler requests. Do not call it.
     */
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.callBackImage(task)
    }
    
    
    /**
     This method is exposed since the compiler requests. Do not call it.
     */
    internal func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    /**
     callback completion
     
     - parameter task: <#task description#>
     */
    func callBackImage(_ task:URLSessionTask) {
        guard let downloader = downloadHolder else {
            return
        }
        
        if let URL = task.originalRequest?.url, let fetchLoad = downloader.fetchLoadForKey(URL) {
            for callbackPair in fetchLoad.callbacks {
                DispatchQueue.main.async(execute: { () -> Void in
                    callbackPair.completionHander?(UIImage().ml_image(fetchLoad.responseData as Data, scale: 1), nil, nil, URL, fetchLoad.responseData as Data)
                })
            }
        }
    }
}
