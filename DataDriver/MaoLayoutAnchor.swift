//
//  MaoLayoutAnchor.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//  一个约束条件   类型  约束，参数，优先级，条件

import Foundation

struct MaoLayoutAnchor {
    //参数值
    lazy var numerical: MaoNumerical
    
    //优先级
    lazy var priority: MaoPriority
}
