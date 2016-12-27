//
//  ViewController.swift
//  demo
//
//  Created by jackWang on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let d = UILayoutGuide()
        //        d.widthAnchor = NSLayoutDimension().constraint(equalToConstant: 100)
        //        d.a
        //        views.addLayoutGuide(d)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let views = UIView(frame: CGRect.zero)
        views.backgroundColor = UIColor.red
        views.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(views)
        let s = views.widthAnchor.constraint(equalToConstant: 100)
        let d = views.heightAnchor.constraint(equalToConstant: 100)
        let v = views.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20)
        let u = views.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        NSLayoutConstraint.activate([s,d,v,u])
        
//        views <<- [
//            Width(100).anchor(self.view.widthAnchor),
//            Height(100).anchor(self.view.heightAnchor),
//            Left(10).anchor(self.view.leftAnchor),
//            Top(10).anchor(self.view.topAnchor)
//        ]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

