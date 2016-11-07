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
        fieldType(field, right: right)
        return
    }
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        fieldType(field, right: right)
        return
    }
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        fieldType(field, right: right)
        return
    }
    dataConversion(&field, right: right)
}


//----------------- DataConversionProtocol
public func <-> <T:DataConversionProtocol>(field: inout T, right: DataMap) {
    if right.dataConversionType == .FieldType {
        fieldType(field, right: right)
        return
    }
    guard let object:T = DataConversion().map(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout T!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        if let object:T = right.value()  {
            field = object
        }else {
            right.currentValue = T() as AnyObject!
            field = right.value()
        }
        fieldType(field, right: right)
        return
    }
    guard let object:T = DataConversion().map(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout T?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        if let object:T = right.value()  {
            field = object
        }else {
            right.currentValue = T() as AnyObject!
            field = right.value()
        }
        fieldType(field, right: right)
        return
    }
    guard let object:T = DataConversion().map(right.value()) else {
        return
    }
    field = object
}

//----------------- Array<TDataConversionProtocol>
public func <-> <T:DataConversionProtocol>(field: inout Array<T>, right: DataMap) {
    if right.dataConversionType == .FieldType {
        let value:T = T()!
        fieldType(value, right: right)
        return
    }
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout Array<T>!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        if let object:Array<T> = right.value()  {
            field = object
        }else {
            right.currentValue = T() as AnyObject!
            field = right.value()
        }
        let value = T()
        fieldType(value, right: right)
        return
    }
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout Array<T>?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        if let object:Array<T> = right.value()  {
            field = object
        }else {
            right.currentValue = T() as AnyObject!
            field = right.value()
        }
        let value = T()
        fieldType(value, right: right)
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
        fieldType(field, right: right)
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
        fieldType(left, right: right)
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
        fieldType(left, right: right)
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
        toJSON(field, map: right)
    }else if right.dataConversionType == .FieldType {
        fieldType(field, right: right)
    }
}

//----------------------------------------
func toJSON<T>(_ field: T?, map: DataMap) {
    if map.dataConversionType != .Json {
        return
    }
    guard let value = field else {
        return
    }
    if let x = value as? AnyObject , false
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
        map.JSONDataDictionary[map.currentKey!] = x
    }
}


//----------------------------------------
func fieldType<T:Collection>(_ field: T?, right:DataMap) {
    right.FeildTypeDictionary[right.currentKey!] = String(describing: String().customMirror.subjectType)
}

func fieldType<T:Collection>(_ field: T, right:DataMap) {
    right.FeildTypeDictionary[right.currentKey!] = String(describing: String().customMirror.subjectType)
}

func fieldType<T>(_ field: T, right: DataMap) {
    let stringMirror = Mirror(reflecting: field as Any)
    right.FeildTypeDictionary[right.currentKey!] = fieldTypeString(stringMirror: stringMirror)
}

func fieldType<T:RawRepresentable>(_ field: T?, right: DataMap) {
    let dMirror = Mirror(reflecting: field?.rawValue as Any)
    right.FeildTypeDictionary[right.currentKey!] = fieldTypeString(stringMirror: dMirror)
}

func fieldType<T:RawRepresentable>(_ field: T, right: DataMap) {
    let dMirror = Mirror(reflecting: field.rawValue as Any)
    right.FeildTypeDictionary[right.currentKey!] = fieldTypeString(stringMirror: dMirror)
}

func fieldType<T:DataConversionProtocol>(_ field: T, right: DataMap) {
    let dataConversionFieldType = DataConversion<T>().fieldsType(field)
    right.FeildTypeDictionary[right.currentKey!] = dataConversionFieldType
}

func fieldType<T:DataConversionProtocol>(_ field: T?, right: DataMap) {
    let dataConversionFieldType = DataConversion<T>().fieldsType(right.value()!)
    right.FeildTypeDictionary[right.currentKey!] = dataConversionFieldType
}



func fieldTypeString(stringMirror:Mirror) -> Any{
    if stringMirror.subjectType == Optional<Int>.self || stringMirror.subjectType ==  ImplicitlyUnwrappedOptional<Int>.self || stringMirror.subjectType ==  Int.self{
        return String(describing: Int().customMirror.subjectType)
    }else if stringMirror.subjectType == Optional<String>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<String>.self || stringMirror.subjectType ==  String.self{
        return String(describing: String().customMirror.subjectType)
    }else if stringMirror.subjectType == Optional<Bool>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<Bool>.self || stringMirror.subjectType ==  Bool.self{
        return String(describing: Bool().customMirror.subjectType)
    }else if stringMirror.subjectType == Optional<Double>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<Double>.self || stringMirror.subjectType ==  Double.self{
        return String(describing: Double().customMirror.subjectType)
    }else if stringMirror.subjectType == Optional<Float>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<Float>.self || stringMirror.subjectType ==  Float.self{
        return String(describing: Float().customMirror.subjectType)
    }
    return String(describing: String().customMirror.subjectType)
}
