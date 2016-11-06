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
    if right.dataConversionType == .FieldType {
        fieldType(&field, right: right)
        return
    }
    dataConversion(&field, right: right)
}

public func <-> <T>(field: inout T?, right: DataMap) {
    if right.dataConversionType == .FieldType {
        fieldType(&field, right: right)
        return
    }
    dataConversion(&field, right: right)
}

public func <-> <T>(field: inout T, right: DataMap) {
    if right.dataConversionType == .FieldType {
        fieldType(&field, right: right)
        return
    }
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T, right: DataMap) {
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T!, right: DataMap) {
    dataConversion(&field, right: right)
}

public func <-> <T:Collection>(field: inout T?, right: DataMap) {
    dataConversion(&field, right: right)
}


//----------------- DataConversionProtocol
public func <-> <T:DataConversionProtocol>(field: inout T, right: DataMap) {
    if right.dataConversionType == .FieldType {
        fieldType(field, right: right)
    }
    guard let object:T = DataConversion().map(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout T!, right: DataMap) {
    if right.dataConversionType == .FieldType {
        fieldType(field, right: right)
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
        print(field)
        fieldType(field, right: right)
    }
    guard let object:T = DataConversion().map(right.value()) else {
        return
    }
    field = object
}

//----------------- Array<TDataConversionProtocol>
public func <-> <T:DataConversionProtocol>(field: inout Array<T>, right: DataMap) {
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout Array<T>!, right: DataMap) {
    if right.dataConversionType == .FieldType {
//        fieldType(field, right: right)
    }
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

public func <-> <T:DataConversionProtocol>(field: inout Array<T>?, right: DataMap) {
    guard let object:Array<T> = DataConversion().mapArray(right.value()) else {
        return
    }
    field = object
}

/// Object of Raw Representable type
public func <-> <T: RawRepresentable>(field: inout T, right: DataMap) {
    if right.dataConversionType == .FieldType {
//        fieldType(&left, right: right)
        fieldType(&field, right: right)
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
        fieldType(&left, right: right)
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
//        fieldType(&left, right: right)
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
        fieldType(&field, right: right)
    }
}

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

func fieldType<T>(_ field: inout T, right: DataMap) {
    let stringMirror = Mirror(reflecting: field as Any)
    right.FeildTypeDictionary[right.currentKey!] = stringMirror.subjectType
}

func fieldType<T>(_ field: inout T!, right: DataMap) {
    if let object:T = right.value()  {
        field = object
    }else {
        fieldTypeType(&field)
    }
    let stringMirror = Mirror(reflecting: field as Any)
    right.FeildTypeDictionary[right.currentKey!] = stringMirror.subjectType
}

func fieldType<T>(_ field: inout T?, right: DataMap) {
    if let object:T = right.value()  {
        field = object
    }else {
        fieldTypeType(&field)
    }
    let stringMirror = Mirror(reflecting: field as Any)
    right.FeildTypeDictionary[right.currentKey!] = stringMirror.subjectType
}


func fieldType<T:DataConversionProtocol>(_ field: T?, right: DataMap) {
    let dataConversionFieldType = DataConversion<T>().fieldsType(right.value()!)
    right.FeildTypeDictionary[right.currentKey!] = dataConversionFieldType
}

func fieldType<T: RawRepresentable>(_ field: inout T?, right: DataMap) {
    let dMirror = Mirror(reflecting: field?.rawValue)
    print(dMirror.subjectType)
    right.FeildTypeDictionary[right.currentKey!] = dMirror.subjectType
}


func fieldTypeType<T>(_ field: inout T){
    let stringMirror = Mirror(reflecting: field as Any)
    var x:T!
    if stringMirror.subjectType == Optional<Int>.self || stringMirror.subjectType ==  ImplicitlyUnwrappedOptional<Int>.self{
        x = 0 as! T
    }else if stringMirror.subjectType == Optional<String>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<String>.self{
        x = "" as! T
    }
    field = x
}
