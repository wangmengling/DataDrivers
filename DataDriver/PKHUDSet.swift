//
//  PKHUDSet.swift
//  luoye
//
//  Created by bear on 15/12/8.
//  Copyright © 2015年 98workroom. All rights reserved.
//

import Foundation
import PKHUD
struct PKHUDSet {
    
    static private let shareInstance = PKHUDSet()
    static var sharedManager: PKHUDSet {
        return shareInstance
    }
    
    func showText(text:String){
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: text)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2.0)
    }
    
    func showTextDelayExecution(text:String,execution:()->()) -> Void {
        self.showText(text)
        self.delayExecution(2.0, execution: execution)
    }
    
    func showText(text:String, afterDelay:NSTimeInterval){
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: text)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: afterDelay)
    }
    
    func showTextDelayExecution(text:String, afterDelay:NSTimeInterval,execution:()->()){
        self.showText(text, afterDelay: afterDelay)
        self.delayExecution(afterDelay, execution: execution)
    }
    
    func hiden(){
        PKHUD.sharedHUD.hide()
    }
    
    func showProgressView(){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
//    func showSuccessView(){
//        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
//        PKHUD.sharedHUD.show()
//        PKHUD.sharedHUD.hide(afterDelay: 1.0)
//    }
    
    func show(){
        PKHUD.sharedHUD.contentView = PKHUDErrorView()
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.0)
    }
    
    func delayExecution(time:NSTimeInterval,execution:()->()) -> Void {
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1000 * NSEC_PER_MSEC))
        dispatch_after(when, dispatch_get_main_queue()) { 
            execution()
        }
    }
}