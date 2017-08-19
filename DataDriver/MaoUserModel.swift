//
//  MaoUser.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

struct MaoChatUserModel: DataConversionProtocol {
    var userId:Int!
    var name:String!
    var headImage:String!
    
    
    func primaryKey() -> String {
        return "userId"
    }
    
    init?(map: DataMap) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(_ map: DataMap) {
        userId <-> map["userId"]
        name <-> map["name"]
        headImage <-> map["headImage"]
    }
}

struct MaoChatContentModel: DataConversionProtocol {
    var id:Int!
    var content:String!
    var sentTime:Double!
    var reciveTime:Double!
    var isMe:MaoChatIsMe = .True
    var contentType: MaoChatType!
    var userModel: MaoChatUserModel!
    var reciveUserModel: MaoChatUserModel!
    
    func primaryKey() -> String {
        return "userId"
    }
    
    init?(map: DataMap) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(_ map: DataMap) {
        id <-> map["id"]
        content <-> map["content"]
        sentTime <-> map["sentTime"]
        reciveTime <-> map["reciveTime"]
        isMe <-> map["isMe"]
        contentType <-> map["contentType"]
        userModel <-> map["userModel"]
    }
}
