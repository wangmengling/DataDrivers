//
//  DataConversion.swift
//  demo
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation

//public typealias E = DataConversionProtocol

public struct DataConversion<Element:DataConversionProtocol> {
    public typealias E = Element
}


// MARK: - JSON Map
extension DataConversion {
    /// Maps a JSON dictionary to an object that conforms to Mappable
    public func map(_ JSONDictionary: [String : AnyObject]) -> E? {
        let dataMap = DataMap(JSONDictionary: JSONDictionary)
        if var object = E() {
            object.mapping(dataMap)
            return object
        }
        //if let klass = E.self as? DataConversionProtocol.Type { // Check if object is Mappable
        //    if var object = klass.init(map: dataMap) as? E {
        //        object.mapping(dataMap)
        //        return object
        //    }
        //} else {
            // Ensure BaseMappable is not implemented directly
        //    assert(false, "BaseMappable should not be implemented directly. Please implement Mappable, StaticMappable or ImmutableMappable")
        //}
        return nil
    }
    
    public func map(_ JSON:AnyObject?) -> E? {
        if let JSON = JSON as? [String : AnyObject] {
            return map(JSON)
        }
        return nil
    }
}

// MARK: - Array
extension DataConversion {
    public func mapArray(_ JSONDictionaryArray: [[String : AnyObject]]) -> [E]? {
        let result = JSONDictionaryArray.flatMap(map)
        return result
    }
    
    public func mapArray(_ JSON: AnyObject?) -> [E] {
        if let JSONArray = JSON as? [[String : AnyObject]] {
            return mapArray(JSONArray)!
        }
        return []
    }
    
    public func mapArray(_ JSONString:String) -> [E] {
        if let JSONArray = self.parseJSONString(JSONString){
            return mapArray(JSONArray)
        }
        return []
    }
    
    public func mapArray(_ JSONData:Data) -> [E] {
        if let JSONArray = self.parseJSONData(JSONData){
            return mapArray(JSONArray)
        }
        return []
    }
}

// MARK: - NO JSON  ->  JSON
extension DataConversion {
    public func parseJSONString(_ JSON: String) -> AnyObject? {
        let data = JSON.data(using: String.Encoding.utf8, allowLossyConversion: true)
        if let data = data {
            let parsedJSON: AnyObject?
            do {
                parsedJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)  as AnyObject?
            } catch let error {
                print(error)
                parsedJSON = nil
            }
            return parsedJSON
        }
        
        return nil
    }
    
    public func parseJSONData(_ JSON: Data) -> AnyObject? {
        let parsedJSON: AnyObject?
        do {
            parsedJSON = try JSONSerialization.jsonObject(with: JSON, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
        } catch let error {
            print(error)
            parsedJSON = nil
        }
        return parsedJSON
    }
}






// MARK: - OBJECT ->  TO JSON----------------------------------------------------------//
extension DataConversion {
    
}


// MARK: - OBJECT ->  TO FeildType-----------------------------------------------------//
extension DataConversion {
    public func fieldsType(_ object: E) -> [String : Any] {
        var mutableObject = object
        let map = DataMap(fieldType: true)
        mutableObject.mapping(map)
        return map.FeildTypeDictionary
    }
}

