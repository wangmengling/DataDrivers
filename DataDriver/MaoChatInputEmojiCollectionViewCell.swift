//
//  MaoChatInputEmojiCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class MaoChatInputEmojiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiImageView: UIImageView!
    
    var items:[String] {
        get{
            return []
        }
        set{
            self.emojiImageView.image = UIImage(named: newValue[0])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
