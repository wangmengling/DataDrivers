//
//  TopicsModel.swift
//  demo
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation



enum TopicVisitCountEnum: Int {
    case `default` = 0
    case one = 1
    case two = 2
    case three = 8661
    case four = 1499
}

struct AuthorssModel:DataConversionProtocol {
    var avatar_url:String!
    var loginname:String!
    
    init?(map: DataMap) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(_ map: DataMap) {
        avatar_url <-> map["avatar_url"]
        loginname <-> map["loginname"]
    }
}

class TopicsModel:DataConversionProtocol {
    var id:String!
    var author: AuthorssModel!
    var author_id: String!
    var tab: String!
    var content: String?
    var create_at: String!
    var title: String?
    var visit_count: Int = 0
    var reply_count: Int = 0
    var top:Bool = false
    var good:Bool = false
    var last_reply_at:String!
    
    func primaryKey() -> String {
        return "author_id"
    }
    
    required init?(map: DataMap) {
        
    }
    
    required init(){
        
    }
    
    func mapping(_ map: DataMap) {
        id <-> map["id"]
        author <-> map["author"]
        author_id <-> map["author_id"]
        top <-> map["top"]
        tab <-> map["tab"]
        content <-> map["content"]
        create_at <-> map["create_at"]
        title <-> map["title"]
        visit_count <-> map["visit_count"]
        last_reply_at <->  map["last_reply_at"]
        good <-> map["good"]
        reply_count <-> map["reply_count"]
    }
}


