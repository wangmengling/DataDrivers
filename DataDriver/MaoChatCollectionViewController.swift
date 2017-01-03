//
//  MaoChatCollectionViewController.swift
//  DataDriver
//
//  Created by jackWang on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MaoChatCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.backgroundColor = UIColor.blue
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
<<<<<<< HEAD
    lazy var maoChatInputTextFieldView: MaoChatInputTextFieldView = {
=======
    lazy var maoChatInputTextFieldView:MaoChatInputTextFieldView = {
>>>>>>> origin/master
        let maoChatInputTextFieldView = MaoChatInputTextFieldView()
//        maoChatInputTextFieldView.backgroundColor = UIColor.red
        return maoChatInputTextFieldView
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
        
<<<<<<< HEAD
        
//        self.view.addSubview(collectionView)
=======
        self.view.addSubview(collectionView)
<<<<<<< HEAD
        self.view.addSubview(self.maoChatInputTextFieldView)
=======
>>>>>>> origin/master
        self.view.addSubview(maoChatInputTextFieldView)
        
        maoChatInputTextFieldView <<- [
            Height(40),
            Bottom().anchor(self.view.bottomAnchor),
            Left
        ]
>>>>>>> origin/master
        
        
//        print(maoChatInputTextFieldView.widthAnchor)
        //collectionView register
//        self.collectionView.register(MaoChatLabelCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.label.description)
//        self.collectionView.register(MaoChatImageCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.image.description)
//        self.collectionView.register(MaoChatLabelCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.voice.description)
        
    }
}
