//
//  Actions.swift
//  demo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import Foundation

enum ActionTypes:String{
    case LoginUserUpdateType = "LoginUserUpdateType"
    case GetCustomerAdvertisements = "getCustomerAdvertisements"
    case GetCustomerAdvertisementsModel = "GetCustomerAdvertisementsModel"
    case customerLogin = "customerLogin" //登录
}


private let instance = Actions()
class Actions {
    class var shareInstance: Actions {
        return instance
    }
}