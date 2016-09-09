//
//  ImageView+MLImageDowload.swift
//  demo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit


extension UIImageView {
    func set_MLImageWithURL(_ URL:Foundation.URL,
                            placeHolder:UIImage? = nil,
                            progressBlock:MLImageDownloaderProgressBlock? = nil,
                            completionHandler:MLImageDownloaderCompletionHandler? = nil) -> Void {
        self.image = UIImage()
        if (placeHolder != nil) {
            self.image = placeHolder
        }
        
        MLImageDowloadManager.instanceManager.reciveImageResoure(URL, progressBlock: { (receivedSize, totalSize, originData) in
                progressBlock?(receivedSize, totalSize , originData)
            }) { (image, error, cacheType, imageURL, originalData) in
                self.image = image
                completionHandler?(image, error, cacheType, URL,originalData)
        }
    }
}
