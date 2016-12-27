//
//  MaoLayoutAnchor.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//  一个约束条件   类型  约束，参数，优先级，条件

import UIKit


public class MaoLayoutAnchor {
    //参数值
    var constant: MaoConstant!
    //优先级
    var priority: UILayoutPriority!
    //
    var multiplier: CGFloat = 1.0
    
//    var attribute: NSLayoutAttribute?
    public var attribute: NSLayoutAttribute {
        return .height
    }
    
    //调教
    var condition:Any?
    
    var anchorView:UIView!
    
    init() {
        self.constant = MaoConstant(0.0, .equal)
    }
    
    init(_ constant: MaoConstant, priority: UILayoutPriority, condition: Any) {
        self.constant = constant
        self.priority = priority
        self.condition = condition
    }
    
    init(_ constant: CGFloat) {
        self.constant = MaoConstant(constant, .equal)
    }
    
    init(_ constant: MaoConstant) {
        self.constant = constant
        self.priority = UILayoutPriorityDefaultHigh
    }
    
    func relaction(_ relation:NSLayoutRelation) -> Self {
        return self
    }
    
    func excite() -> NSLayoutConstraint {
        return NSLayoutConstraint()
    }
    
    func deactivate() -> NSLayoutConstraint? {
        var deactivateConstant: NSLayoutConstraint?
        self.anchorView.constraints.forEach { constant in
            if constant.firstAttribute == self.attribute {
                deactivateConstant = constant
            }
        }
        return deactivateConstant
    }
}

extension MaoLayoutAnchor {
    
    
    func when(_ condition: Any) -> Self {
        self.condition = condition
        return self
    }
    
    func offset(_ multiplier: CGFloat) -> Self {
        self.multiplier = multiplier
        return self
    }
    
    func priority( _ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
    
    
}
