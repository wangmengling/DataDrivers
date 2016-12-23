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
    mutating func mapping(_ map: DataMap)
    func primaryKey() -> String
    
    
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
    
}

extension DataConversionProtocol {
    
    func value(_ value:[String : Any]) -> Any {
        return self.value(value, object: self)
    }
    
    private func value<T:DataConversionProtocol>(_ value:[String : Any],object:T) -> T?{
        let data = DataConversion<T>().map(value)
        return data
    }
    
    func values(_ values:[[String : Any]]) -> Any? {
        return self.values(values, object: self)
    }
    
    private func values<T:DataConversionProtocol>(_ values:[[String : Any]],object:T) -> [T]? {
        let dataArray = DataConversion<T>().mapArray(values)
        return dataArray
    }
}
