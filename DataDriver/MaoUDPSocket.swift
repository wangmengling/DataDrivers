//
//  MaoUDPSocket.swift
//  DataDriver
//
//  Created by jackWang on 2017/2/2.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import Socket
private let maoUDPSocket:MaoUDPSocket = MaoUDPSocket()

class MaoUDPSocket{
    
    
    let QUIT: String = "QUIT"
    let port: Int32 = 8124
    let host: String = "127.0.0.1"
    let path: String = "/tmp/server.test.socket"
    
    var socket:Socket!
    var signature:CustomStringConvertible!
    var addr:Socket.Address!
    
    class var instance:MaoUDPSocket  {
        return maoUDPSocket
    }
    
    init() {
        
        do {
            socket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
//            socket.delegate = self
        } catch let error {
            print(error)
        }
        
    }
    
    
    func connect() -> Void {
//        do {
//            addr = Socket.createAddress(for: self.host, on: port)!
//        } catch let error  {
//            print(error)
//        }
    }
    
    
    func sendMessage(params: [String: Any]) -> Void {
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        guard let pQueue = queue else {
            print("Unable to access global interactive QOS queue")
            return
        }
        
        
        
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        pQueue.async {
            do {
                try self.socket.write(from: data,to:self.addr)
            } catch  let error {
                print(error)
            }
        }
    }
    
    func listen() -> Void {
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        guard let pQueue = queue else {
            
            print("Unable to access global interactive QOS queue")
            return
        }
        pQueue.async {
            do {
                var data = Data()
                _ = try self.socket.listen(forMessage: &data, on: Int(self.port))
                print(data)
            } catch  let error {
                print(error)
            }
        }
        
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
                    
                    let (bytesRead, address) = try self.socket.readDatagram(into: &data)
                    
                    guard let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                        print("Error decoding response...")
                        data.count = 0
                        return
                    }
                    
                    if response.hasPrefix(self.QUIT) {
                        keepRunning = false
                    }
                    
                    let (remoteHost, remotePort) = Socket.hostnameAndPort(from: address!)!
                    print("Received \(bytesRead) bytes from \(remoteHost):\(remotePort): \(response)\n")
                    print("Sending response")
                    let responseString: String = "Server response: \n\(response)\n"
                    try self.socket.write(from: responseString.data(using: String.Encoding.utf8)!, to: address!)
                    
                } while keepRunning
                
            } catch  let error {
                print(error)
            }
        }
        
    }
    
    
    
    
}

extension MaoUDPSocket {
    ///
    /// Initialize SSL Service
    ///
    /// - Parameter asServer:	True for initializing a server, otherwise a client.
    ///
    public func initialize(asServer: Bool) throws {
        
    }
    
    ///
    /// Deinitialize SSL Service
    ///
    public func deinitialize() {
        
    }
    
    ///
    /// Processing on acceptance from a listening socket
    ///
    /// - Parameter socket:	The connected Socket instance.
    ///
    public func onAccept(socket: Socket) throws {
        
    }
    ///
    /// Processing on connection to a listening socket
    ///
    /// - Parameter socket:	The connected Socket instance.
    ///
    public func onConnect(socket: Socket) throws {
        
    }
    
    ///
    /// Low level writer
    ///
    /// - Parameters:
    ///		- buffer:		Buffer pointer.
    ///		- bufSize:		Size of the buffer.
    ///
    ///	- Returns the number of bytes written. Zero indicates SSL shutdown, less than zero indicates error.
    ///
    public func send(buffer: UnsafeRawPointer!, bufSize: Int) throws -> Int {
        print(buffer)
        print("===============-------")
        return bufSize
    }
    
    
    
    ///
    /// Low level reader
    ///
    /// - Parameters:
    ///		- buffer:		Buffer pointer.
    ///		- bufSize:		Size of the buffer.
    ///
    ///	- Returns the number of bytes read. Zero indicates SSL shutdown, less than zero indicates error.
    ///
    public func recv(buffer: UnsafeMutableRawPointer, bufSize: Int) throws -> Int {
        print(buffer)
        print("===============")
        return bufSize
    }
}

