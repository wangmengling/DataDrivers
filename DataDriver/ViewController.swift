//
//  ViewController.swift
//  DataDriver
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import Socket

class ViewController: UIViewController,MaoSocketTCPDelegate {
    
    let QUIT: String = "QUIT"
    let port: Int32 = 41234
    let host: String = "127.0.0.1"
    let path: String = "/tmp/server.test.socket"
    var thread:Thread!
    
    var maoSocket: MaoSocketTcp!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let views = UIView()
        views.backgroundColor = UIColor.red
        views.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(views)
        self.protobufText()
        
//        CFRunLoopGetCurrent()
//        RunLoop().getCFRunLoop()
//        RunLoop().getCFRunLoop()
//        RunLoop().getCFRunLoop()
//        RunLoop.current
//        RunLoop.current.run()
        
//        CFRunLoop
//        socket?.write(from: "wode", to: <#T##Socket.Address#>)
        
//        socket?.delegate = self
//        socket.delegate = self
        
//        let width = views.widthAnchor.constraint(equalToConstant: 100)
//        let height = views.heightAnchor.constraint(equalToConstant: 100)
//        let top = views.topAnchor.constraint(equalTo: self.view.topAnchor)
//        let left = views.leftAnchor.constraint(equalTo: view.leftAnchor)
//        NSLayoutConstraint.activate([width,height,top,left])

        
        
        
//        views <<- [
//            Width(100),
//            Height(100),
//            Left(>=10).anchor(self.view.leftAnchor),
//            Top(>=10).anchor(self.view.topAnchor)
//        ]
        
//        views.addLayoutAnchors([
//            Width(100),
//            Height(100),
//            Left(>=10).anchor(self.view.leftAnchor),
//            Top(>=10).anchor(self.view.topAnchor)
//            ])
//        
//        views <<- [
//            Height(200),
//            Width(200)
//        ]
        
//        views.addLayoutAnchor(Left(20).anchor(self.view.leftAnchor))
        
//        views.maoAnchor.addLayoutAnchors { (anchor) in
////            anchor.top
//            anchor.top(10).anchor(self.view.topAnchor)
//            anchor.left(10).anchor(self.view.leftAnchor)
//            anchor.width(100)
//            anchor.height(100)
//        }
        do {
            maoSocket = try MaoSocketTcp(family: .inet, socketType: .stream, socketProtocol: .tcp)
            maoSocket.delegate = self
            maoSocket.connect(host: "127.0.0.1", port: 6969)
            maoSocket.reciveMessage()
        } catch let error {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        //print("sds")
//        MaoUDPSocket.instance.connect()
//        MaoUDPSocket.instance.reciveMessage()
//        MaoTCPSocket.instance.connect()
//        MaoTCPSocket.instance.reciveMessage()
//        self.thread = Thread(target: self, selector: #selector(ViewController.startThread), object: nil)
//        self.thread.start()
//        MaoSocket.instance.connect(host: <#T##String#>, port: <#T##Int32#>)
    }

    @IBAction func ceshiAction(_ sender: AnyObject) {
//            maoSocket = try MaoSocket(family: .inet, socketType: .stream, socketProtocol: .tcp)
//            try maoSocket.connect(host: "127.0.0.1", port: 6969)
//            maoSocket.reciveMessage()
        self.maoSocket.sendMessage(message: "ceshi") { (status) in
            print(status)
        }
            
        
        print("ceshi2")
//        MaoUDPSocket.instance.sendMessage(params: params)
//        MaoTCPSocket.instance.sendMessage()
//        self.perform(#selector(ViewController.test))
//        self.perform(#selector(ViewController.test), on: self.thread, with: nil, waitUntilDone: false)
//        return
        //MaoSocket.instance.listen()
        //testReadWriteUDP()
        
////        let mainQueue = DispatchQueue.main
////        let block = { ()  in
//////            print(Thread.current)
////        }
////        mainQueue.sync(execute: block)
////        
//////        mainQueue.async(execute: block)
////        BlockOperation {() -> Void in
////            print(Thread.current)
////            
////        }
//        
//        let operation = BlockOperation {
////            print(Thread.current)
////            print(pthread_self())
//            print(CFRunLoopGetCurrent())
//        }
//        
//        operation.addExecutionBlock {
//            print("sdsd")
//        }
//        
//        operation.addExecutionBlock { 
//            print("dsds")
//        }
//        
////        CFRunLoop
//        
//        print("sdd")
//        
//        operation.start()
//        self.udp()
//        testReadWriteUDP()
//        return
//        var sto = Storage()
////        let sd = sto.objects().filters("id = '581b0c4ebb9452c9052e7acb'").limit(0, row: 10).valueOfArray(TopicsModel.self)
////        print(sd)
//        
////        let ps = sto.objects().count(<#T##object: SrorageToSQLite.E##SrorageToSQLite.E#>)
//        let ps = sto.count(TopicsModel.self)
//        sto.create(TopicsModel.self, value: [["w":"s"]] as AnyObject)
//        print(ps)
        
//        let t = TopicsModel().value(["content":"wangmengling" as AnyObject],type: TopicsModel.self)
//        let s = TopicsModel(value: ["content":"wangmengling" as AnyObject])
//        let s = TopicsModel().value(["content":"wangmengling" as AnyObject])
//        let d = TopicsModel(value: ["content":"wangmengling"])
//        TopicsModel(["content":"wangmengling" as AnyObject],type:TopicsModel.self)
//        let sd = TopicsModel().values([["content":"wangmengling"]]) as! [TopicsModel]
//        let s = TopicsModel().value(["content":"wangmengling" as AnyObject],type: TopicsModel.self)
//        let ds = TopicsModel()
//        ds.value(["content":"wangmengling" as AnyObject])
//        print(sd)
//        print(s)
//        let ds = TopicsModel().value(["content":"wangmengling"]) as! TopicsModel
//        print(d)
//        t.value(["content":"wangmengling" as AnyObject])
//        t.value(["content":"wangmengling" as AnyObject])
//
//        let ds = t.value(["content":"wangmengling" as AnyObject])
//        TopicsModel.init().value(["content":"wangmengling" as AnyObject])
//        print(ds)
        
        
//        var sd = sto.objects(TopicsModel.self).filters("").sorted("").valueOfArray()
//        print(sd.valueOfArray())
//        sd?.filters("")
        //        sd.valueOfArray()
//        sto.objects(TopicsModel.self).filters("").
//        print(sd)
//        NetWork.requestDataConversionArray(.GET, url: "https://cnodejs.org/api/v1/topics",modelType: TopicsModel.self) { (data, response, error) in
////            print(data!)
////            let dataArray = data?.object(forKey:"data") as AnyObject
////            let topicsssModelArray = DataConversion<TopicsModel>().mapArray(dataArray)
////            print(dataArray)
////            print(topicsssModelArray)
////            Storage().add(topicsssModelArray)
//            var store = Storage()
//            store.addArray(data)
//        }
//        self.getObject()
//        self.useWorkItem()
    }

    
    func getObject()  {
        let tmpData = Date()
        let asd = Storage().objects().filters("").sorted("").valueOfArray(TopicsModel.self)
        let d = Date().timeIntervalSince(tmpData)
        
        print(d)
        print(asd)
        let delTime = Date().timeIntervalSince(tmpData)
        print(delTime)
    }

    
    func useWorkItem() {
        var value = 10
        
        let workItem = DispatchWorkItem {
            value += 5
        }
        
        workItem.perform()
        
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async(execute: workItem)
        
        workItem.notify(queue: DispatchQueue.main) {
            print("value = ", value)
        }
    }
    
    func recv(buffer: UnsafeMutableRawPointer, bufSize: Int) throws -> Int {
        print(bufSize)
        return 1
    }
    
    func udp() {
        let hostname = "127.0.0.1"
        let port: Int32 = 6969
        
        let bufSize = 4096
        var data = Data()
        
        // Create the signature...
        let signature = try! Socket.Signature(protocolFamily: .inet, socketType: .stream, proto: .tcp, hostname: hostname, port: port)!
        
        
        
        // Create the socket...
        let socket = try! createHelper()
        
        // Defer cleanup...
        defer {
            // Close the socket...
            socket.close()
        }
        
        // Connect to the server helper...
        try! socket.connect(using: signature)
        if !socket.isConnected {
            
            fatalError("Failed to connect to the server...")
        }
        
        print("\nConnected to host: \(hostname):\(port)")
        print("\tSocket signature: \(socket.signature!.description)\n")
        
        _ = try! readAndPrint(socket: socket, data: &data)
        
        let hello = "Hello from client..."
        try! socket.write(from: hello)
        
        print("Wrote '\(hello)' to socket...")
        
        let buf = UnsafeMutablePointer<CChar>.allocate(capacity: 19);
        buf.initialize(to: 0, count: 19)
        
        defer {
            buf.deinitialize()
            buf.deallocate(capacity: 19)
        }
        
        // Save room for a null character...
        _ = try! socket.read(into: buf, bufSize: 18, truncate: true)
        let response = String(cString: buf)
        
        
        let response2 = try! readAndPrint(socket: socket, data: &data)
        
        try! socket.write(from: "QUIT")
        
        print("Sent quit to server...")
    }
    
    func createHelper(family: Socket.ProtocolFamily = .inet) throws -> Socket {
        
        let socket = try Socket.create(family: family)
        return socket
    }
    
    func readAndPrint(socket: Socket, data: inout Data) throws -> String? {
        
        data.count = 0
        let	bytesRead = try socket.read(into: &data)
        if bytesRead > 0 {
            
            print("Read \(bytesRead) from socket...")
            
            guard let response = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else {
                
                print("Error accessing received data...")
                return nil
            }
            
            print("Response:\n\(response)")
            return String(describing: response)
        }
        
        return nil
    }
    
    func testReadWriteUDP() {
        
        let hostname = "127.0.0.1"
        let port: Int32 = 41234
        
        let bufSize = 4096
        var data = Data()
        
        do {
            
            self.launchUDPHelper()
            
            // Need to wait for the helper to come up...
//            #if os(Linux)
//                _ = Glibc.sleep(2)
//            #else
//                _ = Darwin.sleep(2)
//            #endif
            
            let socket = try! self.createUDPHelper()
            
            // Defer cleanup...
            defer {
                // Close the socket...
                socket.close()
            }
            
            let addr = Socket.createAddress(for: hostname, on: port)
            
            try socket.write(from: "Hello from UDP".data(using: .utf8)!, to: addr!)
            
            var data = Data()
            var (_, address) = try socket.readDatagram(into: &data)
            
            guard let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                
                print("Error decoding response...")
                data.count = 0
                return
            }
            
            var (remoteHost, remotePort) = Socket.hostnameAndPort(from: address!)!
            print("Received from \(remoteHost):\(remotePort): \(response)\n")
            
            try socket.write(from: "Hello again".data(using: .utf8)!, to: addr!)
            
            let buf = UnsafeMutablePointer<CChar>.allocate(capacity: 10);
            buf.initialize(to: 0, count: 10)
            
            // Save room for a null character...
            (_, address) = try socket.readDatagram(into: buf, bufSize: 9)
            
            let response2 = String(cString: buf)
            (remoteHost, remotePort) = Socket.hostnameAndPort(from: address!)!
            print("Received from \(remoteHost):\(remotePort): \(response2)\n")
            
            print("Sending quit to server...")
            try socket.write(from: "QUIT".data(using: .utf8)!, to: addr!)
            
            // Need to wait for the server to go down before continuing...
//            #if os(Linux)
//                _ = Glibc.sleep(1)
//            #else
//                _ = Darwin.sleep(1)
//            #endif
            
        } catch let error {
            // See if it's a socket error or something else...
            guard let socketError = error as? Socket.Error else {
                
                print("Unexpected error...")
                return
            }
            
            print("testReadWriteUDP Error reported: \(socketError.description)")
        }
    }
    
    func launchUDPHelper(family: Socket.ProtocolFamily = .inet) {
        
        let queue: DispatchQueue? = DispatchQueue.global(qos: .userInteractive)
        guard let pQueue = queue else {
            
            print("Unable to access global interactive QOS queue")
            return
        }
        
        pQueue.async { [unowned self] in
            
            do {
                
                try self.udpHelper(family: family)
                
            } catch let error {
                
                guard let socketError = error as? Socket.Error else {
                    
                    print("Unexpected error...")
                    return
                }
                
                print("launchUDPHelper Error reported:\n \(socketError.description)")
            }
        }
    }
    
    func udpHelper(family: Socket.ProtocolFamily) throws {
        
        var keepRunning = true
        do {
            let socket = try createUDPHelper()
            try socket.listen(on: Int(port))
            
            repeat {
                
                var data = Data()
                
                let (bytesRead, address) = try socket.readDatagram(into: &data)
                
                guard let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                    
                    print("Error decoding response...")
                    data.count = 0
                    return
                }
                
                if response.hasPrefix(QUIT) {
                    keepRunning = false
                }
                
                let (remoteHost, remotePort) = Socket.hostnameAndPort(from: address!)!
                print("Received \(bytesRead) bytes from \(remoteHost):\(remotePort): \(response)\n")
                print("Sending response")
                let responseString: String = "Server response: \n\(response)\n"
                try socket.write(from: responseString.data(using: String.Encoding.utf8)!, to: address!)
                
            } while keepRunning
            
        } catch let error {
            
            guard let socketError = error as? Socket.Error else {
                
                print("Unexpected error...")
                return
            }
            
            // This error is expected when we're shutting it down...
            if socketError.errorCode == Int32(Socket.SOCKET_ERR_WRITE_FAILED) {
                return
            }
            print("udpHelper Error reported: \(socketError.description)")
        }
    }
    
    
    func createUDPHelper(family: Socket.ProtocolFamily = .inet) throws -> Socket {
        
        let socket = try Socket.create(family: family, type: .datagram, proto: .udp)
        
        return socket
    }
}

extension ViewController {
    func startThread() -> Void {
        autoreleasepool { () -> Void in
            let runLoop:RunLoop = RunLoop.current
            runLoop.add(Port(), forMode: RunLoopMode.defaultRunLoopMode)
            runLoop.add(NSMachPort(), forMode: RunLoopMode.defaultRunLoopMode)
            runLoop.run()
        }
    }
    
    func test() -> Void {
        print("sdfasdf")
    }
}

extension ViewController {
    func protobufText() -> Void {
//        let model = SubMessage().getBuilder()
//        model.str = "2"
//        model.str = "2"
//        print(model.str)
    }
}

extension ViewController {
    func socketTCPDidConnect(socket: MaoSocketTcp) {
        print("服务器连接成功")
    }
    func socketTCPDisConnect(socket: MaoSocketTcp, error: MaoSocketError?) {
        print("服务器连接失败")
    }
    func socketTCPDidSendMessage(socket: MaoSocketTcp, error: MaoSocketError) {
        print(error)
    }
    func socketTCPDidReciveMessage(data: NSMutableData,socket: MaoSocketTcp){
        print(data)
    }
}
