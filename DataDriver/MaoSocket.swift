//
//  MaoSocket.swift
//  DataDriver
//
//  Created by jackWang on 2017/2/2.
//  Copyright © 2017年 apple. All rights reserved.
//  Just For Ios
import Darwin
import Foundation

public typealias SocketFD = Int32
public typealias MaoSocketPort = UInt16

//MARK: MaoSocket protocol
protocol MaoSocketProtocol {
    var socketFd: SocketFD { get }
    var closed: Bool { get }
    var signature: MaoSocketSignature { get }
    var address: MaoSocketAddress { get }
    
    func close() throws
    init(socketFd: SocketFD?, signature: MaoSocketSignature, address: MaoSocketAddress) throws
}

extension MaoSocketProtocol {
    //Close socketFD
    public func close() throws {
        if Darwin.close(self.socketFd) != 0 {
            throw MaoSocketError(.closeSocketFailed, "socket close faild")
        }
    }
    
    //Create socketFD
    static func createNewSocket(signature: MaoSocketSignature) throws -> SocketFD {
        let socketFd = Darwin.socket(signature.family.value, signature.socketType.value, signature.socketProtocol.value)
        guard socketFd >= 0 else { throw MaoSocketError(.createSocketFailed, "create socket failed") }
        return socketFd
    }
}

//MARK: MaoSocket TCP delegate
protocol MaoSocketTCPDelegate {
    func socketTCPDidConnect(socket: MaoSocketTcp)
    func socketTCPDisConnect(socket: MaoSocketTcp, error: MaoSocketError?)
    func socketTCPDidSendMessage(socket: MaoSocketTcp, error: MaoSocketError)
    func socketTCPDidReciveMessage(data: NSMutableData,socket: MaoSocketTcp)
}

//MARK: MaoSocket UDP delegate
protocol MaoSocketUDPDelegate {
    func socketUDPDidSendMessage(socket: MaoSocketUDP, error: MaoSocketError)
    func socketUDPDidReciveMessage(data: NSMutableData,socket: MaoSocketUDP)
}

//MARK: MaoSocket enum
struct MaoSocketEnum {
    
    // Dispath queue name
    enum SocketConst: String, CustomStringConvertible {
        case sendMessagQueue                = "com.maoling.sendmessage.queue"
        case reciveMessageQueue             = "com.maoling.recivemessage.queue"
        case sendMessageUDPQueue            = "com.maoling.sendmessage.udp.queue"
        case reciveMessageUDPQueue          = "com.maoling.recivemessage.udp.queue"
        case heartBeatQueue                 = "com.maoling.heartBeatQueue.queue"
        public var description: String {
            return self.rawValue
        }
    }
    
    // MARK: -- Socket Family
    enum Family {
        case inet
        case inet6
        case unspecified
        
        var value:Int32 {
            switch self {
            case .inet:
                return AF_INET
            case .inet6:
                return AF_INET6
            case .unspecified:
                return AF_UNSPEC
            }
        }
        
        static func getFamily(_ family: Int32) -> MaoSocketEnum.Family? {
            return .inet
        }
        
    }
    
    // MARK: -- Socket DataType
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
    
    // MARK: -- Socket Protocol
    enum SocketProtocol {
        case tcp
        case udp
        
        
        var value: Int32 {
            switch self {
            case .tcp:
                return IPPROTO_TCP
            case .udp:
                return IPPROTO_UDP
            }
        }
        
        static func getProtocol(_ protocol: Int32) -> MaoSocketEnum.SocketProtocol? {
            return .tcp
        }
    }
    
    // MARK: -- Socket Address
    public enum Address {
        
        /// sockaddr_in
        case ipv4(sockaddr_in)
        
        /// sockaddr_in6
        case ipv6(sockaddr_in6)
        
        /// sockaddr_un
        case unix(sockaddr_un)
        
        /// Size of address
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
        
        /// Cast as sockaddr.
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
    
    // MARK: -- Socket ErrorCode
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
        case connectionReset            = -9990
        case sendMessageFailed          = -8999
        case reciveMessageFailed        = -8998
        case invalidConnectAddress      = -8997
    }
    
    // MARK: -- Recive Buffer Size
    public enum BufferSize: Int {
        case reciveMininum = 2014
        case reciveDefault = 4096
    }
}
// MARK: -- MaoSocketError
public struct MaoSocketError: Swift.Error, CustomStringConvertible {
    
    internal(set) var errorCode: MaoSocketEnum.ErrorCode
    
    public internal(set) var errorReason: String?
    
    public var description: String {
        let reason: String = self.errorReason ?? "Reason: Unavailable"
        return "Error code: \(self.errorCode.rawValue)(0x\(String(self.errorCode.rawValue, radix: 16, uppercase: true))), \(reason)"
    }
    
    init(_ code: MaoSocketEnum.ErrorCode, _ reason: String = "no know reason") {
        self.errorCode = code
        self.errorReason = reason
    }
}

// MARK: -- MaoSocketAddress
struct MaoSocketAddress {
    
    /// Host name for connection
    public internal(set) var hostname: String?
    
    /// Port for connection
    public internal(set) var port: Int32?

    /// Protocol Family
    public internal(set) var family: MaoSocketEnum.Family = .unspecified
    
    /// Address info for socket
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
    
    ///Create address and check host is valid
    func createAddress(for host: String, on port: Int32) -> MaoSocketEnum.Address? {
        
        var info: UnsafeMutablePointer<addrinfo>? = UnsafeMutablePointer<addrinfo>.allocate(capacity: 1)
        
        // Retrieve the info on our target...
        var status: Int32 = getaddrinfo(host, String(port), nil, &info)
        if status != 0 {
            return nil
        }
        
        // Defer cleanup of our target info...
        defer {            if info != nil {
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

// MARK: -- MaoSocket Signatrue
struct MaoSocketSignature {
    /// Protocol Family
    public internal(set) var family: MaoSocketEnum.Family
    
    /// Socket Type
    public internal(set) var socketType: MaoSocketEnum.SocketType
   
    /// Socket Protocol.
    public internal(set) var socketProtocol: MaoSocketEnum.SocketProtocol
    
    public var reuseAddress: Bool = true
    
    /// Flag to indicate whether `Socket` is secure or not
    public internal(set) var isSecure: Bool = false
    
    /// Returns a string description of the error.
    public var description: String {
        
        return "MaoSocketSignature: family: \(self.family), type: \(socketType), protocol: \(socketProtocol), secure: \(isSecure)"
    }
    
    // MARK: -- Public Functions
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

//MARK: MaoSocket TCP
class MaoSocketTcp: MaoSocketProtocol {
    /// Socket
    internal var socketFd: SocketFD = MaoSocketEnum.ErrorCode.invalidSocket.rawValue
    
    /// Socket signature
    internal var signature: MaoSocketSignature
    
    /// Socket address
    internal var address: MaoSocketAddress
    
    /// Socket is connect
    fileprivate var isConnect: Bool = false
    
    /// Socket is close
    internal var closed: Bool = false
    
    /// Recive message status , if status is false,will not recive message from server
    var reciveMessageKeepRunning: Bool = true
    
    /// Dispath queue for send message
    fileprivate lazy var sendMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.sendMessagQueue.description)
    
    /// Dispath queue for recive message
    fileprivate lazy var reciveMessageQueue: DispatchQueue = DispatchQueue(label: MaoSocketEnum.SocketConst.reciveMessageQueue.description)
    
    /// MaoSocketTCPDelegate
    var delegate: MaoSocketTCPDelegate?
    
    /// Check if the server status is abnormal， temporarily no use
    var keepLive:Bool {
        set {
            try? self.setKeepLive(newValue)
        }get {
            let keepAlive:Bool? = try? self.getKeepLive()
            return keepAlive ?? false
        }
    }
    
   
    /// Internal read buffer.
    fileprivate lazy var reciveBuffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MaoSocketEnum.BufferSize.reciveDefault.rawValue)
    
    /// Create initially internal Storage Buffer
    var reciveData: NSMutableData = NSMutableData(capacity: MaoSocketEnum.BufferSize.reciveDefault.rawValue)!
    
    /// Recive buffer size
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
        try? self.close()
    }
    
    /// Reply connect
    public func reConnect() throws -> Int {
        if self.socketFd < 0 {
        self.socketFd = try MaoSocketTcp.createNewSocket(signature: self.signature)
        }
        return try self.connect()
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
            reciveMessageKeepRunning = true
            return Int(status)
        }
        _ = Darwin.close(self.socketFd)  // close socket
        return Int(status)
    }
}


extension MaoSocketTcp {
    
    func sendMessage(data: Data, fn: @escaping(Int) -> Void ) {
        if data.count == 0 || self.isConnect != true{
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
        if self.isConnect != true {
            fn(-1)
            return
        }
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
                if self.reciveData.length == 0 {
                    self.isConnect = false
                    self.reciveMessageKeepRunning = false
                    return
                }
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
                if self.reciveData.length == 0 {
                    self.isConnect = false
                    self.reciveMessageKeepRunning = false
                    return
                }
                fn(self.reciveData)
                guard let socketDelegate = self.delegate else {
                    return
                }
                socketDelegate.socketTCPDidReciveMessage(data: self.reciveData, socket: self)
            } while self.reciveMessageKeepRunning
        }
    }
}


extension MaoSocketTcp {
    func setKeepLive<T>(_ value:T) throws -> Void {
        var val = value
        guard setsockopt(self.socketFd, SOL_SOCKET, SO_KEEPALIVE, &val, socklen_t(MemoryLayout<T>.stride)) != -1 else {
            throw MaoSocketError(.invalidConnectAddress, "addrinfo error or nil")
        }
        
        
//        var  keepIdle:Int = 6;
//        var  keepInterval = 5;
//        var  keepCount = 3;
//
//
//        guard setsockopt(self.socketFd, IPPROTO_TCP, TCP_KEEPIDLE, &keepIdle, socklen_t(MemoryLayout<T>.stride)) != -1 else {
//            throw MaoSocketError(.invalidConnectAddress, "addrinfo error or nil")
//        }
//        
//        
//        guard setsockopt(self.socketFd, IPPROTO_TCP, TCP_KEEPCNT, &keepInterval, socklen_t(MemoryLayout<T>.stride)) != -1 else {
//            throw MaoSocketError(.invalidConnectAddress, "addrinfo error or nil")
//        }
//        
//        
//        guard setsockopt(self.socketFd, IPPROTO_TCP, SO_KEEPALIVE, &keepCount, socklen_t(MemoryLayout<T>.stride)) != -1 else {
//            throw MaoSocketError(.invalidConnectAddress, "addrinfo error or nil")
//        }

    }
    
    func getKeepLive<T>() throws -> T {
        var length = socklen_t(MemoryLayout<T>.stride)
        var val = UnsafeMutablePointer<T>.allocate(capacity: 1)
        defer {
            val.deinitialize()
            val.deallocate(capacity: 1)
        }
        guard getsockopt(self.socketFd, SOL_SOCKET, SO_KEEPALIVE, val, &length) != -1 else {
            throw MaoSocketError(.invalidConnectAddress, "addrinfo error or nil")
        }
        return val.pointee
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
    
    //MARK: Recive message
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


