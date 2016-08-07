//
//  EmoticonItem.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/4.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    // MARK: **** 属性 ****
    var id: String?
    lazy var emoticons: [EmoticonItem] = [EmoticonItem]()
    
    
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

// MARK: **** 最近这组 添加表情 ****
extension EmoticonPackage {
    
    // 最近  第一组添加表情
    func addEmoticon(emoticon: EmoticonItem) {
        // 先移除删除按钮
        self.emoticons.removeAtIndex(20)
        // 判断是否已经包含该表情
        let isContain = self.emoticons.contains(emoticon)
        if  !isContain {
            self.emoticons.append(emoticon)
        }
        // 数组中模型根据某一条件排序 生成新的数组
        let sortEmoArray = self.emoticons.sort { (e1, e2) -> Bool in
            return e1.count >= e2.count
        }
        self.emoticons = sortEmoArray
        
        // 添加删除按钮
        let deleEmo = EmoticonItem()
        deleEmo.png = "compose_emotion_delete"
        self.emoticons.insert(deleEmo, atIndex: 20)
        
        // 超过20 的 (空白)表情删除 , 永远只保留21个表情
        for i in 21..<self.emoticons.count {
            self.emoticons.removeAtIndex(i)
        }

    }
    
    
}
