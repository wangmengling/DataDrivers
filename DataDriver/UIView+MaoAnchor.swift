//
//  UIView+MaoAnchor.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension UIView {
    
    /* Adds layoutGuide to the receiver, passing the receiver in -setOwningView: to layoutGuide.
     */
    //    @available(iOS 9.0, *)
    open func addLayoutAnchors(_ layoutAnchors: [MaoLayoutAnchor]){
        var deactivateLayoutConstraintArray: [NSLayoutConstraint] = []
        let layoutConstraint =   layoutAnchors.map { (layoutAnchor) -> NSLayoutConstraint in
            layoutAnchor.anchorView = self
            if let deactivate = layoutAnchor.deactivate(){
                deactivateLayoutConstraintArray.append(deactivate)
            }
            return layoutAnchor.excite()
        }
        
        NSLayoutConstraint.deactivate(deactivateLayoutConstraintArray)
        NSLayoutConstraint.activate(layoutConstraint)
    }
    
    open func addLayoutAnchor(_ layoutAnchor: MaoLayoutAnchor){
        var deactivateLayoutConstraintArray: [NSLayoutConstraint] = []
        layoutAnchor.anchorView = self
        if let deactivate = layoutAnchor.deactivate(){
            deactivateLayoutConstraintArray.append(deactivate)
        }
        let layoutConstraint =   layoutAnchor.excite()
        NSLayoutConstraint.deactivate(deactivateLayoutConstraintArray)
        NSLayoutConstraint.activate([layoutConstraint])
    }
    
//    open func addLayoutAnchor(_ layoutAnchor: (MaoLayoutAnchor) -> Void){
//        layoutAnchor()
//    }
    public var maoAnchor: MaoAnchor {
        return MaoAnchor()
    }
}

infix operator <<-


public func <<- (view: UIView!, right: [MaoLayoutAnchor]) {
    view.translatesAutoresizingMaskIntoConstraints = false
    var deactivateLayoutConstraintArray: [NSLayoutConstraint] = []
    let layoutConstraint =   right.map { (layoutAnchor) -> NSLayoutConstraint in
        layoutAnchor.anchorView = view
        if let deactivate = layoutAnchor.deactivate(){
            deactivateLayoutConstraintArray.append(deactivate)
        }
        return layoutAnchor.excite()
    }
    
    NSLayoutConstraint.deactivate(deactivateLayoutConstraintArray)
    NSLayoutConstraint.activate(layoutConstraint)
}

