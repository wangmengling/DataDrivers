//
//  MaoChatLabelCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MaoChatLabelCollectionViewCell: MaoChatBaseCollectionViewCell {
    
    lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        label.text = "ceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshiceshi"
        label.numberOfLines = 0
        return label
    }()
    
    override func buildView() {
        super.buildView()
        contentBackView.addSubview(contentLabel)
    }
    
    override func buildLayout(_ isMe: MaoChatIsMe) {
        super.buildLayout(isMe)
        
        contentLabel <<- [
            Trailing(0).anchor(self.contentBackView.trailingAnchor),
            Leading(0).anchor(self.contentBackView.leadingAnchor),
            Top(4).anchor(self.contentBackView.topAnchor),
            Bottom(-4).anchor(self.contentBackView.bottomAnchor)
        ]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentLabel.text = userModel.name
    }

}
