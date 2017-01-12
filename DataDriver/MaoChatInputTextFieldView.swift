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
        textView.backgroundColor = UIColor.red
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
    
    fileprivate lazy var textFieldBackImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: MaoChatImageName.InputView.chat_bottom_textfield.rawValue)
        return imageView
    }()
    
    private lazy var leftButtons: [MaoChatInputButton] = [
        MaoChatInputButton(style: .voice)
    ]
    private lazy var rightButtons: [MaoChatInputButton] = [
//        MaoChatInputButton(style: .emoji),
        MaoChatInputButton(style: .tool)
    ]
    
    lazy var leftButton:UIButton = {
        let voiceButton = UIButton(type: UIButtonType.custom)
        return voiceButton
    }()
    
    lazy var style:MaoChatInputViewStyle = .keyboard
    
    var inputStyle:MaoChatInputViewStyle {
        get{
            return style
        } set {
            style = newValue
            showToolsView(style: style)
        }
    }
    
    lazy var toolsBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    lazy var toolsView: MaoChatInputToolsView = {
        let view = MaoChatInputToolsView()
        return view
    }()
    
    
    override func buildView() {
        super.buildView()
        
        let buttons = (leftButtons as [UIView])  + [textView] + (rightButtons as [UIView])
        
        // configs
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.scrollIndicatorInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        textView.returnKeyType = UIReturnKeyType.send
        textView.delegate = self
        
        // add view
        addSubview(textFieldBackImageView)
        addSubview(toolsBackView)
        toolsBackView.addSubview(toolsView)
        
        for index in 0 ..< buttons.count {
            let button = buttons[index]
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            if let btn = button as? MaoChatInputButton {
                btn.addTarget(self, action: #selector(onItemAction(_:)), for: .touchUpInside)
            }
            
            if index < 1 {
                button <<- [
                    Leading(10).anchor(self.leadingAnchor)
                ]
            }else {
                let preItem = buttons[index-1]
                button <<- [
                    Leading(10).anchor(preItem.trailingAnchor)
                ]
            }
            
            if index == buttons.count - 1 {
                button <<- [
                    Trailing(-10).anchor(self.trailingAnchor)
                ]
            }
            
            if button is UITextView { // is textView
                button <<- [
                    Top(5).anchor(self.topAnchor)
                ]
            } else {
                button <<- [
                    Top(6).anchor(self.topAnchor)
                ]
            }
            
            // bottom
            if button is UITextView { // is textView
                (button as! UITextView).delegate = self
                button <<- [
//                    Bottom(5).anchor(self.bottomAnchor)
                    Height(36)
                ]
            } else {
                button <<- [
                    Width(34),
                    Height(34)
                ]
            }
        }
        
        
        textFieldBackImageView <<- [
            Top(5).anchor(self.topAnchor),
            Leading(0).anchor(self.textView.leadingAnchor),
            Bottom(-5).anchor(self.bottomAnchor),
//            Height(36),
            Trailing(0).anchor(self.textView.trailingAnchor)
        ]
        
        toolsBackView <<- [
            Top(44).anchor(self.topAnchor),
            Leading(0).anchor(self.leadingAnchor),
            Bottom(0).anchor(self.bottomAnchor),
            Trailing(0).anchor(self.trailingAnchor),
        ]
        
        toolsView <<- [
            Top(0).anchor(self.toolsBackView.topAnchor),
            Leading(0).anchor(self.toolsBackView.leadingAnchor),
            Bottom(0).anchor(self.toolsBackView.bottomAnchor),
            Trailing(0).anchor(self.toolsBackView.trailingAnchor),
        ]
    }
    
    func onItemAction(_ sender: MaoChatInputButton) {
        self.endEditing(true)
        self.inputStyle = sender.style
    }
}

extension MaoChatInputTextFieldView {
    
    func showToolsView(style:MaoChatInputViewStyle) {
        
        switch style {
        case .keyboard:
            let keyboardHeight = KeyboardStore.shared.keyBoardHeight < 10 ? 258 : KeyboardStore.shared.keyBoardHeight
            self.toolsBackView.isHidden = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self ->> [
                    Bottom()
                ]
                self.toolsBackView <<- [
                    Height(keyboardHeight)
                ]
                let bottom = -(keyboardHeight+5)
                
                self.textFieldBackImageView <<- [
                    Bottom(bottom).anchor(self.bottomAnchor)
                ]
            })
        case .voice:
            
            UIView.animate(withDuration: 0.2, animations: {
                self ->> [
                    Bottom()
                ]
                self.toolsBackView <<- [
                    Height(0)
                ]
                self.textFieldBackImageView <<- [
                    Bottom(-5).anchor(self.bottomAnchor)
                ]
            })
            
            self.toolsBackView.isHidden = true
        case .tool:
            UIView.animate(withDuration: 0.5, animations: {
                self ->> [
                    Bottom()
                ]
                self.toolsBackView <<- [
                    
                    Height(224)
                ]
                self.textFieldBackImageView <<- [
                    Bottom(-229).anchor(self.bottomAnchor)
                ]
            })
            
            self.toolsBackView.isHidden = false
        default:
            return
        }
    }
}

extension MaoChatInputTextFieldView {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        self.inputStyle = .keyboard
        return true
    }
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
}


