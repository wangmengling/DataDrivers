//
//  MaoChatTextView.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class MaoChatTextView: UIView, UITextViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MaoChatImage.inputItemImages[.keyboard]?.n
        imageView.highlightedImage = MaoChatImage.inputItemImages[.keyboard]?.h
        return imageView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        return textView
    }()

    func buildView() -> Void {
        // configs
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.scrollIndicatorInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        textView.returnKeyType = UIReturnKeyType.send
//        textView.delegate = self
        
        backImageView <<- [
            Top().anchor(self.topAnchor),
            Bottom().anchor(self.bottomAnchor),
            Left().anchor(self.leftAnchor),
            Right().anchor(self.rightAnchor)
        ]
        
        textView <<- [
            Top(1).anchor(self.topAnchor),
            Bottom(1).anchor(self.bottomAnchor),
            Left(1).anchor(self.leftAnchor),
            Right(1).anchor(self.rightAnchor)
        ]
    }
}
