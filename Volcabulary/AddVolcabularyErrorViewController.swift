//
//  AddVolcabularyErrorViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/4.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: 新增單字錯誤 view controller
//

import Cocoa

class AddVolcabularyErrorViewController: NSViewController {

    @IBOutlet var errorView: NSView!
    @IBOutlet weak var errorImage: NSImageView!
    @IBOutlet weak var errorTitle: NSTextField!
    @IBOutlet weak var errorDescription: NSTextField!
    
    static var errorTitle = ""
    static var errorContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 調整警告圖片
        let errorNSImage = NSImage(named: "NSCaution")
        errorNSImage?.size = NSSize(width: 45, height: 45)
        errorImage.image = errorNSImage
        
        switch AddVolcabularyErrorViewController.errorTitle {
        case "adding":
            errorTitle.stringValue = "無法新增單字"
        case "duplicates":
            errorTitle.stringValue = "無法新增單字"
        case "editing":
            errorTitle.stringValue = "無法修改單字"
        default:
            print("errorTitle error")
        }
        
        switch AddVolcabularyErrorViewController.errorContent {
        case "noData":
            errorDescription.stringValue = "請輸入所有資料"
        case "pageError":
            errorDescription.stringValue = "頁數請輸入 1~1000 頁"
        case "duplicates":
            errorDescription.stringValue = "此單字已經新增"
        default:
            print("errorContent error")
        }
    }
    @IBAction func DismissTabView(sender: NSButton)
    {
        // 關閉警告視窗
        self.dismiss(AddVolcabularyErrorViewController.self)
    }
    
}
