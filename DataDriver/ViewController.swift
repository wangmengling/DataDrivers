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
        
        let topicsModel = TopicsModel()
        //topicsModel.author_id = "dsd"
        
//        let dd = DataConversion<TopicsModel>().fieldsType(topicsModel)
//        print(dd)
        
        var store = Storage()
//        let topicsModel =  store.objects(TopicsModel.self)
////                    if store.add(topic, update: false) {
////        
////                    }
//////
//////        let dd =  store.delete(topicsModel.last)
//        let topicModel = topicsModel.last
        print(topicsModel)
//        topicsModel.content = "w"
//        let ds = store.add<TopicsModel>(topicsModel)
//        store.add(topicsModel)
        let ds = store.add(topicsModel, update: false)
        print(ds)
//        NetWork.request(.GET, url: "https://cnodejs.org/api/v1/topics") { (data, response, error) in
//            let dataArray = data?.object(forKey:"data") as AnyObject
//            let topicsssModelArray = DataConversion<TopicsModel>().mapArray(dataArray)
//            let topic = topicsssModelArray.last! as TopicsModel
//            //            Storage().add(topicsssModelArray)
//            
//            print(type(of: topic))
//            
//            
//            var store = Storage()
////            let topicsModel =  store.objects(TopicsModel.self)
////            if store.add(topic, update: false) {
////                
////            }
//
////            let dd =  store.delete(topic)
////            print(topicsModel)
////            return
//            store.addArray(topicsssModelArray)
//            
//            
//            //store.objects()
//        }
    }

}

