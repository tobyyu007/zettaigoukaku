//
//  AddzettaigoukakuViewController.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/7/4.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: "單字"頁面右鍵 menu 選單控制
//

import Cocoa

class MenuAddzettaigoukakuViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var kanaTextField: NSTextField!
    @IBOutlet weak var sentenceTextField: NSTextField!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var japaneseDescriptionTextField: NSTextField!
    @IBOutlet weak var chineseDescriptionTextField: NSTextField!
    @IBOutlet weak var volcabularyTextField: NSTextField!
    @IBOutlet weak var sentence_chineseTextField: NSTextField!
    @IBOutlet weak var levelMenu: NSPopUpButton!
    @IBOutlet weak var pageTextField: NSTextField!
    @IBOutlet weak var StarCheckBox: NSButton!
    @IBOutlet weak var stepper: NSStepper!
    
    @IBOutlet weak var button: NSButton!
    
    static var kana = ""
    static var sentence = ""
    static var type = ""
    static var japaneseDescription = ""
    static var chineseDescription = ""
    static var volcabulary = ""
    static var sentence_chinese = ""
    static var page = 1
    static var level = "N5"
    static var star = true
    
    static var selectedIndex = -1  // tableView 選擇的列號碼
    
    static var editing = false  // 編輯中
    static var adding = false  // 新增中
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        stepper.integerValue = MenuAddzettaigoukakuViewController.page // 1
        pageTextField.delegate = self // 連動 controlTextDidChange Function
        if MenuAddzettaigoukakuViewController.selectedIndex != -1  // 有選擇欄位，修改中
        {
            kanaTextField.stringValue = MenuAddzettaigoukakuViewController.kana
            sentenceTextField.stringValue = MenuAddzettaigoukakuViewController.sentence
            typeTextField.stringValue = MenuAddzettaigoukakuViewController.type
            japaneseDescriptionTextField.stringValue = MenuAddzettaigoukakuViewController.japaneseDescription
            chineseDescriptionTextField.stringValue = MenuAddzettaigoukakuViewController.chineseDescription
            volcabularyTextField.stringValue = MenuAddzettaigoukakuViewController.volcabulary
            sentence_chineseTextField.stringValue = MenuAddzettaigoukakuViewController.sentence_chinese
            pageTextField.stringValue = String(MenuAddzettaigoukakuViewController.page)
            
            switch MenuAddzettaigoukakuViewController.level{
            case "N5":
                levelMenu.selectItem(at: 0)
            case "N4":
                levelMenu.selectItem(at: 1)
            case "N3":
                levelMenu.selectItem(at: 2)
            case "N2":
                levelMenu.selectItem(at: 3)
            case "N1":
                levelMenu.selectItem(at: 4)
            default:
                break
            }
            
            if MenuAddzettaigoukakuViewController.star == true
            {
                StarCheckBox.state = .on
            }
            else
            {
                StarCheckBox.state = .off
            }
            button.title = "修改"
        }
        else // 新增中
        {
            kanaTextField.stringValue = ""
            sentenceTextField.stringValue = ""
            typeTextField.stringValue = ""
            japaneseDescriptionTextField.stringValue = ""
            chineseDescriptionTextField.stringValue = ""
            volcabularyTextField.stringValue = ""
            sentence_chineseTextField.stringValue = ""
            pageTextField.stringValue = "1"
            button.title = "新增"
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        // 監測頁數 textField 改動，連動更動 stepper 數值
        let textField = obj.object as! NSTextField
        let pageValue = Int(textField.stringValue) ?? 0
        if pageValue == 0  || pageValue > 1000 // 不是 輸入數值 或 超過範圍 (1~1000)，改動回原本的數字
        {
            
            if MenuAddzettaigoukakuViewController.selectedIndex != -1 // 有選擇欄位，修改中
            {
                AddzettaigoukakuErrorViewController.errorTitle = "editing"
            }
            else // 新增中
            {
                AddzettaigoukakuErrorViewController.errorTitle = "adding"
            }
            AddzettaigoukakuErrorViewController.errorContent = "pageError"
            performSegue(withIdentifier: "MenuAddzettaigoukakuError", sender: self) // 跳轉到警告畫面
            textField.stringValue = String(stepper.integerValue)
        }
        else // 正常數字範圍
        {
            stepper.integerValue = Int(textField.stringValue)!
        }
    }
    
    @IBAction func stepperChange(_ sender: NSStepper) {
        // Stepper 改動
        MenuAddzettaigoukakuViewController.page = sender.integerValue
        pageTextField.stringValue = String(sender.integerValue)
    }
    
    @IBAction func editOrAddButton(_ sender: Any)  // 新增或編輯按鈕
    {
        let kana = kanaTextField.stringValue
        let sentence = sentenceTextField.stringValue
        let type = typeTextField.stringValue
        let japaneseDescription = japaneseDescriptionTextField.stringValue
        let chineseDescription = chineseDescriptionTextField.stringValue
        let volcabulary = volcabularyTextField.stringValue
        let sentence_chinese = sentence_chineseTextField.stringValue
        let page = Int(pageTextField.stringValue) ?? 0
        var level = "N5"
        
        switch levelMenu.indexOfSelectedItem {
        case 0:
            level = "N5"
        case 1:
            level = "N4"
        case 2:
            level = "N3"
        case 3:
            level = "N2"
        case 4:
            level = "N1"
        default:
            break
        }
        
        var star = true
        if StarCheckBox.state == .on
        {
            star = true
        }
        else
        {
            star = false
        }
        
        // 所有欄位都有輸入資料
        if kana != "" && sentence != "" && type != "" && japaneseDescription != "" && chineseDescription != "" && volcabulary != "" && sentence_chinese != "" && page != 0
        {
            MenuAddzettaigoukakuViewController.kana = kana
            MenuAddzettaigoukakuViewController.sentence = sentence
            MenuAddzettaigoukakuViewController.type = type
            MenuAddzettaigoukakuViewController.japaneseDescription = japaneseDescription
            MenuAddzettaigoukakuViewController.chineseDescription = chineseDescription
            MenuAddzettaigoukakuViewController.volcabulary = volcabulary
            MenuAddzettaigoukakuViewController.sentence_chinese = sentence_chinese
            MenuAddzettaigoukakuViewController.page = page
            MenuAddzettaigoukakuViewController.level = level
            MenuAddzettaigoukakuViewController.star = star
            
            if MenuAddzettaigoukakuViewController.selectedIndex != -1  // 有選擇欄位，修改中
            {
                MenuAddzettaigoukakuViewController.editing = true
                self.dismiss(MenuAddzettaigoukakuViewController.self)
            }
            else // 新增中
            {
                if !FunctionsViewController.isDuplicate(newzettaigoukaku: MenuAddzettaigoukakuViewController.volcabulary)
                {
                    MenuAddzettaigoukakuViewController.adding = true
                    self.dismiss(MenuAddzettaigoukakuViewController.self)
                }
                else // 該單字是重複的
                {
                    AddzettaigoukakuErrorViewController.errorTitle = "adding"
                    AddzettaigoukakuErrorViewController.errorContent = "duplicates"
                    performSegue(withIdentifier: "MenuAddzettaigoukakuError", sender: self) // 跳轉到警告畫面
                }
            }
        }
        else  // 有欄位沒有輸入資料
        {
            if MenuAddzettaigoukakuViewController.selectedIndex != -1 // 有選擇欄位，修改中
            {
                AddzettaigoukakuErrorViewController.errorTitle = "editing"
            }
            else // 新增中
            {
                AddzettaigoukakuErrorViewController.errorTitle = "adding"
            }
            AddzettaigoukakuErrorViewController.errorContent = "noData"
            performSegue(withIdentifier: "MenuAddzettaigoukakuError", sender: self) // 跳轉到警告畫面
        }
    }
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        // "取消" 按鍵
        self.dismiss(MenuAddzettaigoukakuViewController.self)
    }
}
