//
//  KeyboardStore.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/11.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class KeyboardStore {
    
    static let shared = KeyboardStore()
    var keyBoardHeight:CGFloat = 0
    private init() {
        //当键盘将要弹起时候执行方法UIKeyboardWillShowNotification
        center.addObserver(self, selector: #selector(KeyboardStore.willShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        btn.addTarget(self, action: #selector(onItemAction(_:)), for: .touchUpInside)
        //键盘将要收起时执行方法UIKeyboardWillHideNotification
        center.addObserver(self, selector: #selector(KeyboardStore.willHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //通知中心
    private let center = NotificationCenter.default
    
    
    //键盘出现的方法,此处比较难得地方是如何获取通知里的内容，
    @objc func willShow(_ notice : NSNotification) {
        
        //通知里的内容
        let userInfo = notice.userInfo as NSDictionary!
        
        let aValue = userInfo?.object(forKey: UIKeyboardFrameEndUserInfoKey)
        
        let keyboardRect = (aValue as AnyObject).cgRectValue
        
        //键盘的高度
        let keyBoardHeights = keyboardRect?.size.height
        self.keyBoardHeight = keyBoardHeights!
    }
    
    //键盘收起的方法
    @objc func willHide(_ notice : NSNotification){
        
    }

}
