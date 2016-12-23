//
//  MaoChatInputButton.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

public class MaoChatInputButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = .keyboard
        super.init(coder: aDecoder)
    }

    /// 初始化
    init(style: MaoChatInputViewStyle) {
        self.style = style
        super.init(frame: CGRect.zero)
        self.update(self.style)
    }
    
    var style: MaoChatInputViewStyle {
        willSet {
            update(actived ? .keyboard : newValue)
        }
    }
    
    /// 激活的
    var actived: Bool = false {
        willSet {
            update(newValue ? .keyboard : style)
        }
    }
    
    
    private func update(_ style: MaoChatInputViewStyle) {
        guard let item = MaoChatImage.inputItemImages[style] else{
            return
        }
        self.setImage(item.n, for: UIControlState.normal)
        self.setImage(item.h, for: UIControlState.highlighted)
        
        // duang
        let ani = CATransition()
        
        ani.duration = 0.25
        ani.fillMode = kCAFillModeBackwards
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        ani.type = kCATransitionFade
        ani.subtype = kCATransitionFromTop
        
        layer.add(ani, forKey: "s")
    }
    
}


