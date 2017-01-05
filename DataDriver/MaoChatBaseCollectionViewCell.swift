//
//  MaoChatBaseCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

open class MaoChatBaseCollectionViewCell: UICollectionViewCell {
    
    lazy var nameLabel:UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        label.text = "JackWang"
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = UIImage(named: MaoChatImageName.CellView.MaoChatDefaultAvtatar.rawValue)
        imageView.tapImageView(tap: #selector(tapd))
        return imageView
    }()
    
    lazy var contentBackView: UIView = {
        let contentBackView = UIView()
        contentBackView.backgroundColor = UIColor.lightGray
        return contentBackView
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
//    lazy var model = MaoUserModel()
    
    lazy var userModel:MaoUserModel = MaoUserModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }
    
    func tapd() {
        print(String(describing: self))
    }
    
    open func buildView() {
        addSubview(avatarImageView)
        addSubview(contentBackView)
        addSubview(bottomLine)
    }
    
    func buildLayout(_ isMe: MaoChatIsMe) {
        avatarImageView <<- [
            Top(5).anchor(self.topAnchor),
            Width(44),
            Height(44),
        ]
        contentBackView <<- [
            Top(12).anchor(self.topAnchor),
            Height(>=30),
            Bottom(-12).anchor(self.bottomAnchor)
        ]
        
        bottomLine <<- [
            Width(375),
            Height(1),
            Bottom(0).anchor(self.bottomAnchor),
            Left(0).anchor(self.leftAnchor),
            Right(0).anchor(self.rightAnchor)
        ]
        
        
        switch isMe {
        case .True:
            
            avatarImageView <<- [
                Left(15).anchor(self.leftAnchor)
            ]
            
            
            contentBackView <<- [
                Leading(8).anchor(self.avatarImageView.trailingAnchor),
                Width(>=30),
                Width(<=(UIScreen.main.bounds.width-150))
            ]
            
            
        case .False:
            
            avatarImageView <<- [
                Right(-15).anchor(self.rightAnchor)
            ]
            
            
            contentBackView <<- [
                Trailing(-8).anchor(self.avatarImageView.leadingAnchor),
                Width(>=30),
                Width(<=(UIScreen.main.bounds.width-150))
            ]
            
            
        }

    }
    
}
