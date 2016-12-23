//
//  MaoChatEnum.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

public enum MaoChatType: String, CustomStringConvertible {
    case label
    case image
    case voice
    
    
    public var description: String {
        return self.rawValue
    }
}

public enum MaoChatBaseCollectionViewCellStyle: String, CustomStringConvertible {
    case label = "MaoChatLabelCollectionViewCell"
    case image = "MaoChatImageCollectionViewCell"
    case voice = "MaoChatVoiceCollectionViewCell"
    
    public var description: String {
        return self.rawValue
    }
    
    public func styleOfChatType(chatType:MaoChatType) -> String{
        switch chatType {
        case .label:
            return MaoChatBaseCollectionViewCellStyle.label.description
        case .image:
            return MaoChatBaseCollectionViewCellStyle.image.description
        case .voice:
            return MaoChatBaseCollectionViewCellStyle.voice.description
        default:
            return MaoChatBaseCollectionViewCellStyle.label.description
        }
    }
}

public enum MaoChatIsMe: Int {
    case True = 0
    case False = 1
}


public enum MaoChatInputViewStyle {
    case keyboard
    case voice
    case emoji
    case tool
}


