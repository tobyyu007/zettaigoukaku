//
//  LoginErrorViewController.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/7/26.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: 當登入資訊有問題時，顯示錯誤視窗
//

import Cocoa

class LoginErrorViewController: NSViewController {

    @IBOutlet weak var errorDescription: NSTextField!
    
    static var errorDescriptionType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        switch LoginErrorViewController.errorDescriptionType {
        case "accountError":
            errorDescription.stringValue = "請檢查帳號密碼"
        case "serverError":
            errorDescription.stringValue = "伺服器連線錯誤"
        default:
            errorDescription.stringValue = "登入錯誤"
        }
    }
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(Any?.self)
    }
    
}
