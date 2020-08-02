//
//  quizError.swift
//  Volcabulary
//
//  Created by Toby on 2020/8/1.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa

class quizError: NSViewController {

    @IBOutlet weak var errorTitle: NSTextField!
    @IBOutlet weak var errorDescription: NSTextField!
    
    static var errorTitleText = ""
    static var errorDescriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        switch quizError.errorTitleText{
        case "error":
            errorTitle.stringValue = "錯誤"
        default:
            errorTitle.stringValue = "錯誤"
        }
        
        switch quizError.errorDescriptionText {
        case "noData":
            errorDescription.stringValue = "請在有選擇的欄位中輸入資料"
        case "pageError":
            errorDescription.stringValue = "頁數請輸入 1~1000 頁"
        case "noSelection":
            errorDescription.stringValue = "請至少選擇一個欄位"
        case "rangeError":
            errorDescription.stringValue = "頁數範圍錯誤，結束比開始小"
        case "selectionExceed":
            errorDescription.stringValue = "選擇超過規定的項目(顯示5個，測驗4個)"
        default:
            errorDescription.stringValue = "錯誤"
        }
    }
    
    @IBAction func okButton(_ sender: Any) {
        // 關閉警告視窗
        self.dismiss(quizError.self)
    }
}
