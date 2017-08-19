//
//  Message.swift
//  DataDriver
//
//  Created by jackWang on 2017/3/9.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
struct MessageModel: DataConversionProtocol {
    var id: String!
    var type: Int!
    var content: String!
    var reciveUserId: String!
    var sendUserId: String!
    var time: String!
    
    init(){
        
    }
    
    mutating func mapping(_ map: DataMap) {
        
    }
}

struct MessageListModel: DataConversionProtocol {
    var id: String!
    var userName: String!
    var userId: String!
    var time: String!
    var type: Int!          //内容类型
    var content: String!

    init() {
        
    }
    
    mutating func mapping(_ map: DataMap) {
        
    }
}
