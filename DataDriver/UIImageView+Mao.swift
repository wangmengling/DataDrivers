//
//  UIImageView+Mao.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension UIImageView {
    func tapImageView(tap:Selector?)  {
        let tapAvatar = UITapGestureRecognizer(target: self, action: tap)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapAvatar)
    }
}
