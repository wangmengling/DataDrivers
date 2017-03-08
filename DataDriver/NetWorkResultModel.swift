//
//  NetWorkResultModel.swift
//  luoye
//
//  Created by bear on 15/12/8.
//  Copyright © 2015年 98workroom. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum Result{
    case Success(String)
    case Error(NSError)
}

class NetWorkResultModel : Mappable {
    var code:String?
    var message:String?
    var data:AnyObject?
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        code     <- map["code"]
        message  <- map["message"]
        data  <- map["data"]
    }
    
    class func handleResult(resPonse:Response<AnyObject, NSError>)->(valid: Bool?, message: String?){
        if resPonse.result.error != nil{
            return (false,resPonse.result.error?.localizedDescription)
            resPonse.result.error?.localizedDescription
        }else if resPonse.result.value == nil{
            return (false,"服务器忙!")
        }else{
            let resultModel = Mapper<NetWorkResultModel>().map(resPonse.result.value)
            if resultModel?.code != "0" {
                let message = ((resultModel?.message) != nil) ? resultModel?.message : "出现未知错误"
                return (false,message)
            }else{
                return (true,resultModel?.message)
            }
        }
    }
}


