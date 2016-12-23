//
//  MaoLayoutAnchor.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//  一个约束条件   类型  约束，参数，优先级，条件

import Foundation

public class MaoLayoutAnchor {
    //参数值
    var numerical: MaoNumerical
    
    //优先级
    var priority: MaoPriority
    
    //调教
    var condition:Any?
    
    init(numerical: MaoNumerical, priority: MaoPriority, condition: Any) {
        self.numerical = numerical
        self.priority = priority
    }
}
