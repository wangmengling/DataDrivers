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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.buildView()
    }
    
    lazy var maoChatType:MaoChatType = .label
    
    func buildView() {
        
    }

}


