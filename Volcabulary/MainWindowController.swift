//
//  MainWindowController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/2.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference to WindowsController visual control: https://lukakerr.github.io/swift/nswindow-styles


import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // 各種視窗視覺 tweak
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.styleMask.insert(.fullSizeContentView)
    }
    
    
}
