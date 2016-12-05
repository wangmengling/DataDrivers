//
//  SrorageToSQLite.swift
//  demo
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 jackWang. All rights reserved.
//
//        let blobTypes = ["BINARY", "BLOB", "VARBINARY"]
//        let charTypes = ["CHAR", "CHARACTER", "CLOB", "NATIONAL VARYING CHARACTER", "NATIVE CHARACTER", "NCHAR", "NVARCHAR", "TEXT", "VARCHAR", "VARIANT", "VARYING CHARACTER"]
//        //        let davarypes = ["DATE", "DATETIME", "TIME", "TIMESTAMP"]
//        let intTypes  = ["BIGINT", "BIT", "BOOL", "BOOLEAN", "INT", "INT2", "INT8", "INTEGER", "MEDIUMINT", "SMALLINT", "TINYINT"]
//        let nullTypes = ["NULL"]
//        let realTypes = ["DECIMAL", "DOUBLE", "DOUBLE PRECISION", "FLOAT", "NUMERIC", "REAL"]

import Foundation
private let instance = SrorageToSQLite()

public class SrorageToSQLite{
    internal typealias E = DataConversionProtocol
    var sqliteManager = SQLiteManager.instanceManager
    class var instanceManager:SrorageToSQLite  {
        return instance
    }
    
<<<<<<< Updated upstream
    fileprivate var objectType:E.Type?
    fileprivate var tableName:String = ""
    fileprivate var filter:String = ""
    fileprivate var sort:String = ""
    fileprivate var limit:String = ""
=======
    var objectType:E.Type?
    var tableName:String?
    var filter:String? = String()
    var sort:String?  = String()
    var limit:String? = String()
>>>>>>> Stashed changes
    
    
    init() {
        
    }
//    
//    init<T:DataConversionProtocol>(_ type:T.Type) {
//        self.tableName = String(describing: type)
////        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + 2.0) {
////             self.valueOfArray(type)
////        }
//    }
    
    
}

// MARK: - filter sorted
extension SrorageToSQLite {
    
    func filters(_ predicate:String) -> SrorageToSQLite{
        var filter:String = ""
        if predicate.characters.count > 1 {
            filter = " Where "+predicate
        }
        self.filter = filter
        return self
    }
    
    func filter(predicate: NSPredicate) -> SrorageToSQLite {
        var filter:String = ""
        if predicate.predicateFormat.characters.count > 1 {
            filter = " Where " + predicate.predicateFormat
        }
        self.filter = filter
        return self
    }
    
    func sorted(_ property: String, ascending: Bool = false) -> SrorageToSQLite{
        self.sort = "order by \(property) " + (ascending == true ? "ASC" : "DESC")
        return self
    }
    
    func limit(_ pageIndex:Int,row:Int) -> SrorageToSQLite {
        self.limit = "LIMIT \(pageIndex * row),\(row)"
        return self
    }
    
    func valueOfArray<T:DataConversionProtocol>(_ type:T.Type) -> Array<T> {
        self.tableName = String(describing: type)
        let dicArray = self.objectsToSQLite()
        let data:DataConversion =  DataConversion<T>()
        guard let dicArrays = dicArray else {
            return Array<T>()
        }
        let objectArray = data.mapArray(dicArrays)
        return objectArray!
    }
    
    func value<T:DataConversionProtocol>(_ type:T.Type) -> T? {
        self.tableName = String(describing: type)
        let dic = self.objectToSQLite()
        let data:DataConversion =  DataConversion<T>()
        let object = data.map(dic!)
        return object
    }
}

extension SrorageToSQLite {
    func count(_ type:E.Type,filter:String = "") -> Int {
        var count = 0
        self.tableName = String(describing: type)
        //关键字 来计算count
        let countSql = "SELECT COUNT(*) AS count FROM \(self.tableName) \(filter)"
        count = sqliteManager.count(countSql)
        return count
    }
}

// MARK: - SelectTable

extension SrorageToSQLite {
<<<<<<< Updated upstream
    
    fileprivate func objectsToSQLite() -> [[String : AnyObject]]? {
        let selectSQL = "SELECT * FROM  \(self.tableName) \(self.filter) \(self.sort) \(self.limit)"
        return sqliteManager.fetchArray(selectSQL)
    }
    
    fileprivate func objectToSQLite() -> [String : AnyObject]? {
        let objectSQL = "SELECT * FROM  \(self.tableName) \(self.filter)  \(self.sort) LIMIT 0,1"
=======
    fileprivate mutating func objectsToSQLite(_ tableName:String,filter:String = "",sorted:(String,Bool) = ("",false),limit:(Int,Int) = (0,10)) -> [[String : AnyObject]]? {
        let selectSQL = "SELECT * FROM  \(self.tableName) \(self.filter);"
        return sqliteManager.fetchArray(selectSQL)
    }
    
    fileprivate mutating func objectToSQLite(_ tableName:String,filter:String = "") -> [String : AnyObject]? {
        let objectSQL = "SELECT * FROM  \(tableName) \(self.filter(filter)) LIMIT 0,1"
>>>>>>> Stashed changes
        return sqliteManager.fetchArray(objectSQL).last
    }
}

// MARK: - Update Data To Table
extension SrorageToSQLite {
    func update(_ object:E) -> Bool {
        
        //获取主键
        let primaryKey = object.primaryKey()
        guard let primaryKeyValue = object.objectForKey(primaryKey) else {
            return false
        }
        let filter = "Where \(primaryKey) = '\(primaryKeyValue)'"
        
        //设置值
        let objectsMirror = Mirror(reflecting: object)
        let property = objectsMirror.children
        var values = ""
        if let b = AnyBidirectionalCollection(property) {
            
            b.forEach({ (child) in
                guard let columnValue:String = self.proToColumnValues(child.value) , primaryKey != child.label else  {
                    return
                }
                values += "\(child.label!) = \(columnValue)"
            })
            
            if values.characters.count > 0 {
                values = values.subString(0, length: values.characters.count - 1)
            }
        }
        //组装
        let updateSql = "UPDATE \(self.tableName(object)) SET \(values) \(filter)"
        return sqliteManager.execSQL(updateSql)
    }
}



// MARK: - Insert Data To Table
extension SrorageToSQLite {
    func insert<T:DataConversionProtocol>(_ object:T) -> Bool {
        let objectsMirror = Mirror(reflecting: object)
        let property = objectsMirror.children
        
        var columns = ""
        var values = ""
        
        
        let json = DataConversion<T>().toJSON(object)
        let fieldsType = DataConversion<T>().fieldsType(object)
        
        json.forEach { (key,value) in
            let fieldType:Any? = fieldsType[key]
            if fieldType != nil {
                
                guard let columnValue:String = self.proToColumnValues(fieldType!, value) , columnValue.characters.count > 0  else  {
                    return
                }
                columns += "\(key),"
                values += columnValue
            }
        }
        
        if property.count > 0 {
            columns = columns.subString(0, length: columns.characters.count - 1)
            values = values.subString(0, length: values.characters.count - 1)
        }
        
        let insertSQL = "INSERT INTO \(String(describing: objectsMirror.subjectType)) (\(columns))  VALUES (\(values));"
        
        return sqliteManager.execSQL(insertSQL)
    }
    
    
    func insert(_ fieldType:[Any] ,_ value:[String:Any]) -> Bool {
        var columns = ""
        var values = ""
        
        let fieldsType = fieldType.last as? [String:Any]
        let tableName = fieldType.first as? String
        
        value.forEach { (k,v) in
            let fT:Any? = fieldsType?[k]
            if fT != nil {
                guard let columnValue:String = self.proToColumnValues(fT!, v ) , columnValue.characters.count > 0  else  {
                    return
                }
                columns += "\(k),"
                values += columnValue
            }
        }
        if value.count > 0 {
            columns = columns.subString(0, length: columns.characters.count - 1)
            values = values.subString(0, length: values.characters.count - 1)
        }
        if let tableName = tableName {
            let insertSQL = "INSERT INTO \(tableName) (\(columns))  VALUES (\(values));"
            return sqliteManager.execSQL(insertSQL)
        }
        return false
    }
    
    func proToColumnValues(_ fieldType:Any, _ value:Any )  -> String? {
        if fieldType is Int.Type{
            return "\(value as! Int),"
        }else if fieldType is Double.Type{
            return "\(value as! Double),"
        } else if fieldType is Float.Type{
            return "\(value as! Float),"
        } else if fieldType is String.Type{
            return "'\(value as! String)',"
        } else if fieldType is Bool.Type{
            let boolValue = value as! Bool
            if boolValue == true{
                return "1,"
            }
            return "0,"
        } else if fieldType is Array<Any> {
            _ = self.insert(fieldType as! [Any], value as! [String : Any])
            return ""
        }
        return "\(value as! Int),"
    }
    
    func proToColumnValues(_ value:Any?) -> String?{
        guard let x:Any = value else {
            return ""
        }
        
        if (x as AnyObject).debugDescription == "Optional(nil)" {
            return ""
        }
        return self.proToColumnValues(x)
    }
    
    /**
     Optional To Value
     
     - parameter value: 属性值
     
     - returns: column values
     */
    func proToColumnValues(_ value:Any) -> String?{
        
        let m =  Mirror(reflecting: value)
        
        if m.subjectType == Optional<Int>.self{
            return "\(value as! Int),"
        } else if m.subjectType == Optional<Double>.self{
            return "\(value as! Double),"
        } else if m.subjectType == Optional<Float>.self{
            return "\(value as! Float),"
        } else if m.subjectType == Optional<String>.self{
            return "'\(value as! String)',"
        }else if m.subjectType == Optional<Bool>.self{
            return "'\(value as! String)',"
        } else if m.subjectType == ImplicitlyUnwrappedOptional<String>.self {
            return "'\(value)',"
        } else {
            return "\(value),"
        }
    }
}


// MARK: - Delete Object
extension SrorageToSQLite {
    
    private func deleteWhere(_ tableName:String,filter:String) -> Bool {
        let deleteSQL = "DELETE  FROM \(tableName)  WHERE \(filter);"
        return sqliteManager.execSQL(deleteSQL)
    }
    
    func delete(_ object:E) -> Bool {
        let primaryKey = object.primaryKey()
        guard let primaryKeyValue = object.objectForKey(primaryKey) else {
            return false
        }
        let filter = "\(primaryKey) = '\(primaryKeyValue)'"
        return self.delete(object, filter: filter)
    }
    
    func delete(_ object:E,filter:String) -> Bool {
        return self.deleteWhere(self.tableName(object), filter: filter)
    }
    
    func deleteAll(_ type:E.Type) -> Bool {
        let deleteSQL = "DELETE  FROM \(String(describing: type));"
        return sqliteManager.execSQL(deleteSQL)
    }
}
// MARK: - Create Table
extension SrorageToSQLite {
    /**
     check table is exist
     
     - parameter object: E object
     
     - returns: Bool
     */
    func tableIsExists(_ object:E) -> Bool {
        let objectsMirror = Mirror(reflecting: object)
        let sqls = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='\(String(describing: objectsMirror.subjectType))'"
        let tableNum = sqliteManager.count(sqls)
        return tableNum > 0 ? true : false
    }
    
    /**
     create table
     
     - parameter object: E object
     */
    func createTable<E:DataConversionProtocol>(_ object:E) -> Bool {
        let d = DataConversion<E>().fieldsType(object)
        /// 1.反射获取属性
        let objectsMirror = Mirror(reflecting: object)
        
        return self.createTable( String(describing: objectsMirror.subjectType),  d)
    }
    
    /**
     create table
     
     - parameter tableName: String
     - parameter value: [String:Any]
     - parameter fatherTableName: String  父 table
     */
    func createTable(_ tableName:String, _ value:[String:Any], _ fatherTableName:String = "") -> Bool {
        
        
        var column = "storage_\(tableName)_id integer auto_increment ,"
        
        if fatherTableName.characters.count > 0 {
            column += "storage_\(fatherTableName)_id ,"
        }
        
        value.forEach { (pro,value) in
            column += self.proToColumn(pro, value: value)
        }
        
        if column.characters.count > 5 {
            column = column.subString(0, length: column.characters.count - 1)
        }
        let createTabelSQL = "Create TABLE if not exists \(tableName)(\(column));"
        /// 3.执行createTableSql
        return sqliteManager.execSQL(createTabelSQL)
    }
    
    /**
     SQLite Column Type
     
     - CHARACTER: CHARACTER description
     - INT:       INT description
     - FLOAT:     FLOAT description
     - DOUBLE:    DOUBLE description
     - INTEGER:   INTEGER description
     - BLOB:      BLOB description
     - NULL:      NULL description
     - TEXT:      TEXT description
     */
    enum ColumuType: String {
        case CHARACTER,INT,FLOAT,DOUBLE,INTEGER,BLOB,NULL,TEXT
    }
    
    
    func proTypeReplace( _ value:Any,tableName:String = "") -> ColumuType {
//        let sd = Mirror(reflecting: value)
//        print(sd)
        if value is Int.Type{
            return ColumuType.INT
        }else if value is Double.Type{
            return ColumuType.DOUBLE
        } else if value is Float.Type{
            return ColumuType.FLOAT
        } else if value is String.Type{
            return ColumuType.CHARACTER
        } else if value is Bool.Type{
            return ColumuType.INT
        } else if value is Array<Any> {
            if self.createTable((value as AnyObject).firstObject as! String, (value as AnyObject).lastObject as! [String : Any],tableName){
                return ColumuType.INT
            }
            return ColumuType.INT
        }
        return ColumuType.CHARACTER
    }
    
    /**
     Create Table Column Structure ---- E object property To Column SQL
     
     - parameter label: object property
     - parameter value: object property value
     
     - returns: SQL
     */
    func proToColumn(_ label:String,value:Any) -> String {
        var string = ""
        let columuType = self.proTypeReplace(value)
        switch columuType {
        case ColumuType.INT:
            string += "\(label) \(ColumuType.INT.rawValue) ,"
        case ColumuType.DOUBLE:
            string += "\(label) \(ColumuType.DOUBLE.rawValue) ,"
        case ColumuType.FLOAT:
            string += "\(label) \(ColumuType.FLOAT.rawValue) ,"
        case ColumuType.CHARACTER:
            string += "\(label) \(ColumuType.CHARACTER.rawValue)(255) ,"
        default:
            return string
        }
        return string
    }
    
    /**
     type replace [eg:String To CHARACTER]
     
     - parameter value: AnyObject.Type
     
     - returns: Column Type
     */
    func typeReplace(_ value:Any) -> ColumuType {
        guard let x:Any = value else {
            return ColumuType.NULL
        }
        
        let m =  Mirror(reflecting: x)
        if m.subjectType ==  ImplicitlyUnwrappedOptional<Int>.self || m.subjectType == Optional<Int>.self{
            return ColumuType.INT
        } else if m.subjectType ==  ImplicitlyUnwrappedOptional<Double>.self || m.subjectType == Optional<Double>.self{
            return ColumuType.DOUBLE
        } else if m.subjectType ==  ImplicitlyUnwrappedOptional<Float>.self || m.subjectType == Optional<Float>.self{
            return ColumuType.FLOAT
        } else if m.subjectType ==  ImplicitlyUnwrappedOptional<String>.self || m.subjectType == Optional<String>.self{
            return ColumuType.CHARACTER
        }
        
        return ColumuType.NULL
    }
}

extension SrorageToSQLite {
    public func tableName(_ objects:Any) -> String{
        let objectsMirror = Mirror(reflecting: objects)
        return String(describing: objectsMirror.subjectType)
    }
}
