//
//  ViewController.swift
//  DataDriver
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MaoSocketTCPDelegate,MaoSocketUDPDelegate {
    
    @IBOutlet weak var textView: UITextView!
    let QUIT: String = "QUIT"
    let port: Int32 = 41234
    let host: String = "127.0.0.1"
    let path: String = "/tmp/server.test.socket"
    var thread:Thread!
    
    var maoSocket: MaoSocketTcp!
    var maoSocketUdp: MaoSocketUDP!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let views = UIView()
//        views.backgroundColor = UIColor.red
//        views.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(views)
//        self.protobufText()
        
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
        do {
            let address = MaoSocketAddress(hostname: "192.168.1.105", port: 6969)
            
            maoSocket = try MaoSocketTcp(address: address)
            maoSocket.delegate = self
            maoSocket.connect()
            maoSocket.reciveMessage()
        } catch let error {
            print(error)
        }
        
//        do {
//            let address = MaoSocketAddress(hostname: "127.0.0.1", port: 8124)
//            maoSocketUdp = try MaoSocketUDP(address: address)
//            maoSocketUdp.delegate = self
//            maoSocketUdp.reciveMessage()
//        } catch let error {
//            print(error)
//        }
    }

    @IBAction func ceshiAction(_ sender: AnyObject) {
//            maoSocket = try MaoSocket(family: .inet, socketType: .stream, socketProtocol: .tcp)
//            try maoSocket.connect(host: "127.0.0.1", port: 6969)
//            maoSocket.reciveMessage()
        self.maoSocket.sendMessage(message: "ceshi") { (status) in
            print(status)
        }
        
//        self.maoSocketUdp.sendMessage(message: "udpceshi") { (status) in
//            print(status)
//        }
//        print("ceshi2")
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
//////        mainQueue.async(execute: bl®ock)
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
    
}

extension ViewController {
    func startThread() -> Void {
//        autoreleasepool { () -> Void in
//            let runLoop:RunLoop = RunLoop.current
//            runLoop.add(Port(), forMode: RunLoopMode.defaultRunLoopMode)
//            runLoop.add(NSMachPort(), forMode: RunLoopMode.defaultRunLoopMode)
//            runLoop.run()
//        }
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
//        String(d)
        let string : String = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
        
        DispatchQueue.main.async {
            self.textView.text = string
        }
        
    }
    
    func socketUDPDidConnect(socket: MaoSocketUDP) {
        print("服务器连接成功udp")
    }
    func socketUDPDisConnect(socket: MaoSocketUDP, error: MaoSocketError?) {
        print("服务器连接失败udp")
    }
    func socketUDPDidSendMessage(socket: MaoSocketUDP, error: MaoSocketError) {
        print(error.description)
    }
    func socketUDPDidReciveMessage(data: NSMutableData,socket: MaoSocketUDP) {
        print(data)
    }
}
