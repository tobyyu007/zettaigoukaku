//
//  ViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/1.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference of function list: https://github.com/KinematicSystems/NSOutlineViewReorder
//  Reference of first focus: https://stackoverflow.com/questions/31867098/how-to-set-focus-to-an-nsbutton
//  Reference of NSTextField options: http://webcache.googleusercontent.com/search?q=cache:Wmv3AL8rVC0J:https://www.jianshu.com/p/795a2b9f60aa&client=safari&hl=zh-TW&gl=tw&strip=1&vwsrc=0

import Cocoa

class FunctionList: NSViewController{
    
    @IBOutlet weak var theOutline: NSOutlineView!
    @IBOutlet weak var searchBar: NSTextField!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var functionListView: NSView!
    
    var folderImage = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericFolderIcon)))
    var itemImage = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon)))
    var vocabularyImage = NSImage(named: "NSBookmarksTemplate")
    var addvocabularyImage = NSImage(named: "NSAddTemplate")
    var testImage = NSImage(named: "NSTouchBarComposeTemplate")
    
    var testData = TestData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //addData()
        vocabularyImage?.size = NSSize(width: 25, height: 25)
        addvocabularyImage?.size = NSSize(width: 17, height: 17)
        testImage?.size = NSSize(width: 25, height: 25)
        let indexSet = NSIndexSet(index: 0)
        theOutline.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        searchBar.bezelStyle = NSTextField.BezelStyle.roundedBezel;
        //searchBar.focusRingType = NSFocusRingType.none
        scrollView.becomeFirstResponder()
    }
    
    // Assign functionListView to be the first responder
    override func viewDidAppear() {
        self.view.window?.makeFirstResponder(functionListView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if let function = theOutline.item(atRow: theOutline.selectedRow) as? TestItem {
            // If the selected item is a Color object then pass it to the color details
            // view and show it.
            if function.name == "單字"
            {
                FunctionsViewController.FunctionChoice = "VolcabularyView"
            }
            else if function.name == "新增單字"
            {
                FunctionsViewController.FunctionChoice = "AddVolcabularyView"
            }
            else if function.name == "測驗"
            {
                FunctionsViewController.FunctionChoice = "TestView"
            }
        }
        else
        {
            FunctionsViewController.FunctionChoice = "VolcabularyView"
        }
    }
}
