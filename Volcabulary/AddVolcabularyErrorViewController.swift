//
//  AddVolcabularyErrorViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/4.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa

class AddVolcabularyErrorViewController: NSViewController {

    @IBOutlet var errorView: NSView!
    @IBOutlet weak var errorImage: NSImageView!
    @IBOutlet weak var errorTitle: NSTextField!
    @IBOutlet weak var errorDescription: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 調整警告圖片
        let errorNSImage = NSImage(named: "NSCaution")
        errorNSImage?.size = NSSize(width: 45, height: 45)
        errorImage.image = errorNSImage
        
        
        if MenuAddVolcabularyViewController.selectedIndex != -1 // 修改中
        {
            errorTitle.stringValue = "無法修改單字"
        }
        else // 新增中
        {
            errorTitle.stringValue = "無法新增單字"
        }
        
        if MenuAddVolcabularyViewController.errorType == "noData"
        {
            errorDescription.stringValue = "請輸入所有資料"
        }
        else
        {
            errorDescription.stringValue = "頁數請輸入 1~1000 頁"
        }
    }
    @IBAction func DismissTabView(sender: NSButton)
    {
        // 關閉警告視窗
        self.dismiss(AddVolcabularyErrorViewController.self)
    }
    
}
