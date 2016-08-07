//
//  TextView.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/7.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

// MARK: **** 初始化 ****
class TextView: UITextView {
    /// 是否需要 输入文字
    var isNeedInput: Bool = false {
        didSet {
            
            if isNeedInput {
                self.editable = true
                self.endEditing(true)
            } else {
                self.editable = false
                self.endEditing(false)
            }

            
        }
    }
    /// 最终需要发送的文字
    var sendResultText: String {
        var strM = String()
        // 需要发送给服务器的数据
        // enumerateAttributesInRange 遍历 属性字符串
        attributedText.enumerateAttributesInRange( NSMakeRange(0, attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (objc, range, _) -> Void in
            
            if objc["NSAttachment"] != nil
            {
                // 图片
                let attachment =  objc["NSAttachment"] as! TextAttachment
                strM += attachment.chs!
            }else
            {
                // 文字
                strM += (self.text as NSString).substringWithRange(range)
            }
        }
        return strM
    }
    

    
    
}
// MARK: **** 识别、匹配表情 ****
extension UITextView {
     func recognizeEmoticon() {
        // 表情符号的 range
        let pattern = "\\[\\w+\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0)) else {
            return
        }
        let result = regex.matchesInString(self.text, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.text.characters.count))
        // textView里面最开始的文字
        let strM = NSMutableAttributedString(attributedString: self.attributedText)
        // 记录textView 光标位置
        let cursorRange = self.selectedRange
        // 要从后往前遍历 寻找表情文字
        for temp in result.reverse()  {
            let resultStr = (self.text as NSString).substringWithRange(temp.range)
            guard let emo = EmoticonTool.emoticonWithStr(resultStr) else {
                continue
            }
            
            guard let attachStr = TextAttachment.createAttachmetn(emo, height: self.font!.lineHeight) else {
                return
            }
            // 生成总的属性字符串， 替换range位置 为  表情图片的属性字符串
            
            strM.replaceCharactersInRange(temp.range, withAttributedString: attachStr)
        }
        
        self.attributedText = strM
        self.selectedRange = cursorRange
        
    }
}

// MARK: **** 高亮显示特殊字符 ****
extension TextView {
    
    func setupHighlight() {
        // 高亮显示
        let pattern1 = "#\\w+#"
        let pattern2 = "@\\w+:"
        let pattern3 = "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]?"
        let pattern4 = "\\[\\w+\\]"
        let pattern = pattern1 + "|" + pattern2 + "|" + pattern3 + "|" + pattern4
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0)) else {
            return
        }
        let resultArray = regex.matchesInString(self.text, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.text.characters.count))
        // textView里面最开始的文字
        let strM = NSMutableAttributedString(attributedString: self.attributedText)
        for temp in resultArray {
            // 拿到range
            strM.setAttributes([NSForegroundColorAttributeName: UIColor.redColor(),
                NSFontAttributeName: self.font!], range: temp.range)
        }
        self.attributedText = strM

    }
}
// MARK: **** 监听特殊字符的点击 ****
extension TextView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 获取点
        guard let touch = (touches as NSSet).anyObject() as? UITouch else {
            return
        }
        let point = touch.locationInView(self)
        
        //
        let pattern1 = "#\\w+#"
        let pattern2 = "@\\w+:"
        let pattern3 = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
        let pattern4 = "\\[\\w+\\]"
        let pattern = pattern1 + "|" + pattern2 + "|" + pattern3 + "|" + pattern4
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0)) else {
            return
        }
        let resultArray = regex.matchesInString(text, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: text.characters.count))
        for temp in resultArray {
            // 拿到range
            selectedRange = temp.range
            let array =  self.selectionRectsForRange(selectedTextRange!)
            for tmp in array {
                
                if CGRectContainsPoint(tmp.rect, point)  {
                    // 点在 范围里 (tmp.rect frame)
                    // 加入想做的事情 

                    print( (text as NSString).substringWithRange(temp.range))
                    
                }
            }
            // 最后取消选中的range ，设置 range 只是来转换为 rect frame
            self.selectedRange = NSRange(location: 0, length: 0)
        }
    }

}


// MARK: **** 插入表情 ****
extension TextView {
    /// 插入表情
    func insertEmoticon(emoticon: EmoticonItem) {
        // 1、emoji表情
        if  emoticon.code != nil && emoticon.emojiCode != nil   {
            // 获取光标的range
            
            guard let selectRange = self.selectedTextRange else {
                self.selectedRange = NSRange(location: 0, length: 0)
                self.replaceRange(self.selectedTextRange!, withText: emoticon.emojiCode!)
                return
            }
            self.replaceRange(selectRange, withText: emoticon.emojiCode!)
            return
        }
        // 2、图片表情
        // 获取当前的显示的内容 生成一个属性字符串
        let strM = NSMutableAttributedString(attributedString: self.attributedText)
        
        
        // strM 里 替换
        // textView 光标位置
        let range = self.selectedRange
        
        // 把图片 变成属性字符串 ，并设置 attachment 的高度, 设置图片表情的bounds，没有frame
        guard let attrStr = TextAttachment.createAttachmetn(emoticon, height: self.font!.lineHeight) else {
            return
        }
        strM.replaceCharactersInRange(range, withAttributedString: attrStr)
        // 设置 光标位置下一个的 strM 的字体大小为 textView的字体大小
        // 解决插入第一个表情图片大小合适，第二个以后的所有表情都比较小的问题
        strM.addAttribute(NSFontAttributeName, value: self.font! , range: NSMakeRange(range.location, 1))
        // 设置 textView 的属性文本
        self.attributedText = strM
        // 还原textView 的光标位置
        // 解决插入表情后光标始终在最后面而不是在当前位置
        self.selectedRange = NSRange(location: range.location + 1 , length: range.length)
    }
    
}

// --------------------------------------------------------------------------------------  //

// 识别url的另外的方法， 参考
extension TextView {
    // 用 系统的NSDataDetector ，系统默认有的正则表达式去识别
    func  recognizeUrl(point: CGPoint) {
        // url 识别 (能点击)
        guard let detector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue) else {
            return
        }
        let resultArray = detector.matchesInString(self.text, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.text.characters.count))
        for temp in resultArray {
            // 只要设置selectedRange, 那么就相当于设置了selectedTextRange
            self.selectedRange = temp.range
            // 将range 转换成 rect
            let selectArray = self.selectionRectsForRange(self.selectedTextRange!)
            for selectTemp  in selectArray {
                
                let resultStr = (self.text as NSString).substringWithRange(temp.range)
                if  CGRectContainsPoint(selectTemp.rect, point) {
                    
                    print("========\(resultStr)==========")
                    
                }
            }
        }

    }
}
