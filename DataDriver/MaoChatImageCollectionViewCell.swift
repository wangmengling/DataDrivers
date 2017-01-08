//
//  MaoChatImageCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
 class MaoChatImageCollectionViewCell: MaoChatBaseCollectionViewCell {
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.tapImageView(tap: #selector(tapd))
        return imageView
    }()
    
    var scale:CGFloat = 1
    var maxWidth:CGFloat = 200
    var maxHeight:CGFloat = 200
    
//    var minSize:CGSize = 
    
    
    override func buildView() {
        super.buildView()
        contentBackView.addSubview(contentImageView)
    }
    
    override func buildLayout(_ isMe: MaoChatIsMe) {
        super.buildLayout(isMe)
        
        contentImageView <<- [
            Trailing(-8).anchor(self.contentBackView.trailingAnchor),
            Leading(8).anchor(self.contentBackView.leadingAnchor),
            Top(8).anchor(self.contentBackView.topAnchor),
            Bottom(-8).anchor(self.contentBackView.bottomAnchor)
        ]
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let image = UIImage(named: contentModel.content)
        self.contentImageView.image = image
        self.getScale(size: (image?.size)!)
        
//        self.setNeedsLayout()
    }
    
    func getScale(size:CGSize) {
        if size.width > size.height {
            self.scale = maxWidth / size.width
        }else {
            self.scale = maxHeight / size.height
        }
        
        var minScale:CGFloat = 1.0
        if self.scale * size.width < 100 {
            minScale = 100 / (self.scale * size.width)
        }
        
        contentBackImageView <<- [
            Height((self.scale * size.height * minScale)),
            Width((self.scale * size.width * minScale))
        ]
    }
}

class MaoChatImageLeftCollectionViewCell: MaoChatImageCollectionViewCell {
    override func buildView() {
        super.buildView()
        self.buildLayout(.True)
    }
}

class MaoChatImageRightCollectionViewCell: MaoChatImageCollectionViewCell {
    override func buildView() {
        super.buildView()
        self.buildLayout(.False)
    }
}

