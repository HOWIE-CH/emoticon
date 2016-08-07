//
//  TextAttachmet.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/7.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

class TextAttachment: NSTextAttachment {
    /// 图片表情对应的字符
    var chs: String?

    /// 生成表情图片的属性字符串
    class func createAttachmetn(emo: EmoticonItem, height: CGFloat) -> NSAttributedString? {
        let attachment = TextAttachment()
        guard let pngPath = emo.pngPath else {
            return nil
        }
        
        let path = EmoticonTool.path! + "/" + pngPath
        attachment.chs = emo.chs
        attachment.image = UIImage(contentsOfFile: path)
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        return NSAttributedString(attachment: attachment)
    }
    
    
}
