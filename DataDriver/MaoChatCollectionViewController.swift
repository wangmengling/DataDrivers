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
        layout.estimatedItemSize = CGSize(width: self.view.bounds.size.width, height: 50)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.white
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
    
    lazy var contentModelArray = Array<MaoChatContentModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildView()
        self.getChatArray()
        
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
        return self.contentModelArray.count
    }
    
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let contentModel = self.contentModelArray[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaoChatBaseCollectionViewCellStyle.styleOfChatType( contentModel.contentType,contentModel.isMe), for: indexPath) as! MaoChatBaseCollectionViewCell
        cell.contentModel = contentModel
        return cell
    }
    
}

extension MaoChatCollectionViewController {
    func buildView() {
        
        self.view.addSubview(collectionView)
        self.view.addSubview(maoChatInputTextFieldView)
        
        
        
        maoChatInputTextFieldView <<- [
            Height(>=44),
            Height(<=350),
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
        
        
        self.collectionView.register(MaoChatLabelLeftCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.labelLeft.description)
        self.collectionView.register(MaoChatLabelRightCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.labelRight.description)
        self.collectionView.register(MaoChatImageLeftCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.imageLeft.description)
        self.collectionView.register(MaoChatImageRightCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.imageRight.description)
        self.collectionView.register(MaoChatVoiceLeftCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.voiceLeft.description)
        self.collectionView.register(MaoChatVoiceRightCollectionViewCell.self, forCellWithReuseIdentifier: MaoChatBaseCollectionViewCellStyle.voiceRight.description)
    }
    
    func getChatArray() {
        var userModel = MaoChatUserModel()
        userModel.headImage = "MessageNotice"
        userModel.name = "王国仲"
        userModel.userId = 10000
        
        var freindUserModel = MaoChatUserModel()
        freindUserModel.headImage = "MessageHeadUserIcon"
        freindUserModel.name = "张燕"
        freindUserModel.userId = 10001
        
        var maochatContentModel = MaoChatContentModel()
        maochatContentModel.content = "我要上头条,怎么办，哦多尅，帮帮我！可以么！我要上头条,怎么办，哦多尅，帮帮我！可以么！我要上头条,怎么办，哦多尅，帮帮我！可以么！我要上头条,怎么办，哦多尅，帮帮我！可以么！我要上头条,怎么办，哦多尅，帮帮我！可以么！我要上头条,怎么办，哦多尅，帮帮我！可以么！"
        maochatContentModel.contentType = .label
        maochatContentModel.isMe = .True
        maochatContentModel.userModel = userModel
//        maochatContentModel.reciveTime = 
        
        var fmaochatContentModel = MaoChatContentModel()
        fmaochatContentModel.content = "你上啊"
        fmaochatContentModel.contentType = .label
        fmaochatContentModel.isMe = .False
        fmaochatContentModel.userModel = freindUserModel
        
        var imageContentModel  = MaoChatContentModel()
        imageContentModel.content = "comment"
        imageContentModel.contentType = .image
        imageContentModel.isMe = .True
        imageContentModel.userModel = userModel
        
        var fimageContentModel  = MaoChatContentModel()
        fimageContentModel.content = "space"
        fimageContentModel.contentType = .image
        fimageContentModel.isMe = .True
        fimageContentModel.userModel = userModel
        
        var dimageContentModel  = MaoChatContentModel()
        dimageContentModel.content = "desktop"
        dimageContentModel.contentType = .image
        dimageContentModel.isMe = .True
        dimageContentModel.userModel = userModel
        
        var cimageContentModel  = MaoChatContentModel()
        cimageContentModel.content = "ceshi1"
        cimageContentModel.contentType = .image
        cimageContentModel.isMe = .True
        cimageContentModel.userModel = userModel
        
        var voicecontentModel = MaoChatContentModel()
        voicecontentModel.content = "ceshi1"
        voicecontentModel.contentType = .voice
        voicecontentModel.isMe = .False
        voicecontentModel.userModel = userModel
        
        var mvoicecontentModel = MaoChatContentModel()
        mvoicecontentModel.content = "ceshi1"
        mvoicecontentModel.contentType = .voice
        mvoicecontentModel.isMe = .True
        mvoicecontentModel.userModel = userModel
        
        self.contentModelArray = [
            maochatContentModel,
            fmaochatContentModel,
            imageContentModel,
            fimageContentModel,
            dimageContentModel,
            cimageContentModel,
            voicecontentModel,
            mvoicecontentModel
        ]
        
        self.collectionView.reloadData()
        
    }
    
    
}
