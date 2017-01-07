//
//  MaoChatVoiceCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
 class MaoChatVoiceCollectionViewCell: MaoChatBaseCollectionViewCell {
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.tapImageView(tap: #selector(tapd))
        return imageView
    }()
}


class MaoChatVoiceLeftCollectionViewCell: MaoChatVoiceCollectionViewCell {
    override func buildView() {
        super.buildView()
        self.buildLayout(.True)
    }
}

class MaoChatVoiceRightCollectionViewCell: MaoChatVoiceCollectionViewCell {
    override func buildView() {
        super.buildView()
        self.buildLayout(.False)
    }
}
