//
//  MaoChatInputToolsCollectionViewCell.swift
//  DataDriver
//
//  Created by jackWang on 2017/1/10.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class MaoChatInputToolsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var toolImageView: UIImageView!
    
    @IBOutlet weak var toolNameLabel: UILabel!
    
    var items:[String] {
        get{
            return []
        }
        set{
            self.toolNameLabel.text = newValue[1]
            self.toolImageView.image = UIImage(named: newValue[0])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
