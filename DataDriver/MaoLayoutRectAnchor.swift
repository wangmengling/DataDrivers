//
//  MaoLayoutRectAnchor.swift
//  DataDriver
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MaoLayoutXAxisAnchor: MaoLayoutAnchor {
    var xAxisAnchor:NSLayoutXAxisAnchor!
    public var anchor: NSLayoutXAxisAnchor {
        return self.anchorView.leftAnchor
    }
    
    override func anchor(_ xAxisAnchor: NSLayoutXAxisAnchor) -> Self {
        self.xAxisAnchor = xAxisAnchor
        return self
    }
    
    override func excite() -> NSLayoutConstraint {
        switch self.constant.relation {
        case .equal:
            return self.anchor.constraint(equalTo: self.xAxisAnchor, constant: self.constant.constant)
        case .greaterThanOrEqual:
            return self.anchor.constraint(greaterThanOrEqualTo: self.xAxisAnchor, constant: self.constant.constant)
        case .lessThanOrEqual:
            return self.anchor.constraint(lessThanOrEqualTo: self.xAxisAnchor, constant: self.constant.constant)
        }
    }
}

class Leading: MaoLayoutXAxisAnchor {
    public override var anchor: NSLayoutXAxisAnchor {
        return self.anchorView.leadingAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .leading
    }
}

class Trailing: MaoLayoutXAxisAnchor {
    public override var anchor: NSLayoutXAxisAnchor {
        return self.anchorView.trailingAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .trailing
    }
}

class Left: MaoLayoutXAxisAnchor {
    public override var anchor: NSLayoutXAxisAnchor {
        return self.anchorView.leftAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .left
    }
}

class Right: MaoLayoutXAxisAnchor {
    public override var anchor: NSLayoutXAxisAnchor {
        return self.anchorView.rightAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .right
    }
}

class CenterX: MaoLayoutXAxisAnchor {
    public override var anchor: NSLayoutXAxisAnchor {
        return self.anchorView.centerXAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .centerX
    }
}

class MaoLayoutYAxisAnchor: MaoLayoutAnchor {
    var yAxisAnchor:NSLayoutYAxisAnchor!
    public var anchor: NSLayoutYAxisAnchor {
        return self.anchorView.topAnchor
    }
    
    override func anchor(_ yAxisAnchor: NSLayoutYAxisAnchor) -> Self {
        self.yAxisAnchor = yAxisAnchor
        return self
    }
    
    override func excite() -> NSLayoutConstraint {
        switch self.constant.relation {
        case .equal:
            return self.anchor.constraint(equalTo: self.yAxisAnchor, constant: self.constant.constant)
        case .greaterThanOrEqual:
            return self.anchor.constraint(greaterThanOrEqualTo: self.yAxisAnchor, constant: self.constant.constant)
        case .lessThanOrEqual:
            return self.anchor.constraint(lessThanOrEqualTo: self.yAxisAnchor, constant: self.constant.constant)
        }
    }
}



class Top: MaoLayoutYAxisAnchor {
    public override var anchor: NSLayoutYAxisAnchor {
        return self.anchorView.topAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .top
    }
}

class Bottom: MaoLayoutYAxisAnchor {
    public override var anchor: NSLayoutYAxisAnchor {
        return self.anchorView.bottomAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .bottom
    }
}

class CenterY: MaoLayoutYAxisAnchor {
    public override var anchor: NSLayoutYAxisAnchor {
        return self.anchorView.centerYAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .centerY
    }
}

class MaoLayoutDimensionAnchor: MaoLayoutAnchor {
    //依附的 anchor
    internal var demensionAnchor: NSLayoutDimension?
    public var anchor: NSLayoutDimension {
        return self.anchorView.widthAnchor
    }
    
    override func anchor(_ demensionAnchor: NSLayoutDimension) -> Self {
        self.demensionAnchor = demensionAnchor
        return self
    }
    
    override func excite() -> NSLayoutConstraint {
        switch self.constant.relation {
        case .equal:
            guard let demensionAnchor = self.demensionAnchor else {
                return self.anchor.constraint(equalToConstant: self.constant.constant)
            }
            return self.anchor.constraint(equalTo: demensionAnchor, multiplier: self.multiplier, constant: self.constant.constant)
        case .greaterThanOrEqual:
            guard let demensionAnchor = self.demensionAnchor else {
                return self.anchor.constraint(greaterThanOrEqualToConstant: self.constant.constant)
            }
            return self.anchor.constraint(greaterThanOrEqualTo: demensionAnchor, multiplier: self.multiplier, constant: self.constant.constant)
        case .lessThanOrEqual:
            guard let demensionAnchor = self.demensionAnchor else {
                return self.anchor.constraint(lessThanOrEqualToConstant: self.constant.constant)
            }
            return self.anchor.constraint(lessThanOrEqualTo: demensionAnchor, multiplier: self.multiplier, constant: self.constant.constant)
        }
    }
}

class Width: MaoLayoutDimensionAnchor{
    public override var anchor: NSLayoutDimension {
        return self.anchorView.widthAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .width
    }
}

class Height: MaoLayoutDimensionAnchor{
    public override var anchor: NSLayoutDimension {
        return self.anchorView.heightAnchor
    }
    
    public override var attribute: NSLayoutAttribute {
        return .height
    }
}
