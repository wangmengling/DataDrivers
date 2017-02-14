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

private let maoSocket:MaoSocket = MaoSocket()
struct MaoSocketEnum {
    enum Family {
        case inet
        case inet6
        
        var value:Int32 {
            switch self {
            case .inet:
                return AF_INET
            case .inet6:
                return AF_INET6
            }
        }
        
        func getFamily(family: Int32) -> Int32 {
            
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
        
    }
    
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
    
    public static let SOCKET_INVALID_PORT					= Int32(0)
    public static let SOCKET_INVALID_DESCRIPTOR 			= Int32(-1)
    
    

    
    //socket 套字节
    private let socketFd: Int32! = SOCKET_INVALID_DESCRIPTOR
    private let family: Int32!
    private let sockType: Int32!
    private let sockProtocol: Int32!
    
    class var instance:MaoSocket  {
        return maoSocket
    }
    
    init() {
        
    }
    
    init(family: MaoSocketEnum.Family, sockType: MaoSocketEnum.SocketType, sockProtocol: MaoSocketEnum.SocketProtocol) {
        self.family = family.value
        self.sockType = sockType.value
        self.sockProtocol = sockProtocol.value
    }
    
    
    func connect() -> Void {
//        self.socketFd = socket(family, sockType, sockProtocol)
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
    public internal(set) var proto: MaoSocketEnum.SocketProtocol
    
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
        
        return "Signature: family: \(self.family), type: \(socketType), protocol: \(proto), address: \(address as MaoSocketEnum.Address?), hostname: \(hostname as String?), port: \(port), path: \(String(describing: path)), bound: \(isBound), secure: \(isSecure)"
    }
    
    // MARK: -- Public Functions
    
    ///
    /// Create a socket signature
    ///
    /// - Parameters:
    ///		- protocolFamily:	The family of the socket to create.
    ///		- socketType:		The type of socket to create.
    ///		- proto:			The protocool to use for the socket.
    /// 	- address:			Address info for the socket.
    ///
    /// - Returns: New Signature instance
    ///
    public init?(protocolFamily: Int32, socketType: Int32, proto: Int32, address: MaoSocketEnum.Address?) throws {
        
        guard let family = MaoSocketEnum.Family.getFamily(forValue: protocolFamily),
            let type = MaoSocketEnum.SocketType.getType(forValue: socketType),
            let pro = MaoSocketEnum.SocketProtocol.getProtocol(forValue: proto) else {
                
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Bad family, type or protocol passed.")
        }
        
        // Validate the parameters...
        if type == .stream {
            guard pro == .tcp || pro == .unix else {
                
                throw MaoSocketError( MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Stream socket must use either .tcp or .unix for the protocol.")
            }
        }
        if type == .datagram {
            guard pro == .udp || pro == .unix else {
                
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Datagram socket must use .udp or .unix for the protocol.")
            }
        }
        
        self.protocolFamily = family
        self.socketType = type
        self.proto = pro
        
        self.address = address
        
    }
    
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
    public init?(family: MaoSocketEnum.Family, socketType: MaoSocketEnum.SocketType, proto: MaoSocketEnum.SocketProtocol, hostname: String?, port: Int32?) throws {
        
        // Make sure we have what we need...
        guard let _ = hostname,
            let port = port, family == .inet || family == .inet6 else {
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Missing hostname, port or both or invalid protocol family.")
        }
        
        self.family = family
        
        // Validate the parameters...
        if socketType == .stream {
            guard proto == .tcp  else {
                
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Stream socket must use either .tcp or .unix for the protocol.")
            }
        }
        if socketType == .dgram {
            guard proto == .udp  else {
                
                throw MaoSocketError(MaoSocketTip.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, "Datagram socket must use .udp or .unix for the protocol.")
            }
        }
        
        self.socketType = socketType
        self.proto = proto
        
        self.hostname = hostname
        self.port = port
    }
    
    ///
    /// Create a socket signature
    ///
    ///	- Parameters:
    ///		- socketType:		The type of socket to create.
    ///		- proto:			The protocool to use for the socket.
    /// 	- path:				Pathname for this signature.
    ///
    /// - Returns: New Signature instance
    ///
    public init?(socketType: MaoSocket.SocketType, proto: MaoSocket.SocketProtocol, path: String?) throws {
        
        // Make sure we have what we need...
        guard let _ = path else {
            
            throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Missing pathname.")
        }
        
        // Default to Unix socket protocol family...
        self.protocolFamily = .unix
        
        self.socketType = socketType
        self.proto = proto
        
        // Validate the parameters...
        if socketType == .stream {
            guard proto == .tcp || proto == .unix else {
                
                throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Stream socket must use either .tcp or .unix for the protocol.")
            }
        }
        if socketType == .datagram {
            guard proto == .udp || proto == .unix else {
                
                throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Datagram socket must use .udp or .unix for the protocol.")
            }
        }
        
        self.path = path
        
        if path!.utf8.count == 0 {
            
            throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Specified path contains zero (0) bytes.")
        }
        
        // Create the address...
        var remoteAddr = sockaddr_un()
        remoteAddr.sun_family = sa_family_t(AF_UNIX)
        
        let lengthOfPath = path!.utf8.count
        
        // Validate the length...
        guard lengthOfPath < MemoryLayout.size(ofValue: remoteAddr.sun_path) else {
            
            throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Pathname supplied is too long.")
        }
        
        _ = withUnsafeMutablePointer(to: &remoteAddr.sun_path.0) { ptr in
            
            path!.withCString {
                strncpy(ptr, $0, lengthOfPath)
            }
        }
        
        #if !os(Linux)
            remoteAddr.sun_len = UInt8(MemoryLayout<UInt8>.size + MemoryLayout<sa_family_t>.size + path!.utf8.count + 1)
        #endif
        
        self.address = .unix(remoteAddr)
    }
    
    ///
    /// Create a socket signature
    ///
    /// - Parameters:
    ///		- protocolFamily:	The family of the socket to create.
    ///		- socketType:		The type of socket to create.
    ///		- proto:			The protocool to use for the socket.
    /// 	- address:			Address info for the socket.
    /// 	- hostname:			Hostname for this signature.
    /// 	- port:				Port for this signature.
    ///
    /// - Returns: New Signature instance
    ///
    internal init?(protocolFamily: Int32, socketType: Int32, proto: Int32, address: Address?, hostname: String?, port: Int32?) throws {
        
        // This constructor requires all items be present...
        guard let family = ProtocolFamily.getFamily(forValue: protocolFamily),
            let type = SocketType.getType(forValue: socketType),
            let pro = SocketProtocol.getProtocol(forValue: proto),
            let _ = hostname,
            let port = port else {
                
                throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Incomplete parameters.")
        }
        
        self.protocolFamily = family
        self.socketType = type
        self.proto = pro
        
        // Validate the parameters...
        if type == .stream {
            guard (pro == .tcp || pro == .unix) else {
                
                throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Stream socket must use either .tcp or .unix for the protocol.")
            }
        }
        if type == .datagram {
            guard pro == .udp else {
                
                throw Error(code: Socket.SOCKET_ERR_BAD_SIGNATURE_PARAMETERS, reason: "Datagram socket must use .udp for the protocol.")
            }
        }
        
        self.address = address
        
        self.hostname = hostname
        self.port = port
    }

}



