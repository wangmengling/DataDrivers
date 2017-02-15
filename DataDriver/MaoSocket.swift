//
//  MaoSocket.swift
//  DataDriver
//
//  Created by jackWang on 2017/2/2.
//  Copyright © 2017年 apple. All rights reserved.
//
//import Darwin
import Foundation
//import Darwin

private let maoSocket:MaoSocket = MaoSocket(family: <#MaoSocketEnum.Family#>, sockType: <#MaoSocketEnum.SocketType#>, sockProtocol: <#MaoSocketEnum.SocketProtocol#>)
struct MaoSocketEnum {
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
        case dgram
        case raw
        
        var value:Int32 {
            switch self {
            case .stream:
                return SOCK_STREAM
            case .dgram:
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

struct MaoSocketError: Swift.Error, CustomStringConvertible {
    
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

struct MaoSocketTip {
    
    public static let SOCKET_INVALID_PORT					= Int32(0)
    public static let SOCKET_INVALID_DESCRIPTOR 			= Int32(-1)
    
    
    public static let SOCKET_ERR_UNABLE_TO_CREATE_SOCKET    = -9999
    public static let SOCKET_ERR_BAD_DESCRIPTOR				= -9998
    public static let SOCKET_ERR_ALREADY_CONNECTED			= -9997
    public static let SOCKET_ERR_NOT_CONNECTED				= -9996
    public static let SOCKET_ERR_NOT_LISTENING				= -9995
    public static let SOCKET_ERR_ACCEPT_FAILED				= -9994
    public static let SOCKET_ERR_SETSOCKOPT_FAILED			= -9993
    public static let SOCKET_ERR_BIND_FAILED				= -9992
    public static let SOCKET_ERR_INVALID_HOSTNAME			= -9991
    public static let SOCKET_ERR_INVALID_PORT				= -9990
    public static let SOCKET_ERR_GETADDRINFO_FAILED			= -9989
    public static let SOCKET_ERR_CONNECT_FAILED				= -9988
    public static let SOCKET_ERR_MISSING_CONNECTION_DATA	= -9987
    public static let SOCKET_ERR_SELECT_FAILED				= -9986
    public static let SOCKET_ERR_LISTEN_FAILED				= -9985
    public static let SOCKET_ERR_INVALID_BUFFER				= -9984
    public static let SOCKET_ERR_INVALID_BUFFER_SIZE		= -9983
    public static let SOCKET_ERR_RECV_FAILED				= -9982
    public static let SOCKET_ERR_RECV_BUFFER_TOO_SMALL		= -9981
    public static let SOCKET_ERR_WRITE_FAILED				= -9980
    public static let SOCKET_ERR_GET_FCNTL_FAILED			= -9979
    public static let SOCKET_ERR_SET_FCNTL_FAILED			= -9978
    public static let SOCKET_ERR_NOT_IMPLEMENTED			= -9977
    public static let SOCKET_ERR_NOT_SUPPORTED_YET			= -9976
    public static let SOCKET_ERR_BAD_SIGNATURE_PARAMETERS	= -9975
    public static let SOCKET_ERR_INTERNAL					= -9974
    public static let SOCKET_ERR_WRONG_PROTOCOL				= -9973
    public static let SOCKET_ERR_NOT_ACTIVE					= -9972
    public static let SOCKET_ERR_CONNECTION_RESET			= -9971
}

class MaoSocket {
    //socket 套字节
    private let socketFd: Int32! = MaoSocketTip.SOCKET_INVALID_DESCRIPTOR
    private let family: Int32!
    private let sockType: Int32!
    private let sockProtocol: Int32!
    
    private let signature: MaoSocketSignature? = nil
    private let isConnect: Bool
    
    class var instance:MaoSocket  {
        return maoSocket
    }
    
    init(family: MaoSocketEnum.Family, sockType: MaoSocketEnum.SocketType, sockProtocol: MaoSocketEnum.SocketProtocol) {
        self.family = family.value
        self.sockType = sockType.value
        self.sockProtocol = sockProtocol.value
        
        self.socketFd = socket(self.family, self.sockType, self.sockProtocol)
        
        do {
            self.signature = try MaoSocketSignature(family: family, socketType: sockType, socketProtocol: sockProtocol, hostname: nil, port: nil)
        } catch let error {
            print(error)
        }
    }
    
    
    func connect() -> Void {
        if self.socketFd < 0 {
            
        }
        connect(self.socketFd, <#T##UnsafePointer<sockaddr>!#>, <#T##socklen_t#>)
    }
    
    
    func sendMessage() -> Void {
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        guard let pQueue = queue else {
            print("Unable to access global interactive QOS queue")
            return
        }
        pQueue.async {
            do {
//                try self.socket.write(from: "Hello from UDP".data(using: .utf8)!, to: self.addr)
            } catch  let error {
                print(error)
            }
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
    public internal(set) var port: Int32
    
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
    public init?(family: MaoSocketEnum.Family, socketType: MaoSocketEnum.SocketType, socketProtocol: MaoSocketEnum.SocketProtocol, hostname: String?, port: Int32?) throws {
        
        // Make sure we have what we need...
        guard let _ = hostname,
            let port = port, family == .inet || family == .inet6 else {
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Missing hostname, port or both or invalid protocol family.")
        }
        
        
        
        // Validate the parameters...
        if socketType == .stream {
            guard socketProtocol == .tcp  else {
                
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Stream socket must use either .tcp or .unix for the protocol.")
            }
        }
        if socketType == .dgram {
            guard socketProtocol == .udp  else {
                
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Datagram socket must use .udp or .unix for the protocol.")
            }
        }
        
        self.family = family
        self.socketType = socketType
        self.socketProtocol = socketProtocol
        
        self.hostname = hostname
        self.port = port
    }
}



