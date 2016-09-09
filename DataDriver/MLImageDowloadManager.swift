//
//  MLImageDowloadManager.swift
//  demo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit

//下载进度
public typealias DownloadProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64 , _ originData: Data?) -> ())

private let instance = MLImageDowloadManager()

class MLImageDowloadManager {
    var imageDowloader = MLImageDowloader.defaultDownloader
    
    var imageCache = MLImageCache.sharedInstance
    
    class var instanceManager: MLImageDowloadManager {
        return instance
    }
    
    
}

// MARK: - 获取image
extension MLImageDowloadManager {
    
    func reciveImageResoure(_ URL: Foundation.URL,
                            progressBlock: DownloadProgressBlock? = nil,
                            completionHandler:MLImageDownloaderCompletionHandler? = nil) -> Void{
        self.reciveImageFromCache(URL, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    /**
     从内存中获取
     
     - parameter URL:               <#URL description#>
     - parameter progressBlock:     <#progressBlock description#>
     - parameter completionHandler: <#completionHandler description#>
     */
    func reciveImageFromCache(_ URL:Foundation.URL,
                              progressBlock: DownloadProgressBlock? = nil,
                              completionHandler:MLImageDownloaderCompletionHandler? = nil) -> Void {
        imageCache.receiveImageForKey(URL.absoluteString) { (image, cacheType) in
            if image != nil {
                completionHandler!(image, nil, cacheType, URL,nil)
            } else {
                self.reciveImageFromWithUrlToCache(URL, progressBlock: progressBlock!, completionHandler: completionHandler!)
            }
        }
    }
    
    /**
     从网络获取
     
     - parameter URL:               <#URL description#>
     - parameter progressBlock:     <#progressBlock description#>
     - parameter completionHandler: <#completionHandler description#>
     */
    func reciveImageFromWithUrlToCache(_ URL: Foundation.URL,
                                       progressBlock: @escaping DownloadProgressBlock,
                                       completionHandler:@escaping MLImageDownloaderCompletionHandler) -> Void {
        self.imageDowloader.downloaderImage(URL, progressBlock: progressBlock) { (image, error, cacheType, imageURL, originalData) in
            if (image != nil) {
                self.imageCache.storageImage(image!, originalData: originalData!, key: URL.absoluteString,isFileCache: true)
            }
            
            completionHandler(image, error, cacheType, URL,originalData)
        }
    }
}
