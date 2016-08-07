//
//  EmoticonTool.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/4.
//  Copyright © 2016年 Howie. All rights reserved.
//  处理表情模型数据的工具类

import UIKit

class EmoticonTool: NSObject {
    
    // 加载emotions.plist
    static var packageDict:[String: AnyObject]? = {
        guard let path = NSBundle(path: path!)!.pathForResource("emoticons.plist", ofType: nil) else  {
            return nil
        }
        guard let dict =  NSDictionary(contentsOfFile: path) else {
            return nil
        }
        return dict as? [String: AnyObject]
    }()
    
    // 表情bundle的路径， 表情的基础路径
    static var path = {
        return  NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)
    }()
    
 
    
}

// MARK: **** 初始化表情模型 ****
extension EmoticonTool {
    /// 表情模型数组
    class func getDefaultEmoticon() -> [EmoticonPackage]? {
        guard let dict = packageDict else {
            return nil
        }
        var emoticonArray = [EmoticonPackage]()
        
        // ----------- 1、 最近这组的数据 ---------
        // 最近第一组的数据 ，固定21个，最后一个是删除按钮
        var tmp = [EmoticonItem]()
        for _ in 0..<20 {
            let emo = EmoticonItem()
            tmp.append(emo)
        }
        // 最后一个删除按钮
        let deleteEmo = EmoticonItem()
        deleteEmo.png = "compose_emotion_delete"
        tmp.append(deleteEmo)
        let emoPackage = EmoticonPackage()
        emoPackage.emoticons = tmp
        emoticonArray.append(emoPackage)
        
        // ----------- 2、 其他组的数据 ---------
        for dic in dict["packages"] as! [[String: AnyObject]] {
            
            let emoticonPackage = EmoticonPackage(dict: dic)
            let emojiPath = path! + "/" + emoticonPackage.id! + "/info.plist"
            guard let emojiDict = NSDictionary(contentsOfFile: emojiPath) else {
                return nil
            }
            // 每20个表情 插入一个删除的按钮, 并且补空白表情
            var model = [EmoticonItem]()
            var index = 0
            for tmp in emojiDict["emoticons"] as! [[String: AnyObject]] {
                if  index == 20 {
                    let emo =  EmoticonItem()
                    emo.png = "compose_emotion_delete"
                    model.append(emo)
                    index = 0
                } else {
                    let emoticonItem = EmoticonItem(dict: tmp)
                    emoticonItem.id = emoticonPackage.id
                    index += 1
                    model.append(emoticonItem)
                }
            }
            
            // 补空白
            let count = model.count % 21
            for _ in count..<20 {
                let blankEmo =  EmoticonItem()
                model.append(blankEmo)
                
            }
            // 最后补 删除按钮
            let deleteEmo =  EmoticonItem()
            deleteEmo.png = "compose_emotion_delete"
            model.append(deleteEmo)
            
            
            
            
            emoticonPackage.emoticons = model
            emoticonArray.append(emoticonPackage)
        }
        
        return emoticonArray
        
    }
}

// MARK: **** 根据表情文字找到对应的表情模型 ****
extension EmoticonTool {
    /**
     根据表情文字找到对应的表情模型
     :param: str 表情文字
     :returns: 表情模型
     */
    class func emoticonWithStr(str: String) -> EmoticonItem?
    {
        var emoticon: EmoticonItem?
        for package in getDefaultEmoticon()!
        {
            // filter ,找数组中模型，条件是模型的某个属性等于某个值
            emoticon = package.emoticons.filter({ (emo) -> Bool in
                return emo.chs == str
            }).last
            if  emoticon != nil {
                break
            }
//            emoticon = package.emoticons.filter({ (e) -> Bool in
//                return e.chs == str
//            }).last
//            
//            if emoticon != nil {
//                break
//            }
        }
        return emoticon
    }
}


