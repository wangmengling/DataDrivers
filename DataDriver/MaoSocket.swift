//
//  MaoSocket.swift
//  DataDriver
//
//  Created by jackWang on 2017/2/2.
//  Copyright © 2017年 apple. All rights reserved.
//
//import Darwin
//#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Darwin
//#elseif os(Linux)
//    import Glibc
//#endif
import Foundation

protocol MaoSocketTCPDelegate {
    func socketTCPDidConnect(socket: MaoSocketTcp)
    func socketTCPDisConnect(socket: MaoSocketTcp, error: MaoSocketError?)
    func socketTCPDidSendMessage(socket: MaoSocketTcp, error: MaoSocketError)
    func socketTCPDidReciveMessage(data: NSMutableData,socket: MaoSocketTcp)
}

protocol MaoSocketUDPDelegate {
    func socketUDPDidConnect(socket: MaoSocketUDP)
    func socketUDPDisConnect(socket: MaoSocketUDP, error: MaoSocketError?)
    func socketUDPDidSendMessage(socket: MaoSocketUDP, error: MaoSocketError)
    func socketUDPDidReciveMessage(data: NSMutableData,socket: MaoSocketUDP)
}

struct MaoSocketEnum {
    
    enum SocketConst: String, CustomStringConvertible {
        case sendMessagQueue                = "com.maoling.sendmessage.queue"
        case reciveMessageQueue             = "com.maoling.recivemessage.queue"
        case sendMessageUDPQueue            = "com.maoling.sendmessage.udp.queue"
        case reciveMessageUDPQueue          = "com.maoling.recivemessage.udp.queue"
        
        public var description: String {
            return self.rawValue
        }
    }
    
    enum Family {
        case inet
        case inet6
        case unix
        
        var value:Int32 {
            switch self {
            case .inet:
                return AF_INET
            case .inet6:
                return AF_INET6
            case .unix:
                return AF_UNIX
            }
        }
        
        static func getFamily(_ family: Int32) -> MaoSocketEnum.Family? {
            return .inet
        }
        
    }
    
    public enum SocketType {
        case stream
        case datagram
        case raw
        
        var value:Int32 {
            switch self {
            case .stream:
                return SOCK_STREAM
            case .datagram:
                return SOCK_DGRAM
            case .raw:
                return SOCK_RAW
            }
        }
        
        static func getType(_ type: Int32) -> MaoSocketEnum.SocketType? {
            return .stream
        }
    }
    
    enum SocketProtocol {
        case tcp
        case udp
        case unix
        
        var value: Int32 {
            switch self {
            case .tcp:
                return IPPROTO_TCP
            case .udp:
                return IPPROTO_UDP
            case .unix:
                return Int32(0)
            }
        }
        
        static func getProtocol(_ protocol: Int32) -> MaoSocketEnum.SocketProtocol? {
            return .tcp
        }
        
    }
    
    // MARK: -- Socket Address
    
    ///
    /// Socket Address
    ///
    public enum Address {
        
        /// sockaddr_in
        case ipv4(sockaddr_in)
        
        /// sockaddr_in6
        case ipv6(sockaddr_in6)
        
        /// sockaddr_un
        case unix(sockaddr_un)
        
        ///
        /// Size of address. (Readonly)
        ///
        public var size: Int {
            
            switch self {
                
            case .ipv4( _):
                return MemoryLayout<(sockaddr_in)>.size
            case .ipv6( _):
                return MemoryLayout<(sockaddr_in6)>.size
            case .unix( _):
                return MemoryLayout<(sockaddr_un)>.size
            }
        }
        
        ///
        /// Cast as sockaddr. (Readonly)
        ///
        public var addr: sockaddr {
            
            switch self {
                
            case .ipv4(let addr):
                return addr.asAddr()
                
            case .ipv6(let addr):
                return addr.asAddr()
                
            case .unix(let addr):
                return addr.asAddr()
            }
        }
        
    }
}

public struct MaoSocketError: Swift.Error, CustomStringConvertible {
    
    public internal(set) var errorCode: Int32
    
    public internal(set) var errorReason: String?
    
    public var description: String {
        let reason: String = self.errorReason ?? "Reason: Unavailable"
        return "Error code: \(self.errorCode)(0x\(String(self.errorCode, radix: 16, uppercase: true))), \(reason)"
    }
    
    init(_ code: Int, _ reason: String) {
        self.errorCode = Int32(code)
        self.errorReason = reason
    }
}

struct MaoSocketCode {
    public static let SOCKET_RECIVE_BUFFER_SIZE_MINIMUM		= 1024      //recive buffer min
    public static let SOCKET_RECIVE_BUFFER_SIZE_DEFAULT		= 4096      //recive buffer max

    
    public static let SOCKET_INVALID_PORT					= Int32(0)
    public static let SOCKET_INVALID_DESCRIPTOR 			= Int32(-1)
    
    public static let SOCKET_ERR_SIGNATURE_FAMILY           = -9999
    public static let SOCKET_ERR_SIGNATURE_STREAM_TCP       = -9998
    public static let SOCKET_ERR_SIGNATURE_DATAGRAM_UDP     = -9997
    
    
    public static let SOCKET_ERR_SOCKET_INIT                = -9996
    public static let SOCKET_ERR_SOCKET_CONNECT_GETADDRINFO = -9995
    public static let SOCKET_ERR_INVALID_BUFFER             = -9994
    public static let SOCKET_ERR_BAD_DESCRIPTOR             = -9993
    public static let SOCKET_ERR_WRONG_PROTOCOL             = -9992
    public static let SOCKET_ERR_CONNECTION_RESET           = -9991
    public static let SOCKET_ERR_WRITE_FAILED               = -9990
}

private let maoSocket: MaoSocket = MaoSocket()

class MaoSocket {
    //socket 套字节
    fileprivate var socketFd: Int32! = MaoSocketCode.SOCKET_INVALID_DESCRIPTOR
    
    fileprivate var signature: MaoSocketSignature? = nil
    fileprivate var isConnect: Bool = false
    fileprivate var reciveMessageKeepRunning: Bool = true
    
    fileprivate lazy var sendMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.sendMessagQueue.description)
    fileprivate lazy var reciveMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.reciveMessageQueue.description)
    
//    var delegate: MaoSocketDelegate?
    
    // MARK: -- Private
    
    ///
    /// Internal read buffer.
    /// 	**Note:** The readBuffer is actually allocating unmanaged memory that'll
    ///			be deallocated when we're done with it.
    ///
    
    fileprivate lazy var reciveBuffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)
    ///
    /// Internal Storage Buffer initially created with `Socket.SOCKET_DEFAULT_READ_BUFFER_SIZE`.
    ///
    //    var reciveData: Data = Data(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)
    var reciveData: NSMutableData = NSMutableData(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)!
    
    fileprivate var reciveBufferSize: Int = MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT {
        
        // If the buffer size changes we need to reallocate the buffer...
        didSet {
            
            // Ensure minimum buffer size...
            if reciveBufferSize < MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_MINIMUM {
                reciveBufferSize = MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_MINIMUM
            }
            
            if reciveBufferSize != oldValue {
                reciveBuffer.deinitialize()
                reciveBuffer.deallocate(capacity: oldValue)
                reciveBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: reciveBufferSize)
                reciveBuffer.initialize(to:0)
            }
        }
    }
    
//    class var instance:MaoSocket  {
//        return maoSocket
//    }
    
    fileprivate init(){
        
    }
    
    init(family: MaoSocketEnum.Family, socketType: MaoSocketEnum.SocketType, socketProtocol: MaoSocketEnum.SocketProtocol) throws {
        do {
            self.signature = try MaoSocketSignature(family: family, socketType: socketType, socketProtocol: socketProtocol)
            self.socketFd = Darwin.socket((self.signature?.family.value)!, (self.signature?.socketType.value)!, (self.signature?.socketProtocol.value)!)
            if self.socketFd < 0 {
                throw MaoSocketError(Int(MaoSocketCode.SOCKET_INVALID_DESCRIPTOR), "socket error.")
            }
        } catch let error {
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SOCKET_INIT, error.localizedDescription)
        }
    }
    
    func createSocket(family: MaoSocketEnum.Family, socketType: MaoSocketEnum.SocketType, socketProtocol: MaoSocketEnum.SocketProtocol) throws {
        do {
            self.signature = try MaoSocketSignature(family: family, socketType: socketType, socketProtocol: socketProtocol)
            self.socketFd = Darwin.socket((self.signature?.family.value)!, (self.signature?.socketType.value)!, (self.signature?.socketProtocol.value)!)
            if self.socketFd < 0 {
                throw MaoSocketError(Int(MaoSocketCode.SOCKET_INVALID_DESCRIPTOR), "socket error.")
            }
        } catch let error {
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SOCKET_INIT, error.localizedDescription)
        }
    }
    
    fileprivate func connect(_ host: String, _ port: Int32) throws -> Int{
        if self.socketFd < 0 {
            throw MaoSocketError(Int(MaoSocketCode.SOCKET_INVALID_DESCRIPTOR), "socket error.")
        }
        
        // Create the hints for our search...
        let socketType: MaoSocketEnum.SocketType = .stream
        var hints = addrinfo(
            ai_flags: AI_PASSIVE,
            ai_family: AF_UNSPEC,
            ai_socktype: socketType.value,
            ai_protocol: 0,
            ai_addrlen: 0,
            ai_canonname: nil,
            ai_addr: nil,
            ai_next: nil)
        
        var targetInfo: UnsafeMutablePointer<addrinfo>? = UnsafeMutablePointer<addrinfo>.allocate(capacity: 1)
        
        // Retrieve the info on our target...
        var status: Int32 = getaddrinfo(host, String(port), &hints, &targetInfo)
        if status != 0 {
            
            var errorString: String
            if status == EAI_SYSTEM {
                errorString = String(validatingUTF8: strerror(errno)) ?? "Unknown error code."
            } else {
                errorString = String(validatingUTF8: gai_strerror(errno)) ?? "Unknown error code."
            }
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SOCKET_CONNECT_GETADDRINFO, errorString)
        }
        
        // Defer cleanup of our target info...
        defer {
            if targetInfo != nil {
                freeaddrinfo(targetInfo)
            }
        }
        
        guard let info: UnsafeMutablePointer<addrinfo> = targetInfo else {
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SOCKET_CONNECT_GETADDRINFO, "addrinfo error or nil")
            return -1
        }
        
        status = Darwin.connect(self.socketFd, info.pointee.ai_addr, info.pointee.ai_addrlen)
        guard status != 0 else {
            isConnect = true
            return Int(status)
        }
        _ = Darwin.close(self.socketFd)  // close socket
        return Int(status)
    }
}

class MaoSocketTcp {
    //socket 套字节
    fileprivate var socketFd: Int32! = MaoSocketCode.SOCKET_INVALID_DESCRIPTOR
    
    fileprivate var signature: MaoSocketSignature? = nil
    fileprivate var isConnect: Bool = false
    fileprivate var reciveMessageKeepRunning: Bool = true
    
    fileprivate lazy var sendMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.sendMessagQueue.description)
    fileprivate lazy var reciveMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.reciveMessageQueue.description)
    
    var delegate: MaoSocketTCPDelegate?
    
    // MARK: -- Private
    
    ///
    /// Internal read buffer.
    /// 	**Note:** The readBuffer is actually allocating unmanaged memory that'll
    ///			be deallocated when we're done with it.
    ///
    
    fileprivate lazy var reciveBuffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)
    ///
    /// Internal Storage Buffer initially created with `Socket.SOCKET_DEFAULT_READ_BUFFER_SIZE`.
    ///
//    var reciveData: Data = Data(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)
    var reciveData: NSMutableData = NSMutableData(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)!
    
    fileprivate var reciveBufferSize: Int = MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT {
        
        // If the buffer size changes we need to reallocate the buffer...
        didSet {
            
            // Ensure minimum buffer size...
            if reciveBufferSize < MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_MINIMUM {
                reciveBufferSize = MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_MINIMUM
            }
            
            if reciveBufferSize != oldValue {
                reciveBuffer.deinitialize()
                reciveBuffer.deallocate(capacity: oldValue)
                reciveBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: reciveBufferSize)
                reciveBuffer.initialize(to:0)
            }
        }
    }
    
//    class var instance:MaoSocketTcp  {
//        return maoSocket
//    }
    
    fileprivate init(){
        
    }
    
    init(family: MaoSocketEnum.Family, socketType: MaoSocketEnum.SocketType, socketProtocol: MaoSocketEnum.SocketProtocol) throws {
        do {
            self.signature = try MaoSocketSignature(family: family, socketType: socketType, socketProtocol: socketProtocol)
            self.socketFd = Darwin.socket((self.signature?.family.value)!, (self.signature?.socketType.value)!, (self.signature?.socketProtocol.value)!)
            if self.socketFd < 0 {
                throw MaoSocketError(Int(MaoSocketCode.SOCKET_INVALID_DESCRIPTOR), "socket error.")
            }
        } catch let error {
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SOCKET_INIT, error.localizedDescription)
        }
    }
    
    public func connect(host: String, port: Int32) {
        var status = -1
        var socketError:Error? = nil
        do {
            status =  try self.connect(host, port)
        } catch let error {
            socketError = error
        }
        guard let socketDelegate = self.delegate else {
            return
        }
        if status < 0 {
            socketDelegate.socketTCPDisConnect(socket: self, error: socketError as? MaoSocketError)
        }else {
            socketDelegate.socketTCPDidConnect(socket: self)
        }
    }
    
    
    fileprivate func connect(_ host: String, _ port: Int32) throws -> Int{
        if self.socketFd < 0 {
            throw MaoSocketError(Int(MaoSocketCode.SOCKET_INVALID_DESCRIPTOR), "socket error.")
        }
        
        // Create the hints for our search...
        let socketType: MaoSocketEnum.SocketType = .stream
            var hints = addrinfo(
                ai_flags: AI_PASSIVE,
                ai_family: AF_UNSPEC,
                ai_socktype: socketType.value,
                ai_protocol: 0,
                ai_addrlen: 0,
                ai_canonname: nil,
                ai_addr: nil,
                ai_next: nil)
        
        var targetInfo: UnsafeMutablePointer<addrinfo>? = UnsafeMutablePointer<addrinfo>.allocate(capacity: 1)
        
        // Retrieve the info on our target...
        var status: Int32 = getaddrinfo(host, String(port), &hints, &targetInfo)
        if status != 0 {
            
            var errorString: String
            if status == EAI_SYSTEM {
                errorString = String(validatingUTF8: strerror(errno)) ?? "Unknown error code."
            } else {
                errorString = String(validatingUTF8: gai_strerror(errno)) ?? "Unknown error code."
            }
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SOCKET_CONNECT_GETADDRINFO, errorString)
        }
        
        // Defer cleanup of our target info...
        defer {
            if targetInfo != nil {
                freeaddrinfo(targetInfo)
            }
        }
        
        guard let info: UnsafeMutablePointer<addrinfo> = targetInfo else {
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SOCKET_CONNECT_GETADDRINFO, "addrinfo error or nil")
            return -1
        }
        
        status = Darwin.connect(self.socketFd, info.pointee.ai_addr, info.pointee.ai_addrlen)
        guard status != 0 else {
            isConnect = true
            return Int(status)
        }
        _ = Darwin.close(self.socketFd)  // close socket
        return Int(status)
    }
}


extension MaoSocketTcp {
    
    func sendMessage(data: Data, fn: @escaping(Int) -> Void ) {
        if data.count == 0 {
            fn(-1)
            return
        }
        do {
            let status = try data.withUnsafeBytes() { [unowned self] (buffer: UnsafePointer<UInt8>) throws -> Int in
                return self.sendMessage(from: buffer, bufSize: data.count)
            }
            fn(status)
        } catch let error {
            fn(-1)
            guard let socketDelegate = self.delegate else {
                return
            }
            socketDelegate.socketTCPDidSendMessage(socket: self, error: error as! MaoSocketError)
        }
    }
    
    func sendMessage(message: String , fn: @escaping(Int) -> Void) {
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        queue?.async {
            do {
                let status = try message.utf8CString.withUnsafeBufferPointer() {
                    return self.sendMessage(from: $0.baseAddress!, bufSize: $0.count-1)
                }
                fn(status)
            } catch let error {
                fn(-1)
                guard let socketDelegate = self.delegate else {
                    return
                }
                socketDelegate.socketTCPDidSendMessage(socket: self, error: error as! MaoSocketError)
            }
        }
    }
    
    func sendMessage(from buffer: UnsafeRawPointer, bufSize: Int) -> Int {
        return Darwin.send(self.socketFd, buffer, bufSize, 0)
    }
}

extension MaoSocketTcp {
    func reciveMessage() -> Void {
        if self.isConnect != true {
            return
        }
        var reciveFlags: Int32 = 0
        if (self.reciveData.length > 0) {
            reciveFlags |= Int32(MSG_DONTWAIT)
        }
        reciveMessageQueue.async {
            repeat {
                var count: Int = 0
                // Clear the buffer...
                self.reciveData = NSMutableData(capacity: 0)!
                
                repeat{
                    count = Darwin.recv(self.socketFd, self.reciveBuffer, self.reciveBufferSize, reciveFlags)
                    
                    self.reciveData.append(self.reciveBuffer, length: count)
                    if count < self.reciveBufferSize {
                        break
                    }
                } while count > 0
                guard let socketDelegate = self.delegate else {
                    return
                }
                socketDelegate.socketTCPDidReciveMessage(data: self.reciveData, socket: self)
            } while self.reciveMessageKeepRunning
        }
    }
    
    func reciveMessage(fn: @escaping (NSMutableData) -> Void) {
        if self.isConnect != true {
            return
        }
        let keepRunning = true
        var reciveFlags: Int32 = 0
        if (self.reciveData.length > 0) {
            reciveFlags |= Int32(MSG_DONTWAIT)
        }
        reciveMessageQueue.async {
            repeat {
                var count: Int = 0
                // Clear the buffer...
                //                self.reciveBuffer.initialize(to: 0x0)
                self.reciveData = NSMutableData(capacity: 0)!
                
                repeat{
                    count = Darwin.recv(self.socketFd, self.reciveBuffer, self.reciveBufferSize, reciveFlags)
                    
                    self.reciveData.append(self.reciveBuffer, length: count)
                    if count < self.reciveBufferSize {
                        break
                    }
                } while count > 0
                fn(self.reciveData)
                guard let socketDelegate = self.delegate else {
                    return
                }
                socketDelegate.socketTCPDidReciveMessage(data: self.reciveData, socket: self)
            } while keepRunning
        }
    }
}

struct MaoSocketSignature {
    // MARK: -- Public Properties
    
    ///
    /// Protocol Family
    ///
    public internal(set) var family: MaoSocketEnum.Family
    
    ///
    /// Socket Type. (Readonly)
    ///
    public internal(set) var socketType: MaoSocketEnum.SocketType
    
    ///
    /// Socket Protocol. (Readonly)
    ///
    public internal(set) var socketProtocol: MaoSocketEnum.SocketProtocol
    
    ///
    /// Host name for connection. (Readonly)
    ///
    public internal(set) var hostname: String?
    
    ///
    /// Port for connection. (Readonly)
    ///
    public internal(set) var port: Int32?
    
    ///
    /// Path for .unix type sockets. (Readonly)
    public internal(set) var path: String? = nil
    
    ///
    /// Address info for socket. (Readonly)
    ///
    public internal(set) var address: MaoSocketEnum.Address? = nil
    
    ///
    /// Flag to indicate whether `Socket` is secure or not. (Readonly)
    ///
    public internal(set) var isSecure: Bool = false
    
    ///
    /// True is socket bound, false otherwise.
    ///
    public internal(set) var isBound: Bool = false
    
    ///
    /// Returns a string description of the error.
    ///
    public var description: String {
        
        return "Signature: family: \(self.family), type: \(socketType), protocol: \(socketProtocol), address: \(address as MaoSocketEnum.Address?), hostname: \(hostname as String?), port: \(port), path: \(String(describing: path)), bound: \(isBound), secure: \(isSecure)"
    }
    
    // MARK: -- Public Functions
    
    ///
    /// Create a socket signature
    ///
    ///	- Parameters:
    ///		- protocolFamily:	The protocol family to use (only `.inet` and `.inet6` supported by this `init` function).
    ///		- socketType:		The type of socket to create.
    ///		- proto:			The protocool to use for the socket.
    /// 	- hostname:			Hostname for this signature.
    /// 	- port:				Port for this signature.
    ///
    /// - Returns: New Signature instance
    ///
    public init?(family: MaoSocketEnum.Family, socketType: MaoSocketEnum.SocketType, socketProtocol: MaoSocketEnum.SocketProtocol) throws {
        
        // Make sure we have what we need...
        guard family == .inet || family == .inet6 || family == .unix else {
                throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SIGNATURE_FAMILY, "Missing hostname, port or both or invalid protocol family.")
        }
        
        
        // Validate the parameters...
        if socketType == .stream {
            guard socketProtocol == .tcp || socketProtocol == .unix   else {
                
                throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SIGNATURE_STREAM_TCP, "Stream socket must use either .tcp or .unix for the protocol.")
            }
        }
        if socketType == .datagram {
            guard socketProtocol == .udp || socketProtocol == .unix else {
                
                throw MaoSocketError(MaoSocketCode.SOCKET_ERR_SIGNATURE_DATAGRAM_UDP, "Datagram socket must use .udp or .unix for the protocol.")
            }
        }
        
        self.family = family
        self.socketType = socketType
        self.socketProtocol = socketProtocol
        
    }
}


private let maoSocketUDP: MaoSocketUDP = MaoSocketUDP()
class MaoSocketUDP: MaoSocket {
    var delegate: MaoSocketUDPDelegate?
//    init(family: MaoSocketEnum.Family) {
//        do {
//            try super.init(family: family, socketType: MaoSocketEnum.SocketType.datagram, socketProtocol: MaoSocketEnum.SocketProtocol.udp)
//        } catch let error {
//            print(error)
//        }
//    }
    
    class var instance: MaoSocketUDP {
        return maoSocketUDP
    }
    
    func connect(_ family: MaoSocketEnum.Family, host: String, port: Int32) throws {
        var status = -1
        var socketError:Error? = nil
        do {
            try self.createSocket(family: family, socketType: MaoSocketEnum.SocketType.datagram, socketProtocol: MaoSocketEnum.SocketProtocol.udp)
            status =  try self.connect(host, port)
        } catch let error {
            socketError = error
        }
        guard let socketDelegate = self.delegate else {
            return
        }
        if status < 0 {
            socketDelegate.socketUDPDisConnect(socket: self, error: socketError as? MaoSocketError)
        }else {
            socketDelegate.socketUDPDidConnect(socket: self)
        }
    }
    
    
    public class func createSocket(family: MaoSocketEnum.Family, host: String, port: Int32) throws -> MaoSocketUDP{
        let socketUDP = try! MaoSocketUDP(family: family, socketType: MaoSocketEnum.SocketType.datagram, socketProtocol: MaoSocketEnum.SocketProtocol.udp)
        var status = -1
        var socketError:Error? = nil
        do {
            status =  try socketUDP.connect(host, port)
        } catch let error {
            socketError = error
        }
        guard let socketDelegate = socketUDP.delegate else {
            return socketUDP
        }
        if status < 0 {
            socketDelegate.socketUDPDisConnect(socket: socketUDP, error: socketError as? MaoSocketError)
        }else {
            socketDelegate.socketUDPDidConnect(socket: socketUDP)
        }
        return socketUDP
    }
    
    
    func sendMessage(data: Data, fn: @escaping(Int) -> Void ) {
        if data.count == 0 {
            fn(-1)
            return
        }
        do {
            let status = try data.withUnsafeBytes() { [unowned self] (buffer: UnsafePointer<UInt8>) throws -> Int in
                return try self.sendMessage(from: buffer, bufSize: data.count, to: (self.signature?.address)!)
            }
            fn(status)
        } catch let error {
            fn(-1)
            guard let socketDelegate = self.delegate else {
                return
            }
            socketDelegate.socketUDPDidSendMessage(socket: self, error: error as! MaoSocketError)
        }
    }
    
    func sendMessage(message: String , fn: @escaping(Int) -> Void) {
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        queue?.async {
            do {
                let status = try message.utf8CString.withUnsafeBufferPointer() {
                    return try self.sendMessage(from: $0.baseAddress!, bufSize: $0.count-1, to: (self.signature?.address)!)
                }
                fn(status)
            } catch let error {
                fn(-1)
                guard let socketDelegate = self.delegate else {
                    return
                }
                socketDelegate.socketUDPDidSendMessage(socket: self, error: error as! MaoSocketError)            }
        }
    }
    
    private func sendMessage(from buffer: UnsafeRawPointer, bufSize: Int, to address: MaoSocketEnum.Address) throws -> Int {
//        Darwin.sendto(self.socketFd, buffer, bufSize, 0, address.addr, address.size)

        // Make sure the buffer is valid...
        if bufSize == 0 {
            
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_INVALID_BUFFER, "buffer is small to zero")
        }
        
        // The socket must've been created and must be connected...
        if self.socketFd == MaoSocketCode.SOCKET_INVALID_DESCRIPTOR {
            
            throw MaoSocketError(MaoSocketCode.SOCKET_ERR_BAD_DESCRIPTOR, "socket is null")
        }
        
        // The socket must've been created for UDP...
        guard let sig = self.signature,
            sig.socketType == .datagram else {
                throw MaoSocketError(MaoSocketCode.SOCKET_ERR_WRONG_PROTOCOL, "This is not a UDP socket.")
        }
        
        var sent = 0
        let sendFlags: Int32 = 0
        
        var addr = address.addr
        let size = address.size
        
        while sent < bufSize {
            
            var status = 0
                status = Darwin.sendto(self.socketFd, buffer.advanced(by: sent), Int(bufSize - sent), sendFlags, &addr, socklen_t(size))
            if status <= 0 {
                
                if errno == EAGAIN {
                    
                    // We have written out as much as we can...
                    return sent
                }
                
                // - Handle a connection reset by peer (ECONNRESET) and throw a different exception...
                if errno == ECONNRESET {
                    
                    throw MaoSocketError(MaoSocketCode.SOCKET_ERR_CONNECTION_RESET, "")
                }
                
                throw MaoSocketError(MaoSocketCode.SOCKET_ERR_WRITE_FAILED, "")
            }
            sent += status
        }
        return sent
    }
    
}


