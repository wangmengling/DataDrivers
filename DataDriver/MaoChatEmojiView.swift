//
//  MaoChatEmojiView.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class MaoChatEmojiView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.intrinsicContentSize = CGSize(width: 36, height: 36)
    }
    
    /// 表情
    var emoji: String? {
        willSet {
            guard emoji != newValue else {
                return
            }
            // \u{7F}      Delete         UIButton
            // \u{XX}      Emoji          UILabel
            // {TYPE:NAME} Custom Face    UIImageView
            if let em = newValue {
                // 新的视图
                var view: UIView?
                if em == "\u{7F}" {
                    // 这是删除
                    let btn = showView as? UIButton ?? UIButton()
                    // :)
                    btn.frame = bounds
//                    btn.setImage(SIMChatImageManager.images_emoji_delete_nor, forState: .Normal)
//                    btn.setImage(SIMChatImageManager.images_emoji_delete_press, forState: .Highlighted)
//                    btn.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                    // ok
                    view = btn
                } else if em.hasPrefix("{") && em.hasSuffix("}") {
                    // 这是自定义表情
                    let iv = showView as? UIImageView ?? UIImageView()
                    // config
                    iv.frame = bounds
                    // ok
                    view = iv
                } else {
                    // 这是系统表情
                    let lb = showView as? UILabel ?? UILabel()
                    // config
                    lb.frame = bounds
                    lb.text = em
//                    lb.font = UIFont.systemFontOfSize(28)
//                    lb.textAlignment = .Center
//                    lb.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                    // ok
                    view = lb
                }
                // 替换(不同的情况下)
                if showView != view {
                    showView?.removeFromSuperview()
                    showView = view
                    addSubview(showView!)
                }
            } else {
                showView?.removeFromSuperview()
                showView = nil
            }
        }
    }
    /// 当前类型
    var showView: UIView?
}
