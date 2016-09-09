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
//        self.description = self.
        return ""
    }
    
    func ignoredProperties() -> [String] {
        return []
    }
}

//extension DataConversionProtocol : CustomStringConvertible {
//    public var description: String
//}
