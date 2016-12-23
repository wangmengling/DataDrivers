//
//  MaoChatMessageModel.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

struct MaoChatMessageModel: DataConversionProtocol {
    var contentType:MaoChatType!
    
    init?(map: DataMap) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(_ map: DataMap) {
        contentType <-> map["contentType"]
    }
}
