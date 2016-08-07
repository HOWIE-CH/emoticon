//
//  EmoticonFlowLayout.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/4.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

class EmoticonFlowLayout: UICollectionViewFlowLayout {
    
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let column: CGFloat = 7
        let w = UIScreen.mainScreen().bounds.width / column
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        itemSize = CGSize(width: w, height: w)
        scrollDirection = .Horizontal
        
        // 这里不用0.5 ，0.5不准，只能用0.45
        let margin = ((collectionView?.bounds.height)! - CGFloat(3.0) * w) * 0.45
        let offx: CGFloat = margin > 0 ? margin : 0
        collectionView?.contentInset = UIEdgeInsets(top: offx, left: 0, bottom: offx, right: 0)
        collectionView?.pagingEnabled = true
        
    }
    
}
