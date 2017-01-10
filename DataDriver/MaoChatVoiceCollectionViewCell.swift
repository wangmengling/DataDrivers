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
        button.addTarget(self, action: "voiceAction", for: UIControlEvents.touchUpInside)
        return button
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
        
        switch isMe {
        case .True:
            voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        case .False:
            voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
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
