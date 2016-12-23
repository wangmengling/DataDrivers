//
//  String+Mao.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
extension String {
    func image() -> UIImage? {
        let image:UIImage? = UIImage(named: self)
        return image
    }
}
