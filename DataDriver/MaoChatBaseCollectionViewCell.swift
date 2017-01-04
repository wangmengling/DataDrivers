//
//  MaoChatBaseCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MaoChatBaseCollectionViewCell: UICollectionViewCell {
    
    lazy var nameLabel:UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.tapImageView(tap: #selector(tapd))
    }()
    
    lazy var userModel = MaoUserModel()
    
    func tapd() {
        print(String(describing: self))
    }
    
    func buildView() {
        addSubview(nameLabel)
        addSubview(avatarImageView)
        
        switch userModel.isMe {
        case .True:
            avatarImageView <<- [
                Left(15).anchor(self.leftAnchor)
            ]
        case .False:
            avatarImageView <<- [
                Right(15).anchor(self.rightAnchor)
            ]
        }
        
        avatarImageView <<- [
            Top().anchor(self.topAnchor),
            Width(44),
            Height(44)
        ]
    }
}
