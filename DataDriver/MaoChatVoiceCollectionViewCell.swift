//
//  MaoChatVoiceCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
 class MaoChatVoiceCollectionViewCell: MaoChatBaseCollectionViewCell {
    
    lazy var voiceButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.addTarget(self, action: #selector(MaoChatVoiceCollectionViewCell.voiceAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var voiceTimeLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        label.contentMode = UIViewContentMode.center
//        label.isHidden = true
        label.text = "44''"
        return label
    }()
    
    private var voiceImages:UIImage = UIImage()
    
    var voiceImage: UIImage {
        get {
            return voiceImages
        }set {
            voiceImages = newValue
            self.voiceButton.setImage(newValue, for: UIControlState.normal)
        }
    }
    
    
    override func buildView() {
        super.buildView()
        contentBackView.addSubview(voiceButton)
        addSubview(voiceTimeLabel)
    }
    
    override func buildLayout(_ isMe: MaoChatIsMe) {
        super.buildLayout(isMe)
        
        voiceButton <<- [
            Top(8).anchor(self.contentBackView.topAnchor),
            Trailing(-8).anchor(self.contentBackView.trailingAnchor),
            Leading(8).anchor(self.contentBackView.leadingAnchor),
            Width(>=40),
            Bottom(-8).anchor(self.contentBackView.bottomAnchor)
        ]
        
        voiceTimeLabel <<- [
            Width(20),
            Height(20),
            Top(15).anchor(self.topAnchor),
        ]
        
        
        
        switch isMe {
        case .True:
            voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
            voiceTimeLabel <<- [
                Trailing(0).anchor(self.contentBackView.leadingAnchor),
            ]
        case .False:
            voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            voiceTimeLabel <<- [
                Leading(2).anchor(self.contentBackView.trailingAnchor),
            ]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension MaoChatVoiceCollectionViewCell {
    func voiceAction() {
        
    }
}


class MaoChatVoiceLeftCollectionViewCell: MaoChatVoiceCollectionViewCell {
    override func buildView() {
        super.buildView()
        self.voiceImage = UIImage(named: MaoChatImageName.CellVoiceReceive.simchat_audio_receive_icon_3.rawValue)!
        self.buildLayout(.False)
    }
}

class MaoChatVoiceRightCollectionViewCell: MaoChatVoiceCollectionViewCell {
    override func buildView() {
        super.buildView()
        self.voiceImage = UIImage(named: MaoChatImageName.CellVoiceSend.simchat_audio_send_icon_3.rawValue)!
        self.buildLayout(.True)
    }
}
