//
//  ViewTapBlockProtocol.swift
//  demo
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit

typealias ViewTapBlock  = (AnyObject?) -> Void

protocol ViewTapBlockProtocol {
    var value:AnyObject?{get set}
    var viewTapBlock:ViewTapBlock?{get set}
    mutating func tapAction()
}

extension ViewTapBlockProtocol where Self:UIView{
    mutating func viewTapBlocks(_ viewBlock:@escaping ViewTapBlock) -> Void {
        self.isUserInteractionEnabled = true
        let viewTap = UITapGestureRecognizer(target: self, action:#selector(UIImageTapView.tapAction as (UIImageTapView) -> () -> Void))
        self.addGestureRecognizer(viewTap)
        self.viewTapBlock = viewBlock
    }
    
    mutating func tapAction() -> Void {
        guard let value = value else {
            return
        }
        self.viewTapBlock!(value)
    }
}

class UIImageTapView:UIImageView,ViewTapBlockProtocol{
    var value:AnyObject?
    var viewTapBlock:ViewTapBlock?
    
    func tapAction() -> Void {
        guard let value = value else {
            return
        } 
        self.viewTapBlock!(value)
    }
}
