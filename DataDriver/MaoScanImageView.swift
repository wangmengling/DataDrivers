//
//  MaoScanImageView.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

private let maoScanImage = MaoScanImage()
class MaoScanImage {
    class var shared: MaoScanImage {
        return maoScanImage
    }
    
    lazy var maoScanImageView: MaoScanImageView = {
        let maoScanImageView = MaoScanImageView(frame: .zero)
        return maoScanImageView
    }()
    
    var keyWindow:UIWindow!
    
    init() {
        keyWindow = UIApplication.shared.keyWindow
        self.buildCollectionView()
    }
    
    func buildCollectionView() {
        keyWindow?.addSubview(maoScanImageView)
        maoScanImageView <<- [
            Top().anchor(self.keyWindow.topAnchor),
            Left().anchor(self.keyWindow.leftAnchor),
            Bottom().anchor(self.keyWindow.bottomAnchor),
            Right().anchor(self.keyWindow.rightAnchor),
        ]
    }
    
    
    func scanImageView(_ image: UIImage) {
        self.maoScanImageView.buildCollectionView()
        self.maoScanImageView.currentImage = image
        
        maoScanImageView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.maoScanImageView.alpha = 1
        }
    }
    
    func scanArrayImageView(_ arrayImage: [UIImage]) {
        self.maoScanImageView.buildCollectionView()
        self.maoScanImageView.imageArray = arrayImage
        maoScanImageView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.maoScanImageView.alpha = 1
        }
    }
    
}


private let maoScanImageView = MaoScanImageView()
class MaoScanImageView: UIView {
    var currentSelectIndex = 0
    
    var currentImage: UIImage {
        get{
            return imageArrayB[currentSelectIndex]
        }set{
            imageArray.append(newValue)
        }
    }
    
    fileprivate var imageArrayB: [UIImage] = []
    
    var imageArray: [UIImage] {
        get{
            return self.imageArrayB
        }set{
            self.imageArrayB = newValue
            self.collectionView.reloadData()
        }
    }
    
    
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//        layout.estimatedItemSize = CGSize(width: 70, height: 85)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
//        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
//        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.lightGray
        return collectionView
    }()
    
    
    class var shared: MaoScanImageView {
        return maoScanImageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.buildCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.buildCollectionView()
        
    }
    
    
    
    func buildCollectionView() {
        collectionView.register(MaoScanImageCollectionViewCell.self, forCellWithReuseIdentifier: "MaoScanImageCollectionViewCell")
        addSubview(collectionView)
        collectionView <<- [
            Top().anchor(self.topAnchor),
            Left().anchor(self.leftAnchor),
            Bottom().anchor(self.bottomAnchor),
            Right().anchor(self.rightAnchor)
        ]
    }
}

extension MaoScanImageView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.imageArrayB.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaoScanImageCollectionViewCell", for: indexPath) as! MaoScanImageCollectionViewCell
        let image = self.imageArrayB[indexPath.row]
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.alpha = 0
        self.imageArrayB = []
//        self.removeFromSuperview()
    }
}

class MaoScanImageCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView <<- [
            Top().anchor(self.topAnchor),
            Left().anchor(self.leftAnchor),
            Bottom().anchor(self.bottomAnchor),
            Right().anchor(self.rightAnchor)
        ]
    }
}
