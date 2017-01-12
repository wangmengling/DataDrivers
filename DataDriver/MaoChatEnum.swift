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
    case labelLeft = "MaoChatLabelLeftCollectionViewCell"
    case imageLeft = "MaoChatImageLeftCollectionViewCell"
    case voiceLeft = "MaoChatVoiceLeftCollectionViewCell"
    
    case labelRight = "MaoChatLabelRightCollectionViewCell"
    case imageRight = "MaoChatImageRightCollectionViewCell"
    case voiceRight = "MaoChatVoiceRightCollectionViewCell"
    
    public var description: String {
        return self.rawValue
    }
    
    static public func styleOfChatType(_ chatType: MaoChatType , _ isMe: MaoChatIsMe) -> String{
        switch isMe {
        case .True:
            
            switch chatType {
            case .label:
                return MaoChatBaseCollectionViewCellStyle.labelRight.description
            case .image:
                return MaoChatBaseCollectionViewCellStyle.imageRight.description
            case .voice:
                return MaoChatBaseCollectionViewCellStyle.voiceRight.description
            }
        case .False:
            switch chatType {
            case .label:
                return MaoChatBaseCollectionViewCellStyle.labelLeft.description
            case .image:
                return MaoChatBaseCollectionViewCellStyle.imageLeft.description
            case .voice:
                return MaoChatBaseCollectionViewCellStyle.voiceLeft.description
            }
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

struct MaoChatEnum {
    struct UISCREEN {
        static var WIDTH:CGFloat{
            return UIScreen.main.bounds.size.width
        }
        
        static var HEIGHT:CGFloat {
            return UIScreen.main.bounds.size.height
        }
    }
}


