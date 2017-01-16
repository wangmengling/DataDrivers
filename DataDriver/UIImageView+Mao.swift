//
//  UIImageView+Mao.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension UIImageView {
    func tapImageView(_ target: Any, action: Selector)  {
        let tapAvatar = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapAvatar)
    }
}
