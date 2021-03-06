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
        imageView.tapImageView(self, action:#selector(MaoChatBaseCollectionViewCell.tapd))
        return imageView
    }()
    
    lazy var contentBackView: UIView = {
        let contentBackView = UIView()
//        contentBackView.backgroundColor = UIColor.lightGray
        return contentBackView
    }()
    
    lazy var contentBackImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
//        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    
    lazy var sendStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: MaoChatImageName.CellSendStatus.simchat_message_fail.rawValue)
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var sendingIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.isHidden = true
        activityIndicatorView.color = UIColor.lightGray
        return activityIndicatorView
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
//    lazy var userModel:MaoUserModel = MaoUserModel()
    var model:MaoChatContentModel = MaoChatContentModel()
    
    var contentModel: MaoChatContentModel {
        get {
            return model
        }
        set {
            model = newValue
            avatarImageView.image = UIImage(named:model.userModel.headImage)
            sending = false
            self.layoutIfNeeded()
        }
    }
    
    var sending: Bool {
        get{
            return true
        }
        set {
            if newValue == true {
                sendingIndicatorView.startAnimating()
                sendingIndicatorView.isHidden = false
            } else {
                sendingIndicatorView.stopAnimating()
                sendingIndicatorView.isHidden = true
            }
        }
    }
    
    
    
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
        self.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        addSubview(avatarImageView)
        addSubview(contentBackView)
        contentBackView.addSubview(contentBackImageView)
        addSubview(bottomLine)
    }
    
    func buildLayout(_ isMe: MaoChatIsMe) {
        avatarImageView <<- [
            Top(5).anchor(self.topAnchor),
            Width(44),
            Height(44),
        ]
        
        contentBackView <<- [
            Top(5).anchor(self.topAnchor),
            Height(>=44),
            Bottom(-5).anchor(self.bottomAnchor)
        ]
        
//        contentBackImageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
//        contentBackImageView.autoresizingMask
        contentBackImageView <<- [
            Top(0).anchor(self.contentBackView.topAnchor),
            Left(0).anchor(self.contentBackView.leftAnchor),
            Right(0).anchor(self.contentBackView.rightAnchor),
            Bottom(0).anchor(self.contentBackView.bottomAnchor)
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
            addSubview(sendStatusImage)
            addSubview(sendingIndicatorView)
            
            avatarImageView <<- [
                Right(-15).anchor(self.rightAnchor)
            ]
            
//            UILayoutPriority
            
            contentBackView <<- [
                Trailing(-8).anchor(self.avatarImageView.leadingAnchor),
                Width(<=(UIScreen.main.bounds.width-150)).priority(250),
                Width(>=30)
            ]
            
            contentBackImageView.image = UIImage(named: MaoChatImageName.Cell.simchat_bubble_send.rawValue)
            
            sendStatusImage <<- [
                Width(25),
                Height(25),
                Top(13).anchor(self.topAnchor),
                Right(-4).anchor(self.contentBackView.leftAnchor)
            ]
            
            sendingIndicatorView <<- [
                Width(25),
                Height(25),
                Top(13).anchor(self.topAnchor),
                Right(-4).anchor(self.contentBackView.leftAnchor)
            ]
            sendingIndicatorView.startAnimating()
        case .False:
            
            avatarImageView <<- [
                Left(15).anchor(self.leftAnchor)
            ]
            
            
            contentBackView <<- [
                Leading(8).anchor(self.avatarImageView.trailingAnchor),
                Width(<=(UIScreen.main.bounds.width-150)),
                Width(>=30)
            ]
            
            contentBackImageView.image = UIImage(named: MaoChatImageName.Cell.simchat_bubble_recive.rawValue)
            
            
        }

    }
    
}
