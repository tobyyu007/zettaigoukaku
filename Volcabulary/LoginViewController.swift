//
//  ViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/1.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa
import SwiftUI

class LoginViewController: NSViewController {

    @IBAction func loginButton(_ sender: Any) {
        // 跳轉到主視窗
        performSegue(withIdentifier: "LoginToMain", sender: self)
        self.view.window?.close()  // 關閉 login 視窗
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}
