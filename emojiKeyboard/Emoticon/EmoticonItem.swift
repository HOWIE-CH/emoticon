//
//  EmojiItem.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/4.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

class EmoticonItem: NSObject {
    /// 文件夹名
    var id: String? {
        didSet {
            guard let pn = png else {
                return
            }
            guard let iD = id else {
                return
            }
            pngPath = iD  + "/" + pn
        }
    }
    /// emoji
    var code: String? {
        didSet {
            guard let codeStr = code else {
                return
            }
            let scanner = NSScanner(string: codeStr)
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            let ch = Character(UnicodeScalar(result))
            emojiCode = "\(ch)"
        }
    }
    var emojiCode: String?
    /// 文字
    var chs: String?
    /// 图片
    var png: String?
    /// 使用次数
    var count: Int = 0
    /// 图片路径
    var pngPath: String?
    
    
    // MARK: **** kvc ****
    override init() {
        
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
