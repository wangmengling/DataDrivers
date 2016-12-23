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
        views.addSubview(views)
        views.frame.origin
        
        let d = UILayoutGuide()
//        d.widthAnchor = NSLayoutDimension().constraint(equalToConstant: 100)
//        d.a
//        views.addLayoutGuide(d)
        
        views.widthAnchor.constraint(equalToConstant: 100)
        views.heightAnchor.constraint(equalToConstant: 100)
        views.topAnchor.constraint(equalTo: self.view.topAnchor)
        views.leftAnchor.constraint(equalTo: view.leftAnchor)
//        views.addLayoutGuide(<#T##layoutGuide: UILayoutGuide##UILayoutGuide#>)
        views.addLayoutGuides { (layoutGuide) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

