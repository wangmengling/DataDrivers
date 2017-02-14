//
//  MaoTCPSocket.swift
//  DataDriver
//
//  Created by jackWang on 2017/2/2.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import Socket
private let maoTCPSocket:MaoTCPSocket = MaoTCPSocket()

class MaoTCPSocket {
    
    let QUIT: String = "QUIT"
    let port: Int32 = 6969
    let host: String = "127.0.0.1"
    let path: String = "/tmp/server.test.socket"
    let family: Socket.ProtocolFamily = .inet
    
    var socket: Socket!
    var signature: Socket.Signature!
    var addr: Socket.Address!
    
    
    class var instance: MaoTCPSocket {
        return maoTCPSocket
    }
    
    fileprivate init() {
        do {
            socket = try Socket.create(family: .inet)
            signature = try Socket.Signature(protocolFamily: self.family, socketType: .stream, proto: .tcp, hostname: self.host, port: self.port)!
        } catch let error {
            print(error)
        }
    }
    
    func connect() -> Void {
        do {
            try socket.connect(using: self.signature)
            if !socket.isConnected {
                
                fatalError("Failed to connect to the server...")
            }
        } catch let error {
            print(error)
        }
    }
    
    
    func sendMessage() -> Void {
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        guard let pQueue = queue else {
            print("Unable to access global interactive QOS queue")
            return
        }
        pQueue.async {
            do {
                try self.socket.write(from: "Hello from TCP".data(using: .utf8)!)
            } catch  let error {
                print(error)
            }
        }
    }
    
    func sendMessage(params: Any) -> Void {
        
    }
    
    func reciveMessage() -> Void {
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        guard let pQueue = queue else {
            
            print("Unable to access global interactive QOS queue")
            return
        }
        
        var keepRunning = true
        
        pQueue.async {
            do {
                repeat {
                    var data = Data()
                    let	bytesRead = try self.socket.read(into: &data)
                    if bytesRead > 0 {
                        
                        print("Read \(bytesRead) from socket...")
                        
                        guard let response = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else {
                            print("Error accessing received data...")
                            return
                        }
                        if response.hasPrefix(self.QUIT) {
                            keepRunning = false
                        }
                        print("Response:\n\(response)")
                    }
                    
                } while keepRunning
                
            } catch  let error {
                print(error)
            }
        }

        
    }
}
