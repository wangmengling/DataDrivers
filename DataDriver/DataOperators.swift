//
//  DataOperators.swift
//  DataDriver
//
//  Created by jackWang on 2016/10/31.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation




//---------------- infix operator <-> {}
//---------------- String Int ......
public func <-> <T>(field: inout T!, right: DataMap) {
    dataConversion(&field, right: right)
}

public func <-> <T>(field: inout T?, right: DataMap) {
    dataConversion(&field, right: right)
}

public func <-> <T>(field: inout T, right: DataMap) {
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T, right: DataMap) {
    if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
        return
    }
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
        return
    }
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
        return
    }
    dataConversion(&field, right: right)
}


//----------------- DataConversionProtocol
public func <-> <T:DataConversionProtocol>(field: inout T, right: DataMap) {
    if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
        return
    }else if right.dataConversionType == .Model {
        guard let object:T = DataConversion().map(right.value()) else {
            return
        }
        field = object
    }else if right.dataConversionType == .Json {
        DataToJSON.toJSON(field, map: right)
    }
}

public func <-> <T:DataConversionProtocol>(field: inout T!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        guard let left = field else {
            if let object:T = right.value()  {
                field = object
            }else {
                right.currentValue = T() as AnyObject!
                field = right.value()
            }
            DataFieldType.fieldType(field, right: right)
            return
        }
        DataFieldType.fieldType(left, right: right)
        return
    }else if right.dataConversionType == .Model {
        guard let object:T = DataConversion().map(right.value()) else {
            return
        }
        field = object
    }else if right.dataConversionType == .Json {
        DataToJSON.toJSON(field, map: right)
    }
}

public func <-> <T:DataConversionProtocol>(field: inout T?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        guard let left = field else {
            if let object:T = right.value()  {
                field = object
            }else {
                right.currentValue = T() as AnyObject!
                field = right.value()
            }
            DataFieldType.fieldType(field, right: right)
            return
        }
        DataFieldType.fieldType(left, right: right)
        return
    }else if right.dataConversionType == .Model {
        guard let object:T = DataConversion().map(right.value()) else {
            return
        }
        field = object
    }else if right.dataConversionType == .Json {
        DataToJSON.toJSON(field, map: right)
    }
}

//----------------- Array<TDataConversionProtocol>
public func <-> <T:DataConversionProtocol>(field: inout Array<T>, right: DataMap) {
    if right.dataConversionType == .FieldType {
        let value:T = T()!
        DataFieldType.fieldType(value, right: right)
        return
    }
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout Array<T>!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        let value = T()
        DataFieldType.fieldType(value, right: right)
        return
    }
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout Array<T>?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        let value = T()
        DataFieldType.fieldType(value, right: right)
        return
    }
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

/// Object of Raw Representable type
public func <-> <T: RawRepresentable>(field: inout T, right: DataMap) {
    if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
        return
    }
    guard let raw = right.currentValue as? T.RawValue  else{
        return
    }
    guard let value = T(rawValue: raw) else {
        return
    }
    field = value
}

/// Optional Object of Raw Representable type
public func <-> <T: RawRepresentable>(left: inout T?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(left, right: right)
        return
    }
    guard let raw = right.currentValue as? T.RawValue  else{
        return
    }
    let value = T(rawValue: raw)
    left = value
}

/// Implicitly Unwrapped Optional Object of Raw Representable type
public func <-> <T: RawRepresentable>(left: inout T!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(left, right: right)
        return
    }
    guard let raw = right.currentValue as? T.RawValue  else{
        return
    }
    guard let value = T(rawValue: raw) else {
        return
    }
    left = value
}

infix operator <->

func dataConversion <T>(_ field: inout T, right: DataMap) {
    if right.dataConversionType == .Model {
        guard let object:T = right.value() else {
            return
        }
        field = object
    }else if right.dataConversionType == .Json {
        DataToJSON.toJSON(field, map: right)
    }else if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
    }
}

func dataConversion <T>(_ field: inout T!, right: DataMap) {
    if right.dataConversionType == .Model {
        guard let object:T = right.value() else {
            return
        }
        field = object
    }else if right.dataConversionType == .Json {
        //        toJSON(field, map: right)
        DataToJSON.toJSON(field, map: right)
    }else if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
    }
}

func dataConversion <T>(_ field: inout T?, right: DataMap) {
    if right.dataConversionType == .Model {
        guard let object:T = right.value() else {
            return
        }
        field = object
    }else if right.dataConversionType == .Json {
//        toJSON(field, map: right)
        DataToJSON.toJSON(field, map: right)
    }else if right.dataConversionType == .FieldType {
        DataFieldType.fieldType(field, right: right)
    }
    
}
