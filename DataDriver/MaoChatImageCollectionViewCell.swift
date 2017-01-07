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
    
    override func buildView() {
        super.buildView()
        contentBackView.addSubview(contentImageView)
    }
    
    override func buildLayout(_ isMe: MaoChatIsMe) {
        super.buildLayout(isMe)
        
        contentImageView <<- [
            Trailing(-12).anchor(self.contentBackView.trailingAnchor),
            Leading(12).anchor(self.contentBackView.leadingAnchor),
            Top(8).anchor(self.contentBackView.topAnchor),
            Bottom(-8).anchor(self.contentBackView.bottomAnchor)
        ]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentImageView.image = UIImage(named: contentModel.content)
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

