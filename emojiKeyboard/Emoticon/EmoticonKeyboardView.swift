//
//  EmoticonKeyboardView.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/4.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

protocol EmoticonKeyboardViewDelegate:class {
    /// 点击了表情
    func emoticonKeyboardViewClick(emoticon: EmoticonItem)
    /// 点击了删除按钮
    func emoticonKeyboardViewDelete()
}

// 键盘输入的view
class EmoticonKeyboardView: UIView {
    
    // 代理
    weak var delegate: EmoticonKeyboardViewDelegate?
    
    @IBOutlet weak var emoticonView: UICollectionView!
   
    
    lazy var emoticonArray = EmoticonTool.getDefaultEmoticon()
    
    let reuseId = "emoticon"
    
    override func awakeFromNib() {
        emoticonView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: reuseId)
        emoticonView.backgroundColor = UIColor.lightGrayColor()
        emoticonView.dataSource = self
        emoticonView.delegate = self
    }
    
    
    @IBAction func buttonClick(sender: UIBarButtonItem) {
        
        let indexPath = NSIndexPath(forItem: 0, inSection: sender.tag - 1)
        emoticonView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
    }
    
    /// 从xib 加载view
    class func  loadFromXib() -> EmoticonKeyboardView {
        return NSBundle.mainBundle().loadNibNamed(String(self), owner: nil, options: nil).last as! EmoticonKeyboardView
    }
    
    
    
}

extension EmoticonKeyboardView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emoticonArray?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return emoticonArray?[section].emoticons.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! EmoticonCell

        cell.emoticon = emoticonArray![indexPath.section].emoticons[indexPath.item]
        return cell 
    }
    
}

extension EmoticonKeyboardView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 获得 表情模型
        let emoticon = emoticonArray![indexPath.section].emoticons[indexPath.item]

        if emoticon.png == "compose_emotion_delete" {
            // 点击删除按钮
            guard let delegate = delegate else {
                return
            }
            delegate.emoticonKeyboardViewDelete()
            print("点击删除按钮")
            return
        }
        // pngPath和code 是空的话退出
        if emoticon.pngPath == nil && emoticon.code == nil {
            return
        }
        
        emoticon.count += 1
        // 设置最近
        let emoPackage = emoticonArray![0]
        emoPackage.addEmoticon(emoticon)
        // 传递表情到外界
        guard let delegate = delegate else {
            return
        }
        delegate.emoticonKeyboardViewClick(emoticon)
        // 手动刷新第一组
        collectionView.reloadSections(NSIndexSet(index: 0))
        
        
    }
    
}