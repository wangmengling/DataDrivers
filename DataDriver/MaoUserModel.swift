//
//  MaoUser.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

struct MaoUserModel: DataConversionProtocol {
    var userId:Int!
    var name:String!
    var headImage:String!
    var isMe:MaoChatIsMe = .True
    var contentType:MaoChatType!
    
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
        isMe <-> map["isMe"]
        contentType <-> map["contentType"]
    }
}
