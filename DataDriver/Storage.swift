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
    public func objects() ->  SrorageToSQLite {
        return SrorageToSQLite()
    }
    
    
    public func object() -> SrorageToSQLite {
        return SrorageToSQLite()
    }
}

// MARK: - Select Table Data
extension Storage {
    public func count<T:DataConversionProtocol>(_ type:T.Type,filter:String = "") -> Int {
        let srorageToSQLite = SrorageToSQLite()
        let count = srorageToSQLite.count(type,filter: filter)
        return count
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
        if update == true && srorageToSQLite.count(object as! SrorageToSQLite.E.Type) > 0{
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

extension Storage {
    mutating func update<E:DataConversionProtocol>(_ object:E?)  -> Bool {
        return self.add(object, update: true)
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
    fileprivate  func tableName(_ objects:Any) -> String{
        let objectsMirror = Mirror(reflecting: objects)
        return String(describing: objectsMirror.subjectType)
    }
}
