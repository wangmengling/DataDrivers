//
//  MaoChatInputToolsView.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/10.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class MaoChatInputToolsView: UIView{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 70, height: 85)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        return layout
    }()
    
    lazy var collectionView:UICollectionView = {
        let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
//        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0)
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.tintColor = UIColor.lightGray
        return pageControl
    }()
    
    var toolsArray:Array<[String]>  {
        get{
            return [["simchat_icons_pic","相册"],["simchat_icons_camera","相机"],["simchat_icons_freeaudio","电话"],["simchat_icons_location","位置"]]
        }set {
            self.pageControl.numberOfPages = newValue.count
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

}

extension MaoChatInputToolsView {
    func buildView() {
        
        let cellNib = UINib(nibName: "MaoChatInputToolsCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "MaoChatInputToolsCollectionViewCell")
//        collectionView.register(MaoChatInputToolsCollectionViewCell.self, forCellWithReuseIdentifier: "MaoChatInputToolsCollectionViewCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
        addSubview(collectionView)
        addSubview(pageControl)
//        self.updateLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView <<- [
            Top(0).anchor(self.topAnchor),
            Left(0).anchor(self.leftAnchor),
            Bottom(0).anchor(self.bottomAnchor),
            Right(0).anchor(self.rightAnchor),
        ]
        
        pageControl <<- [
            CenterX(0).anchor(self.centerXAnchor),
            Bottom(-10).anchor(self.bottomAnchor)
        ]
    }
}


extension MaoChatInputToolsView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.toolsArray.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaoChatInputToolsCollectionViewCell", for: indexPath) as! MaoChatInputToolsCollectionViewCell
        cell.items = self.toolsArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}
