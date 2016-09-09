//
//  Pop.swift
//  demo
//
//  Created by jackWang on 16/4/18.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit
struct PopAnimate {
    
}

extension UIView {
    ///梯度
    func gradientLayer(_ textLabel:UILabel , text:String) ->  CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.bounds = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        gradientLayer.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.white.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0.2, 0.5, 0.8]
        self.layer.addSublayer(gradientLayer)
        
        textLabel.text = text
        textAnimate(textLabel,text: text)
        gradientLayer.mask = textLabel.layer
        
        let gradient = CABasicAnimation(keyPath: "locations")
        gradient.fromValue = [0, 0, 0.25]
        gradient.toValue = [0.75, 1, 1]
        gradient.duration = 2.5
        gradient.repeatCount = HUGE
        gradientLayer.add(gradient, forKey: nil)
        
        return gradientLayer
    }
    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let intervalTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: intervalTime, execute: {
            completion()
        })
    }
    
    
    func textAnimate(_ textLabel:UILabel , text: String) {
        if text.characters.count > 0 {
            textLabel.text = "\(textLabel.text!)\(text.substring(to: text.characters.index(after: text.startIndex)))"
            delay(seconds: 0.2, completion: {
                self.textAnimate(textLabel,text: text.substring(from: text.characters.index(after: text.startIndex)))
            })
        }
    }
}
