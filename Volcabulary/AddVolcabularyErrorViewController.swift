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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func DismissTabView(sender: NSButton)
    {
        // 關閉警告視窗
        self.dismiss(AddVolcabularyErrorViewController.self)
    }
    
}
