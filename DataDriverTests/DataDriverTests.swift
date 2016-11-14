//
//  DataDriverTests.swift
//  DataDriverTests
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import XCTest
@testable import DataDriver

class DataDriverTests: XCTestCase {
    
    var topicsModel:TopicsModel?
    var topicsModelArray:Array<TopicsModel>?
    var topicsModelDic:AnyObject?
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddStorage()  {
        NetWork.request(.GET, url: "https://cnodejs.org/api/v1/topics") { (data, response, error) in
            let dataArray = data?.object(forKey:"data") as AnyObject
            let topicsssModelArray = DataConversion<TopicsModel>().mapArray(dataArray)
            let firstObject = topicsssModelArray.first
            var store = Storage()
            _ = store.add(firstObject)
        }
    }
    
    func testDataConversion()  {
        self.measure {
            // Put the code you want to measure the time of here.
            NetWork.request(.GET, url: "https://cnodejs.org/api/v1/topics") { (data, response, error) in
                let dataArray = data?.object(forKey:"data") as AnyObject
                let topicsssModelArray = DataConversion<TopicsModel>().mapArray(dataArray)
                print(topicsssModelArray)
            }
        }
        
    }
    
}
