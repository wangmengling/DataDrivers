//
//  MaoChatCollectionViewController.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MaoChatCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
//        collectionView.backgroundColor = UIColor.blue
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var maoChatInputTextFieldView: MaoChatInputTextFieldView = {
        let maoChatInputTextFieldView = MaoChatInputTextFieldView(frame: .zero)
//        maoChatInputTextFieldView.backgroundColor = UIColor.red
        return maoChatInputTextFieldView
    }()
    
    lazy var maoChatCollectionViewModel: MaoChatCollectionViewModel = {
        let maoChatCollectionViewModel = MaoChatCollectionViewModel()
        return maoChatCollectionViewModel
    }()
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.green
        return backView
    }()
    
    lazy var chatArray = Array<MaoUserModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let userModel = self.chatArray[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (MaoChatBaseCollectionViewCellStyle(rawValue: userModel.contentType.rawValue)?.rawValue)!, for: indexPath)
        
        return cell
    }
}

extension MaoChatCollectionViewController {
    func buildView() {
        
        self.view.addSubview(collectionView)
        self.view.addSubview(maoChatInputTextFieldView)
        
        
        
        maoChatInputTextFieldView <<- [
            Height(44),
            Bottom().anchor(self.view.bottomAnchor),
            Left().anchor(self.view.leftAnchor),
            Right().anchor(self.view.rightAnchor)
        ]
        
        collectionView <<- [
            Bottom().anchor(self.maoChatInputTextFieldView.topAnchor),
            Left().anchor(self.view.leftAnchor),
            Right().anchor(self.view.rightAnchor),
            Top().anchor(self.view.topAnchor)
        ]
        
        
        self.collectionView.register(MaoChatLabelCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.label.description)
        self.collectionView.register(MaoChatImageCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.image.description)
        self.collectionView.register(MaoChatLabelCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.voice.description)
        
//        maoChatCollectionViewModel.style
        
    }
}
