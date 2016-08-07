//
//  ViewController.swift
//  emojiKeyboard
//
//  Created by HOWIE-CH on 16/8/4.
//  Copyright © 2016年 Howie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: TextView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let str = "@jack12:【动物尖叫合辑】http://www.cnblogs.com/howie-ch/[笑哈哈]#肥猪流#猫头鹰[笑哈哈]这么尖叫尖叫http://xianghus.com/portal.php/猫http://www.cnblogs.com/howie-ch/[偷笑]、@南哥: 老鼠这么尖叫、兔子这么尖叫[吃惊]、@江哥: 莫名奇#小笼包#妙的笑到最后[嘻嘻][挖鼻屎]！~ http://t.cn/zYBuKZ8"
        
        let emoticonKeyboardView = EmoticonKeyboardView.loadFromXib()
        emoticonKeyboardView.delegate = self
        textView.inputView = emoticonKeyboardView
        textView.isNeedInput = true
        textView.text = str
//        textView.editable = true
        textView.setupHighlight()
        textView.recognizeEmoticon()
        
    }

}

extension ViewController: EmoticonKeyboardViewDelegate {
    
    /// 插入表情
    func emoticonKeyboardViewClick(emoticon: EmoticonItem) {
        textView.insertEmoticon(emoticon)
    }
    
    // 删除按钮点击了
    func emoticonKeyboardViewDelete() {
        textView.deleteBackward()
    }
    
}

extension ViewController {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 需要发送的 文本
        print(textView.sendResultText)
    }
}
