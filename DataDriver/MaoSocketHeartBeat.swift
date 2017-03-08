//
//  MaoSocketHeartBeat.swift
//  DataDriver
//
//  Created by jackWang on 2017/3/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import CoreFoundation

// MARK: -- MaoSocket HeartBeat
class MaoSocketHeartBeat {
    fileprivate lazy var heartBeatQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.heartBeatQueue.description)
    var maoSocket: MaoSocketTcp!
    var timer:CFRunLoopTimer?                   //timer event
    var runloop:CFRunLoop!                      //runloop
    var isRemoveTimer = false                   //remove timer

    // Start heartbeat for check server status
    func start(maoSocket:MaoSocketTcp) {
        self.maoSocket = maoSocket
        heartBeatQueue.async {
            Thread.current.name = MaoSocketEnum.SocketConst.heartBeatQueue.description
            self.stratCFRunloop()
        }
    }
    
    // Add timer
    func stratCFRunloop() -> Void {
        autoreleasepool { () -> Void in
            self.runloop = CFRunLoopGetCurrent()
            self.timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent(), 10, 0, 0, { timer in
                self.sendHeartBeatData()
            })
            CFRunLoopAddTimer(self.runloop, self.timer, CFRunLoopMode.defaultMode)
            CFRunLoopRun()
        }
    }
    
    // Send message
    func sendHeartBeatData() -> Void {
        self.maoSocket.sendMessage(message: "") { (number) in
            self.reConnect(number)
        }
    }
    
    // Reply connect to server
    func reConnect(_ number: Int) -> Void {
        if number < 0 {
            do {
                _ = try self.maoSocket.reConnect()
                self.maoSocket.reciveMessage()
            } catch let error {
                print(error)
            }
        }else {
            do {
                try self.maoSocket.close()
            } catch _ {
                
            }
            
        }
    }
    
    // Remove timer of runloop
    func removeTimer() -> Void {
        while isRemoveTimer {
            CFRunLoopRemoveTimer(runloop, self.timer, CFRunLoopMode.defaultMode)
            CFRunLoopStop(runloop)
        }
    }
}

