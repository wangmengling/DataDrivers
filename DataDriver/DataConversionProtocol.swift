//
//  DataConversionProtocol.swift
//  demo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation
public protocol DataConversionProtocol{
    init?(map:DataMap)
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
            if child.label == self.primaryKey() {
                value = child.value
            }
            return nil
        }
        
        return value
    }
}

//extension DataConversionProtocol : CustomStringConvertible {
//    public var description: String

//let objectsMirror = Mirror(reflecting: object)
//let property = objectsMirror.children
//}
