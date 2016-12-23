//
//  MaoChatImage.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


struct MaoChatImageName {
    enum InputView: String {
        case chat_bottom_keyboard_nor
        case chat_bottom_keyboard_press
        case chat_bottom_voice_nor
        case chat_bottom_voice_press
        case chat_bottom_smile_nor
        case chat_bottom_smile_press
        case chat_bottom_up_nor
        case chat_bottom_up_press
    }
}

struct MaoChatImage {
    
    static var inputItemImages: [MaoChatInputViewStyle : (n: UIImage?, h: UIImage?)] = [
        .keyboard   : (n: UIImage(named: "chat_bottom_keyboard_nor"),   h: UIImage(named: "chat_bottom_keyboard_press")),
        .voice      : (n: UIImage(named: "chat_bottom_voice_nor"),      h: UIImage(named: "chat_bottom_voice_press")),
        .emoji      : (n: UIImage(named: "chat_bottom_smile_nor"),      h: UIImage(named: "chat_bottom_smile_press")),
        .tool       : (n: UIImage(named: "chat_bottom_up_nor"),         h: UIImage(named: "chat_bottom_up_press"))
    ]
}
