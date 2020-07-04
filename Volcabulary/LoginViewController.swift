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
        performSegue(withIdentifier: "LoginToMain", sender: self)
        self.view.window?.close()
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
