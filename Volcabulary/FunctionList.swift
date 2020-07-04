//
//  ViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/1.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference of function list: https://github.com/KinematicSystems/NSOutlineViewReorder

import Cocoa

class FunctionList: NSViewController{
    
    @IBOutlet weak var theOutline: NSOutlineView!
    @IBOutlet weak var searchBar: NSTextField!

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
        searchBar.focusRingType = NSFocusRingType.none
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
