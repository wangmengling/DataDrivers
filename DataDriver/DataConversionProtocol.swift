//
//  DataConversionProtocol.swift
//  demo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation
public protocol DataConversionProtocol{
    init?()
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    mutating func mapping(_ map: DataMap)
    func primaryKey() -> String
//    var description: String { get }
    
    
}

extension DataConversionProtocol {
    func primaryKey() -> String {
        return ""
    }
    
    func ignoredProperties() -> [String] {
        return []
    }
    
    
}

extension DataConversionProtocol{
    func objectForKey(_ key:String) -> Any? {
        let objectsMirror = Mirror(reflecting: self)
        let property = objectsMirror.children
        
        var value:Any?
        
        _ = property.map { (child) -> Mirror.Child? in
            if child.label == key {
                value = child.value as Any
            }
            return nil
        }
        return value
    }
    
    init?(value:[String : AnyObject]){
        self.init()
        self.dataConversion(self,value:value)
    }
    
    func dataConversion<E:DataConversionProtocol>(_ object:E,value:[String : AnyObject]) {
        let d = DataConversion<E>().map(value)
        d.customMirror.children.forEach { (child) in
            print(child.value)
        }
        print(d!)
    }
    
    func value<T:DataConversionProtocol>(_ value:[String : AnyObject],type:T.Type) -> T?{
        let s = DataConversion<T>().map(value)
        return s
    }
}



struct BaseDataConversion:DataConversionProtocol {
    init() {
        
    }
    
    init<T:DataConversionProtocol>(value:[String : AnyObject],type:T? = nil){
        let s = DataConversion<T>().map(value)
        print(s)
    }
    
    func mapping(_ map: DataMap) {
        
    }
}
