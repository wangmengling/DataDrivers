//
//  MaoChatInputBaseView.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MaoChatInputBaseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate lazy var inputBackView: UIView = {
        let inputBackView = UIView()
        return inputBackView
    }()
    
    lazy var leftItemBackView: UIView = {
        let leftItemBackView = UIView()
        return leftItemBackView
    }()
    
    
    lazy var rightItemBackView: UIView = {
        let rightItemBackView = UIView()
        return rightItemBackView
    }()
    
    lazy var centerItemBackView: UIView = {
        let centerItemBackView = UIView()
        return centerItemBackView
    }()
    
    lazy var keyBoardBackView: UIView = {
        let keyBoardBackView = UIView()
        return keyBoardBackView
    }()
    
    lazy var maoChatType:MaoChatType = .label
    
    func buildView() {
        
    }

}


