//
//  ViewModelPProtocol.swift
//  luoye
//
//  Created by bear on 15/12/24.
//  Copyright © 2015年 98workroom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper


typealias ValidationResult = (valid: Bool?, message: String?)
typealias ValidationObservable = Observable<ValidationResult>
typealias ValidationResultDic = Dictionary<String,ValidationResult>
let minPasswordCount = 6

// MARK: - Description =====
protocol ViewModelProtocol{
    var netWorkResult : PublishSubject<ValidationResult> { get set }
    func showValidationNetWorkResult(isShowSuccess:Bool)
}

extension ViewModelProtocol{
    
    func showValidationNetWorkResult(isShowSuccess:Bool = true){
        _ = self.netWorkResult.subscribeNext { (result) -> Void in
            if result.valid == false{
                PKHUDSet.sharedManager.showText(result.message!)
            }else if isShowSuccess == true{
                PKHUDSet.sharedManager.hiden()
            }else {
                PKHUDSet.sharedManager.hiden()
            }
        }
    }
    
    func showValidationNetWorkResult(isShowSuccess:Bool = true,validation:ValidationResult->()){
        _ = self.netWorkResult.subscribeNext { (result) -> Void in
            if result.valid == false{
                PKHUDSet.sharedManager.showText(result.message!)
            }else if isShowSuccess == true{
                PKHUDSet.sharedManager.hiden()
            }
            validation(result)
        }
    }
}


// MARK: - viewModel input validation protocal ========
protocol ViewModelInputValidationProtocal: ViewModelTipMessageProtocal{
//    var tipMessage : PublishSubject<ValidationResult> { get set }
    var inputValidation : Variable<Dictionary<String,ValidationResult>> { get set }
    
    func commitValidation()
    func showTipMessage()
    func showTipMessage(tipMessage:ValidationResult -> Void)
}

extension ViewModelInputValidationProtocal{
    
    // MARK: - show input tip message
    /**
     post network pre validation to tipMessage , Trigger when you click the submit button
     */
    func commitValidation(){
        for (key,result) in self.inputValidation.value{
            if result.valid == false{
                self.tipMessage.onNext(result)
                break
            }else if Array(self.inputValidation.value.keys).last == key{
                self.tipMessage.onNext(result)
            }
        }
    }
    
    /**
     判断输入结果
     
     - parameter name:             <#name description#>
     - parameter validationResult: <#validationResult description#>
     */
    func commitValidation(name:[String] = [], validationResult:ValidationResult -> Void) -> Void {
        var validationResults:ValidationResult = (false,"")
        let inputValidationArray = self.getCommitValidation(name)
        for result in inputValidationArray {
            validationResults = result
            if result.valid == false{
                self.tipMessage.onNext(result)
                break
            }else{
                self.tipMessage.onNext(result)
            }
        }
        validationResult(validationResults)
    }
    
    func getCommitValidation(name:[String] = []) -> Array<ValidationResult> {
        var inputValidationArray:Array<ValidationResult> = Array<ValidationResult>()
        if name.count <= 0 {
            for (_,result) in self.inputValidation.value{
                    inputValidationArray.append(result)
            }
        }else {
            for (key,result) in self.inputValidation.value{
                if name.contains(key) {
                   inputValidationArray.append(result)
                }
            }
        }
        return inputValidationArray
    }
    
    
    
    
    // MARK: - show input tip message
    /**
    show input tip message
    */
    func showTipMessage(){
        //绑定用户验证
        _ = self.tipMessage.subscribeNext { (validation) -> Void in
            if validation.valid == true{
                PKHUDSet.sharedManager.showProgressView()
            }else{
                PKHUDSet.sharedManager.showText(validation.message!)
            }
        }
    }
    
    /**
     show input tip message
     
     - parameter tipMessage: block validation result
     */
    func showTipMessage(tipMessage:ValidationResult -> Void){
        //绑定用户验证
        _ = self.tipMessage.subscribeNext { (result) -> Void in
            if result.valid == true{
                PKHUDSet.sharedManager.showProgressView()
            }else{
                PKHUDSet.sharedManager.showText(result.message!)
            }
            tipMessage(result)
        }
    }
    
    /**
      Show input tip message and true is not show  PKHUD, But false is show
     
     - parameter tipMessage: block validation result
     */
    func showTipMessageWithNext(tipMessage:ValidationResult -> Void){
        //绑定用户验证
        _ = self.tipMessage.subscribeNext { (result) -> Void in
            if result.valid == false {
                PKHUDSet.sharedManager.showText(result.message!)
            }
            tipMessage(result)
        }
    }
}

// MARK: - 输入框验证
extension ViewModelInputValidationProtocal {
    
    //MARK: 手机号码验证
    func validatePhone(phone: String) -> ValidationResult {
        
        if phone.isTelNumber() == false{
            return (false, "请填写正确手机号")
        }
        return (true, "")
    }
    
    //MARK: 密码验证
    func validatePassword(password: String) -> ValidationResult {
        let numberOfCharacters = password.characters.count
        if numberOfCharacters == 0 {
            return (false, "请填写密码")
        }
        
        if numberOfCharacters < minPasswordCount {
            return (false, "密码至少 \(minPasswordCount) 个字符")
        }
        return (true, "Password acceptable")
    }
    
    //MARK: 验证码验证
    func validateCode(code:String) -> ValidationResult {
        if code.characters.count != 4 || code.characters.count == 0 {
            if code.characters.count != 4 {
                return (false , "请输入4位验证码")
            }else {
                return (false , "请输入验证码")
            }
        }
        return (true,"正确")
    }
}


// MARK: - viewModel input validation protocal ===========
protocol ViewModelTipMessageProtocal{
    var tipMessage : PublishSubject<ValidationResult> { get set }
    func showAllTipMessage(tipMessage:ValidationResult -> Void)
}

extension ViewModelTipMessageProtocal {
    /**
     Show input tip message and true is not show  PKHUD, But false is show
     
     - parameter tipMessage: block validation result
     */
    func showAllTipMessage(tipMessage:ValidationResult -> Void){
        //绑定用户验证
        _ = self.tipMessage.subscribeNext { (result) -> Void in
            PKHUDSet.sharedManager.showText(result.message!,afterDelay: 0.5)
            tipMessage(result)
        }
    }
}

protocol ViewModelPageIndexProtocal {
    var pageIndex:Variable<Int>{ get set}
}



// MARK: - 验证码 =========
//protocol ViewModelCodeProtocal:ViewModelProtocol {
//    var phoneText:String? {get set}
//    var getCodeSuccess:PublishSubject<Bool> { get set }  //获取状态
//    var phoneExistModel:PublishSubject<PhoneExistModel> { get set }  //获取状态
//}

//extension ViewModelCodeProtocal {
//    /// 验证手机号是否注册
//    func verifyPhoneNunber(){
//        PKHUDSet.sharedManager.showProgressView()
//        BaseRequest.postRequest(String(urlRootName:.existTel1), parameters: ["tel":self.phoneText!]).responseJSON { (response) in
//            let requestStatus = NetWorkResultModel.handleResult(response)
//            if requestStatus.valid == true {
//                let JSON = response.result.value
//                let phoneExistModel = Mapper<PhoneExistModel>().map(JSON!["data"])
//                self.phoneExistModel.onNext(phoneExistModel!)
//            }
//            self.netWorkResult.onNext(requestStatus)
//        }
//    }
//    
//    // MARK:获取验证码
//    func sendVerifyCode(){
//        BaseRequest.postRequest(String(urlRootName:.sendVerifyCode), parameters: ["tel":self.phoneText!]).responseJSON { (response) in
//            let requestStatus = NetWorkResultModel.handleResult(response)
//            if requestStatus.valid == true {
//                self.getCodeSuccess.onNext(true)
//            }
//            self.netWorkResult.onNext(requestStatus)
//        }
//    }
//}

