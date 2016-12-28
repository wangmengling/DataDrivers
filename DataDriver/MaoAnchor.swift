//
//  MaoAnchor.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
public struct MaoAnchor {
    public var top: MaoLayoutAnchor {
        return Top()
    }
    
    public func top(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return Top(constant)
    }
    
    public func top(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return Top(constant)
    }
    
    public func left(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return Left(constant)
    }
    
    public func left(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return Left(constant)
    }
    
    public func bottom(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return Bottom(constant)
    }
    
    public func bottom(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return Bottom(constant)
    }
    
    public func width(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return Width(constant)
    }
    
    public func width(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return Width(constant)
    }
    
    public func height(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return Height(constant)
    }
    
    public func height(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return Height(constant)
    }
    
    public func leading(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return Leading(constant)
    }
    
    public func leading(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return Leading(constant)
    }
    
    public func trailing(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return Trailing(constant)
    }
    
    public func trailing(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return Trailing(constant)
    }
    
    public func centerX(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return CenterX(constant)
    }
    
    public func centerX(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return CenterX(constant)
    }
    
    public func centerY(_ constant: CGFloat = 0) -> MaoLayoutAnchor {
        return CenterY(constant)
    }
    
    public func centerY(_ constant: MaoConstant) -> MaoLayoutAnchor {
        return CenterY(constant)
    }

    
    public func addLayoutAnchors(_ layoutAnchor: (MaoAnchor) -> MaoLayoutAnchor) {
        let maoLayoutAnchor = layoutAnchor(self)
        let layoutConstant =  maoLayoutAnchor.excite()
        let deLayoutConstant = maoLayoutAnchor.deactivate()
        if (deLayoutConstant != nil) {
            NSLayoutConstraint.deactivate([deLayoutConstant!])
        }
        NSLayoutConstraint.activate([layoutConstant])
    }
}
