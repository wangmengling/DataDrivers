//
//  MaoChatCollectionViewFlowLayout.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

public protocol MaoChatCollectionViewDelegateFlowLayout : UICollectionViewDelegateFlowLayout {
//    - (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page;
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cellCenteredAt indexPath: IndexPath, page: Int)
}

class MaoChatCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    weak open var delegate: MaoChatCollectionViewDelegateFlowLayout?

    
    override func prepare() {
        super.prepare()
    }
    
    override init() {
        super.init()
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.minimumInteritemSpacing = 0.0
        self.sectionInset = UIEdgeInsets.zero
        self.itemSize = CGSize(width: 100, height: 100)
        self.minimumLineSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    
    func shouldInvalidateLayoutForBoundsChange(newBounds:CGRect) -> Bool {
        return true
    }

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var visibleRect:CGRect = CGRect()
        visibleRect.origin = (self.collectionView?.contentOffset)!
        visibleRect.size = (self.collectionView?.bounds.size)!
        attributes?.forEach({ (attribute) in
            if attribute.frame.intersects(rect) {
                if visibleRect.origin.x == 0 {
                    self.delegate?.collectionView(self.collectionView!, layout: self, cellCenteredAt: attribute.indexPath, page: 0)
                }else {
                    let x = div(Int32(visibleRect.origin.x),Int32(visibleRect.size.width))
                    if x.quot > 0 && x.rem > 0 {
                        self.delegate?.collectionView(self.collectionView!, layout: self, cellCenteredAt: attribute.indexPath, page: Int(x.quot) + 1)
                    }else if (x.quot > 0 && x.rem == 0){
                        self.delegate?.collectionView(self.collectionView!, layout: self, cellCenteredAt: attribute.indexPath, page: Int(x.quot))
                    }
                }
            }
        })
        
        return attributes
    }
}
