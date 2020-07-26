//
//  LoginErrorViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/26.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: 當登入資訊有問題時，顯示錯誤視窗
//

import Cocoa

class LoginErrorViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(Any?.self)
    }
    
}
