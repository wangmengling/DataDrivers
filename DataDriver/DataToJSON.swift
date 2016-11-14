//
//  DataToJSON.swift
//  DataDriver
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
struct DataToJSON {
    static func toJSON<T>(_ field: T, map: DataMap) {
        if map.dataConversionType != .Json {
            return
        }
        if let x = field as Any? , false
            || x is NSNumber // Basic types
            || x is Bool
            || x is Int
            || x is Double
            || x is Float
            || x is String
            || x is Array<NSNumber> // Arrays
            || x is Array<Bool>
            || x is Array<Int>
            || x is Array<Double>
            || x is Array<Float>
            || x is Array<String>
            || x is Array<AnyObject>
            || x is Array<Dictionary<String, AnyObject>>
            || x is Dictionary<String, NSNumber> // Dictionaries
            || x is Dictionary<String, Bool>
            || x is Dictionary<String, Int>
            || x is Dictionary<String, Double>
            || x is Dictionary<String, Float>
            || x is Dictionary<String, String>
            || x is Dictionary<String, AnyObject>
        {
            map.JSONDataDictionary[map.currentKey!] = x as AnyObject?
        }
    }
    
    static func toJSON<T>(_ field: T?, map: DataMap) {
        if let field = field {
            self.toJSON(field, map: map)
        }
    }
    
    static func toJSON<T:DataConversionProtocol>(_ field: T, map: DataMap) {
        let json = DataConversion<T>().toJSON(field)
        map.JSONDataDictionary[map.currentKey!] = json as AnyObject?
    }
    
    static func toJSON<T:DataConversionProtocol>(_ field: T?, map: DataMap) {
        if let field = field {
            self.toJSON(field, map: map)
        }
    }
    
    
    static func toJSON<T:DataConversionProtocol>(_ field: Array<T>, map: DataMap) {
        let jsonArray = field.map { (data) -> [String:Any] in
            return DataConversion<T>().toJSON(data)
        }
        map.JSONDataDictionary[map.currentKey!] = jsonArray as AnyObject?
    }
    
    static func toJSON<T:DataConversionProtocol>(_ field: Array<T>?, map: DataMap) {
        if let field = field {
            self.toJSON(field, map: map)
        }
    }
    
    
    static func toJSON<T: RawRepresentable>(_ field: T, map: DataMap) {
        map.JSONDataDictionary[map.currentKey!] = field.rawValue as AnyObject?
    }
    
    static func toJSON<T: RawRepresentable>(_ field: T?, map: DataMap) {
        if let field = field {
            self.toJSON(field, map: map)
        }
    }
    
}
