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
        let s = TopicsModel().value(["content":"wangmengling" as AnyObject])
        let d = TopicsModel(value: ["content":"wangmengling" as AnyObject])
//        TopicsModel(["content":"wangmengling" as AnyObject],type:TopicsModel.self)
        print(s)
        print(d)
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
    }

}

