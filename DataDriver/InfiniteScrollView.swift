//
//  InfiniteScrollView.swift
//  demo
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 jackWang. All rights reserved.
//

import UIKit
import EasyPeasy

open class InfiniteScrollView: UIScrollView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    fileprivate var imageViewTapBlock:ViewTapBlock?
    fileprivate var dataArray:Array<String> = Array()
//    private var count:Int = 0
    var rhs:[Attribute]!
    
    convenience init(rhs: [Attribute]) {
        self.init()
        self.rhs = rhs
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
//        self <- self.rhs
        //grab the current content offset (top-left corner)
        var curr = contentOffset
        //if the x value is less than zero
        if curr.x < 0 {
            //update x to the end of the scrollview
            curr.x = contentSize.width - frame.width
            //set the content offset for the view
            contentOffset = curr
        }
            //if the x value is greater than the width - frame width
            //(i.e. when the top-right point goes beyond contentSize.width)
        else if curr.x >= contentSize.width - frame.width {
            //update x to the beginning of the scrollview
            curr.x = 0
            //set the content offset for the view
            contentOffset = curr
        }
    }
    
    
    
    func addIn(_ dataArray: [String]?) {
        //the max number of indicators
        guard let dataArray = dataArray  else {
            return
        }
        self.dataArray = dataArray
        //the gap between indicators
        let count = self.dataArray.count
        let gap:CGFloat = self.frame.width
        
        //initial offset because we're positioning from the center of each indicator's view
        let dx:CGFloat = 0.0
        
        //the calculated total width of the view's contentSize
        let width = CGFloat(count) * gap + dx
        
        
        //create main indicators
        for index in 0...(count-1) {
            //create a center point for the new indicator
            let point = CGPoint(x: CGFloat(index) * gap + dx, y: self.center.y)
            //create a new indicator
            createIndicator(index, at: point)
        }
        
        //create additional indicators
        
        //create an offset variable
        var offset = dx
        
        //The total width (including the last "view" of the infiniteScrollView is based on the width + screen width
        //So, the total width and count of how many "extra" indicators to add is somewhat arbitrary
        //This is why we use a while loop
        
        //while the offset is less than the view's width
        while offset < CGFloat(self.frame.size.width) {
            //create a center point whose x value starts is the total width + the current offset
            let point = CGPoint(x: width + offset, y: self.center.y)
            //create the width
            //increase the offset for the next point
            offset += gap
            //increate x to be used as the variable for the next indicator's number
            createIndicator(count, at: point)
        }
        
        //update infiniteScrollView contentSize
        self.contentSize = CGSize(width: CGFloat(width) + self.frame.size.width, height: 0)
    }
    
    func createIndicator(_ index: Int, at point: CGPoint) {
        
        var dataIndex = index
        
        if dataIndex >= self.dataArray.count {
            dataIndex = index - self.dataArray.count
        }

        let text = self.dataArray[dataIndex]
        
        var imageView = UIImageTapView()
        imageView.value = text as AnyObject?
        imageView.viewTapBlocks { (object) in
            self.imageViewTapBlock!(object)
        }
        let left = CGFloat(index) * self.frame.size.width
        imageView.image = UIImage()
        imageView.contentMode = UIViewContentMode.scaleToFill
        
        imageView.frame.size = self.frame.size
        imageView.frame.origin = CGPoint(x: left, y: 0)
        self.addSubview(imageView)
        imageView.set_MLImageWithURL(URL(string: text)!)
    }
    
    func viewTapBlocks(_ viewTapBlock:@escaping ViewTapBlock) -> Void {
        self.imageViewTapBlock = viewTapBlock
    }
}
