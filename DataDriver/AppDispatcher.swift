//
//  AppDispatcher.swift
//  mamaSwift@
//
//  Created by bear on 15/9/18.
//  Copyright © 2015年 98workroom. All rights reserved.
//

import Foundation
class AppDispatcher: Dispatcher {
    fileprivate static let shareInstanceD = AppDispatcher()
    class var shareInstance: AppDispatcher {
        return shareInstanceD
    }
}
