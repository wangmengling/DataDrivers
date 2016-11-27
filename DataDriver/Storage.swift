//
//  Storage.swift
//  demo
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation

protocol StoragePtotocol {
    
}



public struct Storage:StoragePtotocol{
    public typealias E = DataConversionProtocol
    fileprivate lazy var srorageToSQLite = SrorageToSQLite.instanceManager
    
//    public static let instanceManager:Storage<E> = {
//        return Storage<E>()
//    }()
    
    
    init(){
        
    }
}

// MARK: - Select Table Data
extension Storage {
//    mutating func objects<E:DataConversionProtocol>(_ type:E.Type,_ filter:String = "",sorted:(String,Bool) = ("",false),limit:(Int,Int) = (0,10)) -> Array<E> {
//        let dicArray = srorageToSQLite.objectsToSQLite(String(describing: type))
//        let data:DataConversion =  DataConversion<E>()
//        guard let dicArrays = dicArray else {
//            return Array<E>()
//        }
//        let objectArray = data.mapArray(dicArrays)
//        return objectArray!
//    }
//    
//    public mutating func object<E:DataConversionProtocol>(_ type:E.Type , _ filter:String) -> E? {
//            let dic = srorageToSQLite.objectToSQLite(String(describing: type),filter: filter)
//            let data:DataConversion =  DataConversion<E>()
//            let object = data.map(dic!)
//            return object
//    }
    
    mutating public func objects<E:DataConversionProtocol>(_ type:E.Type) ->  SrorageToSQLite {
        return SrorageToSQLite(type)
    }
    
    
    
    public func object<E:DataConversionProtocol>(_ type:E.Type) -> SrorageToSQLite {
        return SrorageToSQLite(type)
    }
}


// MARK: - Add Table Data
extension Storage {
    
    /**
     add or update Object
     
     - parameter object: <#object description#>
     - parameter update: <#update description#>
     */
    mutating func add<E:DataConversionProtocol>(_ object:E?,update:Bool = false) -> Bool  {
        
        guard let object:E = object else {
            return false
        }
        //创建数据库
        if !srorageToSQLite.tableIsExists(object){
            _ = srorageToSQLite.createTable(object)
        }
        //修改
        if update == true && srorageToSQLite.count(object) > 0{
            return srorageToSQLite.update(object)
        }
        return srorageToSQLite.insert(object)
    }
    
    
    mutating func addArray<T:DataConversionProtocol>(_ objectArray:[T]?) {
        guard let objectArray = objectArray else {
            return
        }
        for (_,element) in objectArray.enumerated() {
            _ = self.add(element,update: false)
        }
    }
}


// MARK: - Delete Table
extension Storage {
    public mutating func delete(_ object:E?) -> Bool  {
        guard let object = object else {
            return false
        }
        return srorageToSQLite.delete(object)
    }
    
    public mutating func deleteAll<E:DataConversionProtocol>(_ type:E.Type) -> Bool {
        return srorageToSQLite.deleteAll(type)
    }
}

extension Storage {
    public func tableName(_ objects:Any) -> String{
        let objectsMirror = Mirror(reflecting: objects)
        return String(describing: objectsMirror.subjectType)
    }
}
