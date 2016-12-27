//
//  MaoAnchor.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
public struct MaoAnchor {
    public var top: MaoLayoutAnchor {
        return Top()
    }
    
    public func addLayoutAnchor(_ layoutAnchor: (MaoAnchor) -> Void){
        layoutAnchor(self)
    }
}
