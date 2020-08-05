//
//  learnError.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/7/27.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa

class learnError: NSViewController {

    @IBOutlet weak var errorTitle: NSTextField!
    @IBOutlet weak var errorDescription: NSTextField!
    
    static var errorTitleText = ""
    static var errorDescriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        switch learnError.errorTitleText{
        case "error":
            errorTitle.stringValue = "錯誤"
        default:
            errorTitle.stringValue = "錯誤"
        }
        
        switch learnError.errorDescriptionText {
        case "noData":
            errorDescription.stringValue = "請在有選擇的欄位中輸入資料"
        case "pageError":
            errorDescription.stringValue = "頁數請輸入 1~1000 頁"
        case "noSelection":
            errorDescription.stringValue = "請至少選擇一個欄位"
        case "noResult":
            errorDescription.stringValue = "搜尋不到符合的項目"
        case "rangeError":
            errorDescription.stringValue = "頁數範圍錯誤，結束比開始小"
        default:
            errorDescription.stringValue = "錯誤"
        }
    }
    
    @IBAction func okButton(_ sender: Any) {
        // 關閉警告視窗
        self.dismiss(learnError.self)
    }
}
