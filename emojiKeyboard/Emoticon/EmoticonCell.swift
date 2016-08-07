//
//  EmoticonCell.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/4.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
    
    
    lazy var emoticonButton: UIButton = {
        let btn = UIButton(type: .Custom)
        btn.userInteractionEnabled = false
        btn.backgroundColor = UIColor.whiteColor()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        return btn
    }()
    
    var emoticon: EmoticonItem? {
        didSet {
            
            guard let emo = emoticon else {
                emoticonButton.setTitle(nil, forState: .Normal)
                emoticonButton.setImage(nil, forState: .Normal)
                return
            }

            // emoji
            if emo.code != nil {
                emoticonButton.setTitle(emo.emojiCode, forState: .Normal)
                emoticonButton.setImage(nil, forState: .Normal)
            } else if emo.png != nil && emo.chs != nil {
                guard let pngPath = emo.pngPath else {
                    return
                }
                let imagePath = EmoticonTool.path! + "/" + pngPath
                let image = UIImage(contentsOfFile: imagePath)
                emoticonButton.setImage(image, forState: .Normal)
                emoticonButton.setTitle(nil, forState: .Normal)
            } else if emo.png != nil && emo.chs == nil  {
                let image = UIImage(named: emo.png!)
                emoticonButton.setImage(image, forState: .Normal)
                emoticonButton.setTitle(nil, forState: .Normal)
                
            } else {
                emoticonButton.setTitle(nil, forState: .Normal)
                emoticonButton.setImage(nil, forState: .Normal)
            }

        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGrayColor()
        contentView.addSubview(emoticonButton)
        emoticonButton.frame = CGRectInset(self.bounds, 5, 5)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
