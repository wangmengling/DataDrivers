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
    
    fileprivate lazy var textView: UITextView = {
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
    
    fileprivate lazy var leftButtons: [MaoChatInputButton] = [
        MaoChatInputButton(style: .voice)
    ]
    fileprivate lazy var rightButtons: [MaoChatInputButton] = [
//        MaoChatInputButton(style: .emoji),
        MaoChatInputButton(style: .tool)
    ]
    
    fileprivate lazy var voiceButton:UIButton = {
        let voiceButton = UIButton(type: UIButtonType.custom)
        voiceButton.setTitle("按住 说话", for: UIControlState.normal)
        voiceButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        voiceButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        voiceButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        voiceButton.layer.borderColor = UIColor.lightGray.cgColor
        voiceButton.layer.borderWidth = 0.5
        voiceButton.layer.cornerRadius = 3
        voiceButton.isUserInteractionEnabled = true
        voiceButton.isHidden = true
        voiceButton.addTarget(self, action: #selector(voiceRecordDownAction(_:)), for: UIControlEvents.touchDown)
        voiceButton.addTarget(self, action: #selector(voiceRecordUpAction(_:)), for: UIControlEvents.touchUpInside)
        return voiceButton
    }()
    
    lazy var style:MaoChatInputViewStyle = .keyboard
    
    var currentStyle:MaoChatInputViewStyle {
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
        view.isHidden = true
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
        addSubview(voiceButton)
        
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
            Height(36),
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
        
        voiceButton <<- [
            Top(0).anchor(self.textFieldBackImageView.topAnchor),
            Leading(0).anchor(self.textFieldBackImageView.leadingAnchor),
//            Bottom(0).anchor(self.textFieldBackImageView.bottomAnchor),
            Height(36),
            Trailing(0).anchor(self.textFieldBackImageView.trailingAnchor)
        ]
    }
    
    func onItemAction(_ sender: MaoChatInputButton) {
        self.endEditing(true)
        self.currentStyle = sender.style
        
        //更新leftButton类型 语音或者键盘
        switch sender.style {
        case .keyboard:
            self.textView.becomeFirstResponder()
            sender.style = .voice
        case .voice:
            sender.style = .keyboard
        default:
            return
        }
    }
    
    
}


//根据style变化，更新相应的view
extension MaoChatInputTextFieldView {
    
    func showToolsView(style:MaoChatInputViewStyle) {
        
        self.showLeftToolsImage(style: style)
        
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
        case .none:
            self.textView.resignFirstResponder()
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
        default:
            return
        }
    }
    
    
    func showLeftToolsImage(style:MaoChatInputViewStyle) -> Void {
        let voiceOrKeyboardButton:MaoChatInputButton = self.leftButtons[0]
        switch style {
        case .keyboard:
            voiceOrKeyboardButton.setImage(UIImage(named: MaoChatImageName.InputView.chat_bottom_voice_nor.rawValue), for: UIControlState.normal)
            voiceButton.isHidden = true
            textFieldBackImageView.isHidden = false
            textView.isHidden = false
            
        case .voice:
            voiceOrKeyboardButton.setImage(UIImage(named: MaoChatImageName.InputView.chat_bottom_keyboard_nor.rawValue), for: UIControlState.normal)
            voiceButton.isHidden = false
            textFieldBackImageView.isHidden = true
            textView.isHidden = true
        default:
            return
        }
    }
}

extension MaoChatInputTextFieldView {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        self.currentStyle = .keyboard
        return true
    }
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEqual("\n") {
            self.currentStyle = .none
            return false
        }
        return true
    }
    
}

extension MaoChatInputTextFieldView {
    func voiceRecordDownAction(_ send:UIButton) {
        print("ds")
    }
    
    func voiceRecordUpAction(_ send:UIButton) {
        print("ds")
    }
}


