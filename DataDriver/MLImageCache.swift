//
//  MLImageCache.swift
//  demo
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit

public enum CacheType {
    case none, memory, disk
}

private let cacheReverseDNS = "com.jackWang.ML.ImageCache"
private let cacheIoQueue = "com.jackWang.ML.IoQueue"
private let instance = MLImageCache()

class MLImageCache {
    
    class var sharedInstance: MLImageCache {
        return instance
    }
    
    init(){
        fileManager = FileManager.default
        
        let dstPath =  NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        diskCachePath = (dstPath as NSString).appendingPathComponent(cacheReverseDNS)
        
        ioQueue = DispatchQueue(label: cacheIoQueue, attributes: [])
        
    }
    
    /// 内存缓存
    
    var memoryCache:NSCache = NSCache<AnyObject, AnyObject>()
    
    /// The largest cache cost of memory cache. The total cost is pixel count of all cached images in memory.
    var maxMemoryCost: UInt = 0 {
        didSet {
            self.memoryCache.totalCostLimit = Int(maxMemoryCost)
        }
    }
    
    /// 文件缓存
    var fileManager:FileManager! //文件
    let diskCachePath:String  //缓存路径
    
    fileprivate let ioQueue: DispatchQueue
}

extension MLImageCache {
    /**
     取得image
     
     - parameter key:               imageKey Url String
     - parameter completionHandler: 回调
     */
    func receiveImageForKey(_ key:String, completionHandler: ((UIImage?, CacheType?) -> ())?) -> Void {
        self.receiveMemeryCacheImageForKey(key) { (image, cacheType) in
            guard let image = image else {
                self.receiveFileCacheImageForKey(key, completionHandler: completionHandler)
                return
            }
            completionHandler!(image , .memory)
        }
    }
    
    /**
     存取
     
     - parameter image:     图片
     - parameter imageData: imageData
     - parameter key:       imageKey Url String
     */
    func storageImage(_ image:UIImage, originalData:Data?, key:String, isFileCache:Bool) -> Void {
        self.storageMemeryCacheImage(image, key: key)
        if isFileCache {
            self.storageFileCacheImage(image, originalData: originalData, key: key)
        }
    }
}

// MARK: - 内存缓存存取
extension MLImageCache {
    /**
     存取
     
     - parameter image:     图片
     - parameter imageData: imageData
     - parameter key:       imageKey Url String
     */
    func storageMemeryCacheImage(_ image:UIImage, key:String) -> Void {
        self.memoryCache.setObject(image, forKey: key as AnyObject)
    }
    
    /**
     取得内存中的image
     
     - parameter key:               imageKey Url String
     - parameter completionHandler: completionHandler
     */
    func receiveMemeryCacheImageForKey(_ key:String, completionHandler: ((UIImage?, CacheType?) -> ())?) -> Void {
        let image = self.memoryCache.object(forKey: key as AnyObject) as? UIImage
        completionHandler!(image , .memory)
    }
}

// MARK: - 文件缓存存取
extension MLImageCache {
    /**
     存入图片到disk
     
     - parameter data: image
     - parameter key:  key url string
     */
    func storageFileCacheImage(_ image:UIImage, originalData:Data?, key:String) -> Void {
        ioQueue.async {
            if let data = originalData {
                if !self.fileManager.fileExists(atPath: self.diskCachePath) {
                    do {
                        try self.fileManager.createDirectory(atPath: self.diskCachePath, withIntermediateDirectories: true, attributes: nil)
                    } catch _ {}
                }
                self.fileManager.createFile(atPath: self.cachePathForKey(key), contents: data, attributes: nil)
                print(self.cachePathForKey(key))
                print(try? Data(contentsOf: URL(fileURLWithPath: self.cachePathForKey(key))))
            }
        }
        print(try? Data(contentsOf: URL(fileURLWithPath: self.cachePathForKey(key))))
    }
    
    /**
     receive file cache image
     
     - parameter key:               url String
     - parameter completionHandler: completionHandler description
     */
    func receiveFileCacheImageForKey(_ key:String, completionHandler: ((UIImage?, CacheType?) -> ())?) -> Void {
//        let queue = dispatch_queue_create("tssssssss", DISPATCH_QUEUE_SERIAL)
        ioQueue.async {
            guard let image  = self.diskImageForKey(key) else {
                completionHandler!(nil , .memory)
                return
            }
            self.storageMemeryCacheImage(image, key: key)
            completionHandler!(image , .memory)
        }
    }
}

// MARK: - file path
extension MLImageCache {
    /**
     cache path
     
     - parameter key: url string
     
     - returns: cache path
     */
    func cachePathForKey(_ key: String) -> String {
        return (diskCachePath as NSString).appendingPathComponent(key.ml_MD5)
    }
    
    func diskImageForKey(_ key: String) -> UIImage? {
        guard let data = diskImageDataForKey(key) else {
            return nil
        }
        guard let image = UIImage().ml_image(data, scale: 1) else {
            return nil
        }
        return image
    }
    
    func diskImageDataForKey(_ key: String) -> Data? {
        let filePath = cachePathForKey(key)
        return (try? Data(contentsOf: URL(fileURLWithPath: filePath)))
    }
}
