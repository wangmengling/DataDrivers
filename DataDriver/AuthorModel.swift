//
//  AuthorModel.swift
//  demo
//
//  Created by jackWang on 16/4/28.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation
import ObjectMapper
class AuthorModel: NSObject,JsonModelProtocol {
    var avatar_url: String?
    var loginname: String?
    func setupReplaceObjectClass() -> [String : String] {
        return [:]
    }
}

struct AuthorsModel: Mappable {
    var avatar_url: String?
    var loginname: String?
//    func setupReplaceObjectClass() -> [String : String] {
//        return [:]
//    }
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(_ map: Map) {
        avatar_url <- map["avatar_url"]
        loginname <- map["loginname"]
    }
}

struct AuthorssModel: DataConversionProtocol {
    var avatar_url: String?
    var loginname: String?
    //    func setupReplaceObjectClass() -> [String : String] {
    //        return [:]
    //    }
//    init?(_ map: Map) {
//        
//    }
    init?(){
        
    }
    
    mutating func mapping(_ map: DataMap) {
        avatar_url <-> map["avatar_url"]
        loginname <-> map["loginname"]
    }
}
