//
//  DataFieldType.swift
//  DataDriver
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
struct DataFieldType {
    //----------------------------------------
    static func fieldType<T:Collection>(_ field: T?, right:DataMap) {
        right.FeildTypeDictionary[right.currentKey!] = String(describing: String().customMirror.subjectType)
    }
    
    static func fieldType<T:Collection>(_ field: T, right:DataMap) {
        right.FeildTypeDictionary[right.currentKey!] = String(describing: String().customMirror.subjectType)
    }
    
    static func fieldType<T>(_ field: T, right: DataMap) {
        let stringMirror = Mirror(reflecting: field as Any)
        right.FeildTypeDictionary[right.currentKey!] = fieldTypeString(stringMirror: stringMirror)
    }
    
    static func fieldType<T:RawRepresentable>(_ field: T?, right: DataMap) {
        let dMirror = Mirror(reflecting: field?.rawValue as Any)
        right.FeildTypeDictionary[right.currentKey!] = fieldTypeString(stringMirror: dMirror)
    }
    
    static func fieldType<T:RawRepresentable>(_ field: T, right: DataMap) {
        let dMirror = Mirror(reflecting: field.rawValue as Any)
        right.FeildTypeDictionary[right.currentKey!] = fieldTypeString(stringMirror: dMirror)
    }
    
    static func fieldType<T:DataConversionProtocol>(_ field: T, right: DataMap) {
        let dataConversionFieldKey = Mirror(reflecting: field as Any)
        let dataConversionFieldType =  [ String(describing: dataConversionFieldKey.subjectType),DataConversion<T>().fieldsType(field)] as [Any]
        right.FeildTypeDictionary[right.currentKey!] = dataConversionFieldType
    }
    
    static func fieldType<T:DataConversionProtocol>(_ field: T?, right: DataMap) {
        guard let field = field  else {
            return
        }
        let dataConversionFieldKey = Mirror(reflecting: field as Any)
        let dataConversionFieldType =  [ String(describing: dataConversionFieldKey.subjectType),DataConversion<T>().fieldsType(right.value()!)] as [Any]
        right.FeildTypeDictionary[right.currentKey!] = dataConversionFieldType
    }
    
    static func fieldTypeString(stringMirror:Mirror) -> Any{
        if stringMirror.subjectType == Optional<Int>.self || stringMirror.subjectType ==  ImplicitlyUnwrappedOptional<Int>.self || stringMirror.subjectType ==  Int.self{
            return Int().customMirror.subjectType
        }else if stringMirror.subjectType == Optional<String>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<String>.self || stringMirror.subjectType ==  String.self{
            return String().customMirror.subjectType
        }else if stringMirror.subjectType == Optional<Bool>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<Bool>.self || stringMirror.subjectType ==  Bool.self{
            return Bool().customMirror.subjectType
        }else if stringMirror.subjectType == Optional<Double>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<Double>.self || stringMirror.subjectType ==  Double.self{
            return Double().customMirror.subjectType
        }else if stringMirror.subjectType == Optional<Float>.self || stringMirror.subjectType == ImplicitlyUnwrappedOptional<Float>.self || stringMirror.subjectType ==  Float.self{
            return Float().customMirror.subjectType
        }
        return String().customMirror.subjectType
    }
}
