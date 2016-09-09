//
//  Dispatcher.swift
//  mamaSwift@
//
//  Created by bear on 15/9/17.
//  Copyright (c) 2015年 98workroom. All rights reserved.
//

import Foundation
typealias DispatcherCallback = (PayLoad)->Void
class Dispatcher {
    
//    private static let shareInstanceD = Dispatcher()
//    class var shareInstance: Dispatcher {
//        return shareInstanceD
//    }
    
    var _prefix = "ID_"   //prefix前缀
    var _callbacks:Dictionary<String,Any>!          //回调集合
    var _isDispatching:Bool = false                 //是否分发
    var _isHandled:Dictionary<String,Bool>!         //是否持有数据   key
    var _isPending:Dictionary<String,Bool>!         //是否待定
    var _lastID=1                                   //
    var _pendingPayload:PayLoad?                    //当前数据
    
    init(){
        _callbacks = Dictionary()
        _isHandled = Dictionary()
        _isPending = Dictionary()
    }
    
    /**
    注册 将回调追加到回调集合中
    - parameter callback:
    - returns: key
    */
    func register(_ callback:@escaping DispatcherCallback)->String{
        _lastID += 1
        let key:String = "\(_prefix)\(_lastID)"
        self._callbacks[key] = callback
        return key
    }
    
    /**
    移除注册
    - parameter key:
    */
    func unregisterWithKey(_ key:String){
        self._callbacks.removeValue(forKey: key)
    }
    
    //MARK: 分发数据，更新数据
    /**
    分发数据，更新数据
    
    - parameter payLoad: <#payLoad description#>
    */
    func dispatch(_ payLoad:PayLoad){
//        assert(!self._isDispatching, "'Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch.'")
        self._startDispatching(payLoad)
        do{
            for key in self._callbacks.keys {
                if self._isPending[key] == true {
                    continue
                }
                self._invokeCallback(key)
            }
        }catch{
            self._stopDispatching()
        }
    }
    
    /**
     调用callback
     
     - parameter key: key
     */
    func _invokeCallback(_ key:String) {
        self._isPending[key] = true
        let callback:DispatcherCallback = self._callbacks[key] as! DispatcherCallback
        callback(self._pendingPayload!)
        self._isHandled[key] = true
    };
    
    
    //MARK: 启动disptach
    /**
    启动disptach
    
    - parameter payLoad: 实体
    */
    func _startDispatching(_ payLoad:PayLoad){
        //
        for key in self._callbacks.keys {
            self._isPending[key] = false;
            self._isHandled[key] = false;
        }
        self._pendingPayload = payLoad;
        self._isDispatching = true;
    }
    
    // MARK: - Navigation 停止
    /**
    Stop dispatching
    */
    func _stopDispatching(){
        self._pendingPayload = nil
        self._isDispatching = false
    }
}

class PayLoad {
    var actionType:ActionTypes?
    var content:Any?
    
    init(actionType:ActionTypes,content:Any){
        self.actionType = actionType
        self.content = content
    }
}
