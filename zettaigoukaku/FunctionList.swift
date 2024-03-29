//
//  ViewController.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/7/1.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: 主畫面左方 function list 總管
//
//  Reference of function list: https://github.com/KinematicSystems/NSOutlineViewReorder
//  Reference of first focus: https://stackoverflow.com/questions/31867098/how-to-set-focus-to-an-nsbutton
//  Reference of NSTextField options: http://webcache.googleusercontent.com/search?q=cache:Wmv3AL8rVC0J:https://www.jianshu.com/p/795a2b9f60aa&client=safari&hl=zh-TW&gl=tw&strip=1&vwsrc=0

import Cocoa

class FunctionList: NSViewController{
    
    @IBOutlet weak var theOutline: NSOutlineView!
    @IBOutlet weak var searchBar: NSTextField!
    @IBOutlet var functionListView: NSView!
    
    // 讀取圖片
    var folderImage = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericFolderIcon)))
    var itemImage = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon)))
    let vocabularyImage = #imageLiteral(resourceName: "單字")
    let addvocabularyImage = #imageLiteral(resourceName: "新增單字")
    let testImage = #imageLiteral(resourceName: "測驗")
    let learnImage = #imageLiteral(resourceName: "學習")
    
    var testData = TestData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 圖片大小調整
        vocabularyImage.size = NSSize(width: 20, height: 20)
        addvocabularyImage.size = NSSize(width: 20, height: 20)
        testImage.size = NSSize(width: 20, height: 20)
        learnImage.size = NSSize(width: 20, height: 20)
        
        // 預設選擇第一個功能 (單字)
        let indexSet = NSIndexSet(index: 0)
        theOutline.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        
        searchBar.bezelStyle = NSTextField.BezelStyle.roundedBezel // 搜尋欄邊框圓化
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
            // 根據功能欄位選擇改變的視窗，連結 FunctionsViewController 連動
            if function.name == "單字"
            {
                FunctionsViewController.FunctionChoice = "zettaigoukakuView"
            }
            else if function.name == "新增單字"
            {
                FunctionsViewController.FunctionChoice = "AddzettaigoukakuView"
            }
            else if function.name == "學習"
            {
                FunctionsViewController.FunctionChoice = "LearnView"
            }
            else if function.name == "測驗"
            {
                FunctionsViewController.FunctionChoice = "TestView"
            }
        }
        else  // 預設視窗
        {
            FunctionsViewController.FunctionChoice = "zettaigoukakuView"
        }
    }
}
