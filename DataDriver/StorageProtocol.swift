//
//  StorageProtocol.swift
//  demo
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation

public protocol StorageProtocol{
    func primaryKey() -> String
    func ignoredProperties() -> [String]
}

extension StorageProtocol {
    
    func primaryKey() -> String {
        return ""
    }
    
    func ignoredProperties() -> [String] {
        return []
    }
    
}