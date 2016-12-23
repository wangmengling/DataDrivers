//
//  MaoNumerical.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

public struct MaoNumerical {
    
    public let value: CGFloat
    
    public let relation: NSLayoutRelation
    
    public let multiple: CGFloat
    
    public init(value: CGFloat, relation: Relation, multiplier: CGFloat) {
        self.value = value
        self.relation = relation
        self.multiple = multiple
    }
    
}
