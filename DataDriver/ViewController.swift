//
//  ViewController.swift
//  DataDriver
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let views = UIView()
        views.backgroundColor = UIColor.red
        views.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(views)
        
        print("sd")
        
//        let width = views.widthAnchor.constraint(equalToConstant: 100)
//        let height = views.heightAnchor.constraint(equalToConstant: 100)
//        let top = views.topAnchor.constraint(equalTo: self.view.topAnchor)
//        let left = views.leftAnchor.constraint(equalTo: view.leftAnchor)
//        NSLayoutConstraint.activate([width,height,top,left])

        
        views <<- [
            Width(100),
            Height(100),
            Left(>=10).anchor(self.view.leftAnchor),
            Top(>=10).anchor(self.view.topAnchor)
        ]
        
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
        print("sds")
    }

    @IBAction func ceshiAction(_ sender: AnyObject) {
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
        let sd = TopicsModel().values([["content":"wangmengling"]]) as! [TopicsModel]
//        let s = TopicsModel().value(["content":"wangmengling" as AnyObject],type: TopicsModel.self)
//        let ds = TopicsModel()
//        ds.value(["content":"wangmengling" as AnyObject])
        print(sd)
//        print(s)
        let ds = TopicsModel().value(["content":"wangmengling"]) as! TopicsModel
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
        self.useWorkItem()
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

