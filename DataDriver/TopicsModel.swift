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
    var id:Int!
    var name:String!
    
    init?(map: DataMap) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(_ map: DataMap) {
        id <-> map["id"]
        name <-> map["name"]
    }
}

class TopicsModel:DataConversionProtocol {
    var num: Int = 0
    var author: AuthorssModel?
    var author_id: String!
    var tab: String!
    var content: String?
    var title: String?
    var visit_count: TopicVisitCountEnum? = TopicVisitCountEnum.default
//    var reply_count: Int = 0
//    var top:Bool = false
    var array:Array<String>!
    var authorArray:Array<AuthorssModel>!
    
    func primaryKey() -> String {
        //        self.description = self.
        return "author_id"
    }
    
    required init?(map: DataMap) {
        
    }
    
    init(){
        
    }
    
    func mapping(_ map: DataMap) {
        num <-> map["num"]
        author <-> map["author"]
        author_id <-> map["author_id"]
        tab <-> map["tab"]
        content <-> map["content"]
        title <-> map["title"]
        visit_count <-> map["visit_count"]
        array <->  map["array"]
        authorArray <-> map["authorArray"]
    }
}


