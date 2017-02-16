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

struct MaoSocketEnum {
    
    enum SocketConst: String, CustomStringConvertible {
        case sendMessagQueue                = "com.maoling.sendmessage.queue"
        case reciveMessageQueue             = "com.maoling.recivemessage.queue"
        
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
    public static let SOCKET_RECIVE_BUFFER_SIZE_MINIMUM		= 1024
    public static let SOCKET_RECIVE_BUFFER_SIZE_DEFAULT		= 4096
    
    public static let SOCKET_INVALID_PORT					= Int32(0)
    public static let SOCKET_INVALID_DESCRIPTOR 			= Int32(-1)
    
    public static let SOCKET_ERR_SIGNATURE_FAMILY           = -9999
    public static let SOCKET_ERR_SIGNATURE_STREAM_TCP       = -9998
    public static let SOCKET_ERR_SIGNATURE_DATAGRAM_UDP     = -9997
    
    
    public static let SOCKET_ERR_SOCKET_INIT                = -9996
    public static let SOCKET_ERR_SOCKET_CONNECT_GETADDRINFO = -9995
    
}

private let maoSocket: MaoSocket = MaoSocket()

class MaoSocket {
    //socket 套字节
    fileprivate var socketFd: Int32! = MaoSocketCode.SOCKET_INVALID_DESCRIPTOR
    
    fileprivate var signature: MaoSocketSignature? = nil
    fileprivate var isConnect: Bool = false
    
    fileprivate lazy var sendMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.sendMessagQueue.description)
    
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
    
    class var instance:MaoSocket  {
        return maoSocket
    }
    
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
    
    
    func connect(host: String, port: Int32) throws {
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
            return
        }
        
        status = Darwin.connect(self.socketFd, info.pointee.ai_addr, info.pointee.ai_addrlen)
        guard status != 0 else {
            isConnect = true
            return
        }
        _ = Darwin.close(self.socketFd)  // close socket
    }
}


extension MaoSocket {
    func sendMessage(data: Data) throws -> Int {
        if data.count == 0 {
            return 0
        }
        return try data.withUnsafeBytes() { [unowned self] (buffer: UnsafePointer<UInt8>) throws -> Int in
            return try self.sendMessage(from: buffer, bufSize: data.count)
        }
    }
    
    func sendMessage(message: String) throws -> Int {
        return try message.utf8CString.withUnsafeBufferPointer() {
            // The count returned by nullTerminatedUTF8 includes the null terminator...
            return try self.sendMessage(from: $0.baseAddress!, bufSize: $0.count-1)
        }
    }
    
    func sendMessage(from buffer: UnsafeRawPointer, bufSize: Int) throws -> Int {
        return Darwin.send(self.socketFd, buffer, bufSize, 0)
    }
}

extension MaoSocket {
    func reciveMessage() -> Void {
        
        var reciveFlags: Int32 = 0
        if (self.reciveData.length > 0) {
            reciveFlags |= Int32(MSG_DONTWAIT)
        }
        
        var count: Int = 0
        repeat{
            count = Darwin.recv(self.socketFd, self.reciveBuffer, self.reciveBufferSize, reciveFlags)
            self.reciveData.append(self.reciveBuffer, length: count)
            if count < self.reciveBufferSize {
                break
            }
        } while count > 0
        
        guard let str = NSString(bytes: self.reciveData.bytes, length: self.reciveData.length, encoding: String.Encoding.utf8.rawValue),
            count > 0 else {
                print("error string of data")
                return
//                throw Error(code: Socket.SOCKET_ERR_INTERNAL, reason: "Unable to convert data to NSString.")
        }
        print(str)
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



