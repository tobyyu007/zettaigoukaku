//
//  ViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/1.
//  Copyright © 2020 Toby. All rights reserved.
//  Main usage: 登入視窗 view controller
//  Reference to NMSSH: https://github.com/NMSSH/NMSSH
//

import Cocoa
import SwiftUI
import NMSSH

class LoginViewController: NSViewController {

    @IBOutlet weak var accountTextField: NSTextField!
    @IBOutlet weak var passwordField: NSTextField!
    
    @IBAction func loginButton(_ sender: Any) {
        // 跳轉到主視窗
        performSegue(withIdentifier: "LoginToMain", sender: self)
        self.view.window?.close()  // 關閉 login 視窗
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("account.txt")
        
        
        connectToServer()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func connectToServer()
    {
        let session = NMSSHSession(host: "theyus.asuscomm.com:2003", andUsername: "project")
        session.connect()
        if session.isConnected == true{
            session.authenticate(byPassword: "ZDbkDtJo^rUK")
            if session.isAuthorized == true {
                print("connected to SFTP")
            }
        }
    }
}
