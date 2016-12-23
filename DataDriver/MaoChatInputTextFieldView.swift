//
//  MaoChatInputTextFieldView.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MaoChatInputTextFieldView: MaoChatInputBaseView, UITextViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    var contentSize: CGSize {
        return textView.contentSize
    }
    var contentOffset: CGPoint {
        return textView.contentOffset
    }
    
    private var selectedItem: MaoChatInputButton? {
        willSet { self.selectedItem?.actived = false }
        didSet  { self.selectedItem?.actived = true }
    }
    
    private lazy var backgroundView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var leftButtons: [MaoChatInputButton] = [
        MaoChatInputButton(style: .voice)
    ]
    private lazy var rightButtons: [MaoChatInputButton] = [
        MaoChatInputButton(style: .emoji),
        MaoChatInputButton(style: .tool)
    ]
    
    lazy var leftButton:UIButton = {
        let voiceButton = UIButton(type: UIButtonType.custom)
        return voiceButton
    }()
    
    lazy var style:MaoChatInputViewStyle = .keyboard
    
    
    override func buildView() {
        super.buildView()
        
        let buttons = (leftButtons as [UIView])  + [textView] + (rightButtons as [UIView])
        
        // configs
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.scrollIndicatorInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        textView.returnKeyType = UIReturnKeyType.send
        textView.delegate = self
//        backgroundView.image = SIMChatImageManager.defautlInputBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // add view
        addSubview(backgroundView)
        
//        for button in buttons {
//            // disable translates
//            button.translatesAutoresizingMaskIntoConstraints = false
//            // add
//            addSubview(button)
//            // add tag, if need
//            if let btn = button as? MaoChatInputButton {
//                btn.addTarget(self, action: Selector(("onItemAction:")), for: .touchUpInside)
//            }
//        }
        
        for index in 0 ..< buttons.count {
            let button = buttons[index]
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            if let btn = button as? MaoChatInputButton {
                btn.addTarget(self, action: Selector(("onItemAction:")), for: .touchUpInside)
            }
//            UILayoutGuide()
//            button.addLayoutGuide(<#T##layoutGuide: UILayoutGuide##UILayoutGuide#>)
//            button.topAnchor
        }
        
        
    }
}

extension MaoChatInputTextFieldView {
    func onItemAction(sender:MaoChatInputButton) {
        print(sender.style)
    }
}


