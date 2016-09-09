//
//  CarouselView.swift
//  demo
//
//  Created by jackWang on 16/5/15.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit
import EasyPeasy

let timeInterval:TimeInterval = 2

class CarouselView: UIView, UIScrollViewDelegate{
    
    var imageArray:Array<AnyObject>! {
        willSet(newValue) {
            self.imageArray = newValue
        }
        didSet  {
            self.pageControl.numberOfPages = self.imageArray.count
        }
    }
    
    var rhs:[Attribute]!
    
    var contentScrollView: UIScrollView!
    
    var currentImageView: UIImageView!
    var nextImageView: UIImageView!
    var preImageView:UIImageView!
    
    var pageControl:UIPageControl!
    var currentPageIndex:Int! {
        willSet(newValue) {
            self.currentPageIndex = newValue
        }
        didSet{
            self.pageControl.currentPage = self.currentPageIndex
        }
    }
    
    var timer:Timer!
    
    
    //MARK:- Begin
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    convenience init(rhs: [Attribute], imageArray: [UIImage?]?) {
        self.init()
        self.rhs = rhs
//        self.imageArray = []
        self.imageArray = imageArray
        self.buildView()
        
    }
    
    convenience init(rhs: [Attribute]) {
        self.init(rhs:rhs,imageArray: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self <- rhs
        
        contentScrollView <- [Left(0),Top(0),Right(0),Bottom(0),Width(self.frame.width),Height(self.frame.height)]
        self.contentScrollView.contentSize = CGSize(width: self.frame.width * 3.0, height: self.frame.height)
        
        pageControl <-  [
            Right(10),
            Width(100),
            Height(30),
            Bottom(10)
        ]
        
        currentImageView <- [
            Right(self.frame.width*2),
            Top(0),
            Left(self.frame.width),
            Bottom(0),
            Width(self.frame.width),
            Height(self.frame.height)
        ]
        preImageView <- [
            Right(0),
            Top(0),
            Bottom(0),
            Left(0),
            Width(self.frame.width),
            Height(self.frame.height)
        ]
        nextImageView <- [
            Right(self.frame.width * 3.0),
            Top(0),
            Bottom(0),
            Left(self.frame.width * 2.0),
            Width(self.frame.width),
            Height(self.frame.height)
        ]
    }
    
}



extension CarouselView {
    func buildView() -> Void {
        
        contentScrollView = UIScrollView()
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.backgroundColor = UIColor.green
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isScrollEnabled = true
        self.addSubview(contentScrollView)
        
        self.backgroundColor = UIColor.blue
        
        
        pageControl = UIPageControl()
        self.addSubview(pageControl)
        
        
        
        currentImageView = UIImageView()
        self.backgroundColor = UIColor.gray
        self.contentScrollView.addSubview(currentImageView)
        
        
        
        preImageView = UIImageView()
        self.contentScrollView.addSubview(preImageView)
        
        
        nextImageView = UIImageView()
        self.contentScrollView.addSubview(nextImageView)
        
        
        self.currentPageIndex = 0
//        timer = NSTimer(timeInterval: timeInterval, target: self, selector: #selector(CarouselView.carouseAction), userInfo: nil, repeats: true)
        self.setScrollViewOfImage()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(CarouselView.carouseAction), userInfo: nil, repeats: true)
        timer.fire()
    }
}

extension CarouselView {
    func carouseAction() -> Void {
//        self.currentPageIndex = self.currentPageIndex + 1
//        self.currentImageView.image = self.imageArray[self.currentPageIndex] as? UIImage
//        self.contentScrollView.contentOffset = CGPoint(x: CGFloat(self.currentPageIndex)  * self.frame.size.width, y: 0)
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
    }
    
    //MARK: 设置图片
    fileprivate func setScrollViewOfImage(){
        self.currentImageView.image = self.imageArray[self.currentPageIndex] as? UIImage
        self.nextImageView.image = self.imageArray[self.getNextImageIndex(indexOfCurrentImage: self.currentPageIndex)]  as? UIImage
        self.preImageView.image = self.imageArray[self.getLastImageIndex(indexOfCurrentImage: self.currentPageIndex)]  as? UIImage
    }
    
    // 得到上一张图片的下标
    fileprivate func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.imageArray.count - 1
        }else{
            return tempIndex
        }
    }
    
    // 得到下一张图片的下标
    fileprivate func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.imageArray.count ? tempIndex : 0
    }
}


extension CarouselView {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("d")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(self.currentPageIndex)
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.currentPageIndex = self.getLastImageIndex(indexOfCurrentImage: self.currentPageIndex)
        }else if offset == self.frame.size.width * 2 {
            self.currentPageIndex = self.getNextImageIndex(indexOfCurrentImage: self.currentPageIndex)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        //重置计时器
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(CarouselView.carouseAction), userInfo: nil, repeats: true)
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("animator", terminator: "")
        self.scrollViewDidEndDecelerating(contentScrollView)
    }
}
