//
//  MaoConstant.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

public struct MaoConstant {
    var multiplier: CGFloat = 1.0
    var constant: CGFloat = 0
    var relation: NSLayoutRelation = .equal
    
    init(_ constant:CGFloat, _ relation: NSLayoutRelation, _ multiplier:CGFloat = 1.0) {
        self.constant = constant
        self.relation = relation
        self.multiplier = multiplier
    }
}

/// Operator that eases the creation of a `Constant` with a `.Equal` relation
prefix operator ==

/// Operator that eases the creation of a `Constant` with a
/// `.GreaterThanOrEqual` relation
prefix operator >=

/// Operator that eases the creation of a `Constant` with a `.LessThanOrEqual`
/// relation
prefix operator <=

/// Operator that eases the creation of a `Constant` with `value = 0.0` and
/// `multiplier` the value specifier at the right hand side of the operator
prefix operator *

/**
 Definistion of custom `CGFloat` operators that ease the creation of `Constant`
 structs
 */
public extension CGFloat {
    
    /**
     Prefix operator that eases the creation of a `Constant` with a
     `.Equal` relation
     - parameter rhs: Value for the `Constant`
     - returns: The resulting `Constant` struct
     */
    public static prefix func == (rhs: CGFloat) -> MaoConstant {
        return MaoConstant( rhs, .equal, 1.0)
    }
    
    /**
     Prefix operator that eases the creation of a `Constant` with a
     `.GreaterThanOrEqual` relation
     - parameter rhs: Value for the `Constant`
     - returns: The resulting `Constant` struct
     */
    public static prefix func >= (rhs: CGFloat) -> MaoConstant {
        return MaoConstant(rhs, .greaterThanOrEqual, 1.0)
    }
    
    /**
     Prefix operator that eases the creation of a `Constant` with a
     `.LessThanOrEqual` relation
     - parameter rhs: Value for the `Constant`
     - returns: The resulting `Constant` struct
     */
    public static prefix func <= (rhs: CGFloat) -> MaoConstant {
        return MaoConstant( rhs,.lessThanOrEqual, 1.0)
    }
    
    /**
     Prefix operator that eases the creation of a `Constant` with `value = 0.0`
     and `multiplier` the value specifier at the right hand side of the operator.
     - parameter rhs: Value for the `multiplier`
     - returns: The resulting `Constant` struct
     */
    public static prefix func * (rhs: CGFloat) -> MaoConstant {
        return MaoConstant(rhs, .equal, rhs)
    }
    
    /**
     Infix operator that applies the `multiplier` at the right hand side to the
     `Constant` at the left hand side.
     i.e. `Width((>=200.0)*0.5)` creates a `Constant` with `multiplier = 0.5`,
     `relation = .GreaterThanOrEqual` and `value = 200.0`.
     If the left hand side `Constant` already has a `multiplier` defined the
     resulting `multiplier` will be the multiplication of both, previous and new
     `multipliers`.
     - parameter lhs: a `Constant`
     - parameter rhs: a `CGFloat` multiplier
     - returns: A new `Constant` with the `multiplier` applied
     */
    public static func * (lhs: MaoConstant, rhs: CGFloat) -> MaoConstant {
        return MaoConstant(lhs.constant, lhs.relation, lhs.multiplier * rhs)
    }
}
