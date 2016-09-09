//
//  SpringViewController.swift
//  demo
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit

class SpringViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIImageView!
    let ipadView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 151.5))

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image3View: UIImageView!
    @IBOutlet weak var image2View: UIImageView!
    @IBOutlet weak var lableBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.containerView.addSubview(self.ipadView)
        self.hiddenNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ipadView.image = UIImage(named: "top-back_")
        
//        UIView.transitionWithView(self.imageView, duration: 1.5, options: .TransitionFlipFromBottom, animations: {
////            self.view.addSubview(self.ipadView)
//        }, completion: nil)
//        UIView.transitionWithView(self.image2View, duration: 1.5, options: .TransitionFlipFromBottom, animations: {
//            //            self.view.addSubview(self.ipadView)
//            }, completion: nil)
        
//        UIView.transitionWithView(self.label, duration: 2, options: [.CurveEaseOut, .TransitionCrossDissolve], animations: {
////            self.textContainerView.addSubview(self.textView)
//        }, completion: nil)
        
        
        
        
//        UIView.animateKeyframesWithDuration(2, delay: 0, options: [], animations: {
//            // add keyframes
//            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25, animations: {
//                self.view.center.x += 200.0
//            })
//            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.25, animations: {
//                self.view.center.y += 100.0
//            })
//            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.25, animations: {
//                self.view.center.x -= 200.0
//            })
//            UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: {
//                self.view.center.y -= 100.0
//            })
//            }, completion: nil)
        
        
        let zoomInScaleTransform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animateKeyframes(withDuration: 3, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.containerView.center.x += self.view.frame.width
                self.containerView.center.y += -180
                self.containerView.transform = zoomInScaleTransform
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.01, animations: {
                self.containerView.alpha = 1
                self.containerView.transform = zoomInScaleTransform
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.5, animations: {
                self.containerView.transform = CGAffineTransform.identity
                self.containerView.center.x -= self.view.frame.width
                self.containerView.center.y += 90
            })
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.01, animations: {
                self.containerView.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.2, animations: {
                self.containerView.center.x += 33
            })
            }, completion: { _ in
//                self.restorePaperAirplaneStatus()
        })
    }
    
    
    func delay(_ seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonAction(_ sender: AnyObject) {
//        UIView.transitionWithView(self.lableBackView, duration: 2, options: [.CurveLinear, .TransitionCrossDissolve], animations: {
//            
//            }, completion: nil)
//        UIView .transitionWithView(self.label, duration: 2, options: .AllowUserInteraction, animations: {
//            
//            }) { (true) in
//                
//        }
//        UIView.animateWithDuration(0.5, animations: {
//            self.image2View.backgroundColor = UIColor(red: 252.0/255.0, green: 155.0/255.0, blue: 65.0/255.0, alpha: 1)
//        })
        
        UIView.transition(with: self.label, duration: 1.5, options: [.curveEaseOut, .transitionFlipFromBottom], animations: {
            self.label.isHidden = true
            // self.someView.hidden = false
            }, completion: nil)
        
//        UIView.animateWithDuration(1, delay: 0, options: [], animations: {
//            self.iphoneView.frame = CGRectMake(0, 0, 334, 72)
//            self.iphoneContainerView.frame = CGRectMake(26, 130, 334, 72)
//            }, completion: {
//                (flag: Bool) in
//                if flag {
//                    UIView.transitionFromView(self.iphoneContainerView, toView: self.supportIphone, duration: 0.33, options: .TransitionCrossDissolve, completion: nil)
//               	}
//        })
//        
//        UIView.animateWithDuration(1, delay: 1, options: [], animations: {
//            self.ipadView.frame = CGRectMake(0, 0, 334, 72)
//            self.ipadContainerView.frame = CGRectMake(26, 242, 334, 72)
//            }, completion: {
//                (flag: Bool) in
//                if flag {
//                    UIView.transitionFromView(self.ipadContainerView, toView: self.supportIpad, duration: 0.33, options: .TransitionCrossDissolve, completion: nil)
//                }
//        })
//        
//        UIView.animateWithDuration(1, delay: 2, options: [], animations: {
//            self.webView.frame = CGRectMake(0, 0, 334, 72)
//            self.webContainerView.frame = CGRectMake(26, 354, 334, 72)
//            }, completion: {
//                (flag: Bool) in
//                if flag {
//                    UIView.transitionFromView(self.webContainerView, toView: self.supportWeb, duration: 0.33, options: .TransitionCrossDissolve, completion: nil)
//                }
//        })
    }
}

extension SpringViewController {
    func hiddenNavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default) //设置导航栏北京
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
