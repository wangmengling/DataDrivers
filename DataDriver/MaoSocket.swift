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

public typealias SocketFD = Int32
public typealias Port = UInt16

protocol MaoSocketProtocol {
    var socketFd: SocketFD { get }
    var closed: Bool { get }
    var signature: MaoSocketSignature { get }
    var address: MaoSocketAddress { get }
    
    func close() throws
    init(socketFd: SocketFD?, signature: MaoSocketSignature, address: MaoSocketAddress) throws
}

extension MaoSocketProtocol {
    public func close() throws {
        if Darwin.close(self.socketFd) != 0 {
            throw MaoSocketError(.closeSocketFailed, "socket close faild")
        }
    }
    
    static func createNewSocket(signature: MaoSocketSignature) throws -> SocketFD {
        let socketFd = Darwin.socket(signature.family.value, signature.socketType.value, signature.socketProtocol.value)
        guard socketFd >= 0 else { throw MaoSocketError(.createSocketFailed, "create socket failed") }
        return socketFd
    }
}
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
        case unspecified
        
        var value:Int32 {
            switch self {
            case .inet:
                return AF_INET
            case .inet6:
                return AF_INET6
            case .unspecified:
                return AF_UNSPEC
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
    
    public enum ErrorCode: Int32 {
        case createSocketFailed         = -99999
        case closeSocketFailed          = -99998
        case socketIsClosed             = -99997
        
        case invalidSocket              = -1
        case family                     = -9999
        case streamTcp                  = -9998
        case datagramUdp                = -9997
        case connectGetAddrinfo         = -9996
        case bufferZero                 = -9991
        case connectionReset = -9990
        case sendMessageFailed = -8999
        case reciveMessageFailed = -8998
        case invalidConnectAddress = -8997
    }
    
    public enum BufferSize: Int {
        case reciveMininum = 2014
        case reciveDefault = 4096
    }
}
// MARK: -- signatrMaoSocketErrorue
public struct MaoSocketError: Swift.Error, CustomStringConvertible {
    
//    public internal(set) var errorCode: Int32
    internal(set) var errorCode: MaoSocketEnum.ErrorCode
    
    public internal(set) var errorReason: String?
    
    public var description: String {
        let reason: String = self.errorReason ?? "Reason: Unavailable"
        return "Error code: \(self.errorCode.rawValue)(0x\(String(self.errorCode.rawValue, radix: 16, uppercase: true))), \(reason)"
    }
    
    
//    init(_ code: Int, _ reason: String) {
//        self.errorCode = Int32(code)
//        self.errorReason = reason
//    }
    
    init(_ code: MaoSocketEnum.ErrorCode, _ reason: String = "no know reason") {
        self.errorCode = code
        self.errorReason = reason
    }
}

// MARK: -- MaoSocketAddress
struct MaoSocketAddress {
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
    //    public internal(set) var path: String? = nil
    
    ///
    /// Protocol Family
    ///
    public internal(set) var family: MaoSocketEnum.Family = .unspecified
    
    ///
    /// Address info for socket. (Readonly)
    ///
    public internal(set) var address: MaoSocketEnum.Address? = nil
    
    public var description: String {
        return "MaoSocketAddress:  address: \(address as MaoSocketEnum.Address?), hostname: \(hostname as String?), port: \(port), family: \(String(describing: family))"
    }
    
    init(hostname: String, port: Int32, family: MaoSocketEnum.Family = .inet) {
        self.hostname = hostname
        self.port = port
        self.family = family
        self.address = self.createAddress(for: hostname, on: port)
    }
    
    func createAddress(for host: String, on port: Int32) -> MaoSocketEnum.Address? {
        
        var info: UnsafeMutablePointer<addrinfo>? = UnsafeMutablePointer<addrinfo>.allocate(capacity: 1)
        
        // Retrieve the info on our target...
        var status: Int32 = getaddrinfo(host, String(port), nil, &info)
        if status != 0 {
            
            return nil
        }
        
        // Defer cleanup of our target info...
        defer {
            
            if info != nil {
                freeaddrinfo(info)
            }
        }
        
        var address: MaoSocketEnum.Address
        if info!.pointee.ai_family == Int32(AF_INET) {
            
            var addr = sockaddr_in()
            memcpy(&addr, info!.pointee.ai_addr, Int(MemoryLayout<sockaddr_in>.size))
            address = .ipv4(addr)
            
        } else if info!.pointee.ai_family == Int32(AF_INET6) {
            
            var addr = sockaddr_in6()
            memcpy(&addr, info!.pointee.ai_addr, Int(MemoryLayout<sockaddr_in6>.size))
            address = .ipv6(addr)
            
        } else {
            
            return nil
        }
        
        return address
    }
}

// MARK: -- signatrue
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
    
    public var reuseAddress: Bool = true
    
    
    
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
        
        return "MaoSocketSignature: family: \(self.family), type: \(socketType), protocol: \(socketProtocol), bound: \(isBound), secure: \(isSecure)"
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
        guard family == .inet || family == .inet6 || family == .unspecified else {
            throw MaoSocketError(.family, "Missing hostname, port or both or invalid protocol family.")
        }
        
        
        // Validate the parameters...
        if socketType == .stream {
            guard socketProtocol == .tcp  else {
                
                throw MaoSocketError(.streamTcp, "Stream socket must use either .tcp or .unix for the protocol.")
            }
        }
        if socketType == .datagram {
            guard socketProtocol == .udp else {
                
                throw MaoSocketError(.datagramUdp, "Datagram socket must use .udp or .unix for the protocol.")
            }
        }
        
        self.family = family
        self.socketType = socketType
        self.socketProtocol = socketProtocol
        
    }
}


//struct MaoSocketCode {
//    public static let SOCKET_RECIVE_BUFFER_SIZE_MINIMUM		= 1024      //recive buffer min
//    public static let SOCKET_RECIVE_BUFFER_SIZE_DEFAULT		= 4096      //recive buffer max
//
//    
//    public static let SOCKET_INVALID_PORT					= Int32(0)
//    public static let SOCKET_INVALID_DESCRIPTOR 			= Int32(-1)
//    
//    public static let SOCKET_ERR_SIGNATURE_FAMILY           = -9999
//    public static let SOCKET_ERR_SIGNATURE_STREAM_TCP       = -9998
//    public static let SOCKET_ERR_SIGNATURE_DATAGRAM_UDP     = -9997
//    
//    
//    public static let SOCKET_ERR_SOCKET_INIT                = -9996
//    public static let SOCKET_ERR_SOCKET_CONNECT_GETADDRINFO = -9995
//    public static let SOCKET_ERR_INVALID_BUFFER             = -9994
//    public static let SOCKET_ERR_BAD_DESCRIPTOR             = -9993
//    public static let SOCKET_ERR_WRONG_PROTOCOL             = -9992
//    public static let SOCKET_ERR_CONNECTION_RESET           = -9991
//    public static let SOCKET_ERR_WRITE_FAILED               = -9990
//}

class MaoSocketTcp: MaoSocketProtocol {
    //socket 套字节
    //socket 套字节
    internal var socketFd: SocketFD = MaoSocketEnum.ErrorCode.invalidSocket.rawValue
    internal var signature: MaoSocketSignature
    internal var address: MaoSocketAddress
    fileprivate var isConnect: Bool = false
    internal var closed: Bool = false
    
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
    
    fileprivate lazy var reciveBuffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MaoSocketEnum.BufferSize.reciveDefault.rawValue)
    ///
    /// Internal Storage Buffer initially created with `Socket.SOCKET_DEFAULT_READ_BUFFER_SIZE`.
    ///
    //    var reciveData: Data = Data(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)
    var reciveData: NSMutableData = NSMutableData(capacity: MaoSocketEnum.BufferSize.reciveDefault.rawValue)!
    
    fileprivate var reciveBufferSize: Int = MaoSocketEnum.BufferSize.reciveDefault.rawValue {
        
        // If the buffer size changes we need to reallocate the buffer...
        didSet {
            
            // Ensure minimum buffer size...
            if reciveBufferSize < MaoSocketEnum.BufferSize.reciveMininum.rawValue {
                reciveBufferSize = MaoSocketEnum.BufferSize.reciveMininum.rawValue
            }
            
            if reciveBufferSize != oldValue {
                reciveBuffer.deinitialize()
                reciveBuffer.deallocate(capacity: oldValue)
                reciveBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: reciveBufferSize)
                reciveBuffer.initialize(to:0)
            }
        }
    }
    
    required init(socketFd: SocketFD?, signature: MaoSocketSignature, address: MaoSocketAddress) throws {
        if let socketFd = socketFd {
            self.socketFd = socketFd
        }else {
            self.socketFd = try MaoSocketTcp.createNewSocket(signature: signature)
        }
        self.address = address
        self.signature = signature
        self.closed = false
    }
    
    convenience init(address: MaoSocketAddress) throws {
        let signature = try MaoSocketSignature(family: address.family, socketType: .stream, socketProtocol: .tcp)!
        try self.init(socketFd: nil, signature: signature, address: address)
    }

    
    deinit {
        // The socket needs to be closed (to close the underlying file descriptor).
        // If descriptors aren't properly freed, the system will run out sooner or later.
        try? self.close()
    }
    
    public func connect() {
        var status = -1
        var socketError:Error? = nil
        do {
            status =  try self.connect()
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
    
    
    fileprivate func connect() throws -> Int{
        if closed { throw MaoSocketError(.socketIsClosed) }
        if self.socketFd < 0 {
            throw MaoSocketError(.invalidSocket, "socket error.")
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
        var status: Int32 = getaddrinfo(self.address.hostname!, String(describing: self.address.port!), &hints, &targetInfo)
        if status != 0 {
            
            var errorString: String
            if status == EAI_SYSTEM {
                errorString = String(validatingUTF8: strerror(errno)) ?? "Unknown error code."
            } else {
                errorString = String(validatingUTF8: gai_strerror(errno)) ?? "Unknown error code."
            }
            throw MaoSocketError(.invalidConnectAddress, errorString)
        }
        
        // Defer cleanup of our target info...
        defer {
            if targetInfo != nil {
                freeaddrinfo(targetInfo)
            }
        }
        
        guard let info: UnsafeMutablePointer<addrinfo> = targetInfo else {
            throw MaoSocketError(.invalidConnectAddress, "addrinfo error or nil")
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



class MaoSocketUDP: MaoSocketProtocol {

    var delegate: MaoSocketUDPDelegate?
    //socket 套字节
    internal var socketFd: SocketFD = MaoSocketEnum.ErrorCode.invalidSocket.rawValue
    internal var signature: MaoSocketSignature
    internal var address: MaoSocketAddress
    fileprivate var isConnect: Bool = false
    internal var closed: Bool = false
    internal var reciveMessageKeepRunning: Bool = true
    
    fileprivate lazy var sendMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.sendMessagQueue.description)
    fileprivate lazy var reciveMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.reciveMessageQueue.description)
    
    //    var delegate: MaoSocketDelegate?
    
    // MARK: -- Private
    
    ///
    /// Internal read buffer.
    /// 	**Note:** The readBuffer is actually allocating unmanaged memory that'll
    ///			be deallocated when we're done with it.
    ///
    
    fileprivate lazy var reciveBuffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MaoSocketEnum.BufferSize.reciveDefault.rawValue)
    ///
    /// Internal Storage Buffer initially created with `Socket.SOCKET_DEFAULT_READ_BUFFER_SIZE`.
    ///
    //    var reciveData: Data = Data(capacity: MaoSocketCode.SOCKET_RECIVE_BUFFER_SIZE_DEFAULT)
    var reciveData: NSMutableData = NSMutableData(capacity: MaoSocketEnum.BufferSize.reciveDefault.rawValue)!
    
    fileprivate var reciveBufferSize: Int = MaoSocketEnum.BufferSize.reciveDefault.rawValue {
        
        // If the buffer size changes we need to reallocate the buffer...
        didSet {
            
            // Ensure minimum buffer size...
            if reciveBufferSize < MaoSocketEnum.BufferSize.reciveMininum.rawValue {
                reciveBufferSize = MaoSocketEnum.BufferSize.reciveMininum.rawValue
            }
            
            if reciveBufferSize != oldValue {
                reciveBuffer.deinitialize()
                reciveBuffer.deallocate(capacity: oldValue)
                reciveBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: reciveBufferSize)
                reciveBuffer.initialize(to:0)
            }
        }
    }
    
    fileprivate lazy var sendMessageUDPQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.sendMessageUDPQueue.description)
    fileprivate lazy var reciveMessageUDPQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.reciveMessageUDPQueue.description)
    

    
    public required init(socketFd: SocketFD?, signature: MaoSocketSignature, address: MaoSocketAddress) throws {
        if let socketFd = socketFd {
            self.socketFd = socketFd
        }else {
            self.socketFd = try MaoSocketUDP.createNewSocket(signature: signature)
        }
        self.signature = signature
        self.address = address
    }
    
    public convenience init(address: MaoSocketAddress) throws {
        let signature = try MaoSocketSignature(family: address.family, socketType: MaoSocketEnum.SocketType.datagram, socketProtocol: MaoSocketEnum.SocketProtocol.udp)!
        try self.init(socketFd: nil, signature: signature, address: address)
    }
    
    func sendMessage(data: Data, fn: @escaping(Int) -> Void ) {
        if data.count == 0 {
            fn(-1)
            return
        }
        do {
            let status = try data.withUnsafeBytes() { [unowned self] (buffer: UnsafePointer<UInt8>) throws -> Int in
                return try self.sendMessage(from: buffer, bufSize: data.count, to: (self.address.address)!)
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
                    return try self.sendMessage(from: $0.baseAddress!, bufSize: $0.count-1, to: (self.address.address)!)
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
            
            throw MaoSocketError(.bufferZero, "buffer is small to zero")
        }
        
        // The socket must've been created and must be connected...
        if self.socketFd == MaoSocketEnum.ErrorCode.invalidSocket.rawValue {
            throw MaoSocketError(.invalidSocket, "socket is null")
        }
        
        // The socket must've been created for UDP...
        guard self.signature.socketType == .datagram else {
                
                throw MaoSocketError(.datagramUdp, "This is not a UDP socket.")
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
                    
                    throw MaoSocketError(.connectionReset, "")
                }
                
                throw MaoSocketError(.sendMessageFailed, "sendto Message Failed")
            }
            sent += status
        }
        return sent
    }
    
}


extension MaoSocketUDP {
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
                _ = try! self.reciveMessageDetail()
                guard let socketDelegate = self.delegate else {
                    return
                }
                socketDelegate.socketUDPDidReciveMessage(data: self.reciveData, socket: self)
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
                _ = try! self.reciveMessageDetail()
                fn(self.reciveData)
                guard let socketDelegate = self.delegate else {
                    return
                }
                socketDelegate.socketUDPDidReciveMessage(data: self.reciveData, socket: self)
            } while keepRunning
        }
    }
    
    func reciveMessageDetail() throws -> (bytesRead: Int, fromAddress: MaoSocketEnum.Address?) {
        if closed { throw MaoSocketError(.socketIsClosed,"socket is close") }
        self.reciveData = NSMutableData(capacity: 0)!
        self.reciveBuffer.deinitialize()
        self.reciveBuffer.initialize(to: 0x0)
        memset(self.reciveBuffer, 0x0, self.reciveBufferSize)
        var address: MaoSocketEnum.Address? = nil
        let reciveFlags: Int32 = 0 //FIXME: allow setting flags with a Swift enum
        
        var length = socklen_t(MemoryLayout<sockaddr_storage>.size)
        let addr = UnsafeMutablePointer<sockaddr_storage>.allocate(capacity: 1)
        var addrSockAddr = UnsafeMutablePointer<sockaddr>(OpaquePointer(addr)).pointee

        var count = 0
        repeat {
            count = Darwin.recvfrom(self.socketFd, self.reciveBuffer, self.reciveBufferSize, reciveFlags, &addrSockAddr, &length)
            if count < 0 {
                
                // - Could be an error, but if errno is EAGAIN or EWOULDBLOCK (if a non-blocking socket),
                //		it means there was NO data to read...
                if errno == EAGAIN || errno == EWOULDBLOCK {
                    
                    // FIXME: If we reach this point because data is available in the internal buffer, we will be *unable* to associate it with an address...
                    return (self.reciveData.length, nil)
                }
                
                // - Handle a connection reset by peer (ECONNRESET) and throw a different exception...
                if errno == ECONNRESET {
                    
                    throw MaoSocketError(MaoSocketEnum.ErrorCode.connectionReset, "recive message failed")
                }
                
                // - Something went wrong...
                throw MaoSocketError(MaoSocketEnum.ErrorCode.reciveMessageFailed, "recive message failed")
            }
            
            if count == 0 {
                break
            }
            
            if count > 0 {
                self.reciveData.append(self.reciveBuffer, length: count)
            }
            if count < self.reciveBufferSize {
                break
            }
        }while count > 0
        
        // Retrieve the address...
        if addrSockAddr.sa_family == sa_family_t(AF_INET6) {
            
            var addr = sockaddr_in6()
            memcpy(&addr, &addrSockAddr, Int(MemoryLayout<sockaddr_in6>.size))
            address = .ipv6(addr)
            
        } else if addrSockAddr.sa_family == sa_family_t(AF_INET) {
            
            var addr = sockaddr_in()
            memcpy(&addr, &addrSockAddr, Int(MemoryLayout<sockaddr_in>.size))
            address = .ipv4(addr)
            
        } else if addrSockAddr.sa_family == sa_family_t(AF_UNSPEC) {
            
            var addr = sockaddr_in()
            memcpy(&addr, &addrSockAddr, Int(MemoryLayout<sockaddr_in>.size))
            address = .ipv4(addr)
        } else {
            throw MaoSocketError( MaoSocketEnum.ErrorCode.streamTcp,  "Unable to determine receiving socket protocol family.")
        }
        return (self.reciveData.length, address)
    }
}


