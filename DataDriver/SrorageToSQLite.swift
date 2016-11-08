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

struct SrorageToSQLite {
    internal typealias E = DataConversionProtocol
    var sqliteManager = SQLiteManager.instanceManager
    static let instanceManager:SrorageToSQLite = {
        return SrorageToSQLite()
    }()
}

// MARK: - filter sorted
extension SrorageToSQLite {
    func filter(_ predicate:String) -> String{
        var filter = ""
        if predicate.characters.count > 1 {
            filter = " Where "+predicate
        }
        return filter
    }
    
    mutating func sorted(_ property: String, ascending: Bool = true) {
        
    }
}

extension SrorageToSQLite {
    func count(_ object:E,filter:String = "") -> Int {
        var count = 0
        //关键字 来计算count
        let objectsMirror = Mirror(reflecting: object)
        let countSql = "SELECT COUNT(*) AS count FROM \(String(describing: objectsMirror.subjectType)) \(self.filter(filter))"
        count = sqliteManager.count(countSql)
        return count
    }
}

// MARK: - SelectTable

extension SrorageToSQLite {
    mutating func objectsToSQLite(_ tableName:String,filter:String = "",sorted:(String,Bool) = ("",false),limit:(Int,Int) = (0,10)) -> [[String : AnyObject]]? {
        let selectSQL = "SELECT * FROM  \(tableName) \(self.filter(filter));"
        return sqliteManager.fetchArray(selectSQL)
    }
    
    mutating func objectToSQLite(_ tableName:String,filter:String = "") -> [String : AnyObject]? {
        let objectSQL = "SELECT * FROM  \(tableName) \(self.filter(filter)) LIMIT 0,1"
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
    func insert(_ object:E) -> Bool {
        
        let objectsMirror = Mirror(reflecting: object)
        let property = objectsMirror.children
        
        var columns = ""
        var values = ""
        
        
        if let b = AnyBidirectionalCollection(property) {
            
            b.forEach({ (child) in
                guard let columnValue:String = self.proToColumnValues(child.value) , columnValue.characters.count > 0  else  {
                    return
                }
                columns += "\(child.label!),"
                values += columnValue
            })
        }
        
        if property.count > 0 {
            columns = columns.subString(0, length: columns.characters.count - 1)
            values = values.subString(0, length: values.characters.count - 1)
        }
        
        let insertSQL = "INSERT INTO \(String(describing: objectsMirror.subjectType)) (\(columns))  VALUES (\(values));"
        
        sqliteManager.execIOSQL(insertSQL)
        
        return sqliteManager.execSQL(insertSQL)
    }
    
    
    
    /**
     Optional To Value
     
     - parameter value: 属性值
     
     - returns: column values
     */
    func proToColumnValues(_ value:Any) -> String?{
        
        guard let x:Any? = value else {
            return ""
        }
        
        if x.debugDescription == "Optional(nil)" {
            return ""
        }
        
        let m =  Mirror(reflecting: value)
        
        if m.subjectType == Optional<Int>.self{
            return "\(value as! Int),"
        } else if m.subjectType == Optional<Double>.self{
            return "\(value as! Double),"
        } else if m.subjectType == Optional<Float>.self{
            return "\(value as! Float),"
        } else if m.subjectType == Optional<String>.self{
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
        return self.createTable(tableName: String(describing: objectsMirror.subjectType), value: d)
    }
    
    /**
     create table
     
     - parameter tableName: String
     - parameter value: [String:Any]
     */
    func createTable(tableName:String,value:[String:Any]) -> Bool {
        var column = ""
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
    
    
    func proTypeReplace( _ value:Any) -> ColumuType {
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
            if self.createTable(tableName: (value as AnyObject).firstObject as! String, value: (value as AnyObject).lastObject as! [String : Any]){
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
