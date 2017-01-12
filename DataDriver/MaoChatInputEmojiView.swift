//
//  MaoChatInputEmojiView.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class MaoChatInputEmojiView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    lazy var minimumLineSpacing = (MaoChatEnum.UISCREEN.WIDTH - 280) / 5
    
    lazy var layout: MaoChatCollectionViewFlowLayout = {
        let layout = MaoChatCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 70, height: 85)
        layout.minimumLineSpacing = self.minimumLineSpacing
        layout.minimumInteritemSpacing = 10
        layout.delegate = self
        return layout
    }()
    
    lazy var collectionView:UICollectionView = {
        let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        //        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0)
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delaysContentTouches = false
        return collectionView
    }()
    
    lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.tintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        return pageControl
    }()
    
    /// 生成表情列表
    private(set) lazy var emojis: [String] = {
        let emoji = { (x:UInt32) -> String in
            // 生成数字
            var idx = ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)
            // 生成字符串.
            return withUnsafePointer(to: &idx) {
                return NSString(bytes: $0, length: MemoryLayout<(UInt32)>.size, encoding: String.Encoding.utf8.rawValue) as! String
            }
        }
        var rs = [String]()
        for i:UInt32 in 0x1F600 ..< 0x1F64F {
            if i < 0x1F641 || i > 0x1F644 {
                rs.append(emoji(i))
            }
        }
        for i:UInt32 in 0x1F680 ..< 0x1F6A4 {
            rs.append(emoji(i))
        }
        for i:UInt32 in 0x1F6A5 ..< 0x1F6C5 {
            rs.append(emoji(i))
        }
        return rs
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
}

extension MaoChatInputEmojiView {
    func buildView() {
        
        let cellNib = UINib(nibName: "MaoChatInputToolsCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "MaoChatInputToolsCollectionViewCell")
        addSubview(collectionView)
        addSubview(pageControl)
        
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = (collectionView.numberOfItems(inSection: 0) + 21 - 1) / 21
        pageControl.hidesForSinglePage = true
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
            Bottom(0).anchor(self.bottomAnchor),
            Width(100),
            Height(20)
        ]
        
        //        self.collectionView.contentSize = CGSize(width: MaoChatEnum.UISCREEN.WIDTH * 4, height: 199)
    }
}

extension MaoChatInputEmojiView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MaoChatCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cellCenteredAt indexPath: IndexPath, page: Int) {
        
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaoChatInputToolsCollectionViewCell", for: indexPath) as! MaoChatInputToolsCollectionViewCell
        return cell
    }
}
