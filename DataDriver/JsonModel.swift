//
//  JsonModel.swift
//  demo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation

public protocol JsonModelProtocol {
    func setupReplaceObjectClass() -> [String: String]
}

extension JsonModelProtocol {
    func setupReplaceObjectClass() -> [String: String] {
        return [:]
    }
}

struct JsonModel {
    
    
    
    func jsonToModelArray(_ modelClass:AnyClass, json:Array<AnyObject>) -> Array<Any> {
        let jsonToModelArray = json.map { (singleJson) -> Any in
//            let model = modelClass.init()
            let modelString = NSStringFromClass(modelClass)
            let cls = NSClassFromString(modelString) as? NSObject.Type
            let model = cls!.init()
            let singleJsonModel = self.jsonToModel(model,json: singleJson)
            return singleJsonModel
        }
        return jsonToModelArray
    }
    
    func jsonToModel(_ model:AnyObject, json:AnyObject) -> AnyObject? {
        
        var replaceObjectClass: [String: String]?
        if model is JsonModelProtocol {
            replaceObjectClass =  (model as! JsonModelProtocol).setupReplaceObjectClass()
        }
        
        let mirror = Mirror(reflecting: model)
//        let modelString = NSStringFromClass(model.classForCoder)
//        guard let cls = NSClassFromString(modelString) as? NSObject.Type else {
//            return nil
//        }
//        
//        let obj = cls.init()
        
        mirror.children.map { (child) -> Void in
            let value:AnyObject? = json.object(forKey: child.label!)
            
            if replaceObjectClass!.keys.contains(child.label!) {
                let type = replaceObjectClass![child.label!]!
                if let childClass = NSClassFromString((Bundle.main.object(forInfoDictionaryKey: "CFBundleName")! as AnyObject).description + "." + type) as? NSObject.Type {
                    let childModel = childClass.init()
                    model.setValue(childModel, forKey: child.label!)
                    self.jsonToModel(childModel, json: value!)
                }
            }else{
                model.setValue(value, forKey: child.label!)
            }
        }
        return model
    }
    
    
    
    init(){
        
    }
}
