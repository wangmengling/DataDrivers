//
//  DataMap.swift
//  demo
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation

open class DataMap {
    open var JSONDictionary: [String : AnyObject] = [:]
    open var JSONDataDictionary: [String : AnyObject] = [:]
    open var currentValue: AnyObject?
    open var currentKey: String?
    
//    open var FeildTypeDictionary: [String : Any.Type] = [:]
    open var FeildTypeDictionary: [String : Any] = [:]
    
    var dataConversionType:DataConversionTypeEnum! = .Model
    
    init(JSONDictionary:[String : AnyObject]?){
        guard let JSONDictionary = JSONDictionary else {
            return
        }
        self.dataConversionType = .Model
        self.JSONDictionary = JSONDictionary
    }
    
    init(toJSON:Bool = false){
        self.dataConversionType = .Json
    }
    
    init(fieldType:Bool) {
        self.dataConversionType = .FieldType
    }
    
    open subscript(key:String) -> DataMap  {
        self.currentKey = key
        // check if a value exists for the current key
        // do this pre-check for performance reasons
        let object = JSONDictionary[key]
        let isNSNull = object is NSNull
        currentValue = isNSNull ? nil : object
        return self
    }
    
    open func value<T>(_ defaultValue:@autoclosure () -> T) -> T?{
        defaultValue()
        return self.currentValue as? T
    }
    
    open func value<T>() -> T? {
        return currentValue as? T
    }
}
