//
//  AddVolcabularyViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/4.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa

class MenuAddVolcabularyViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var kanaTextField: NSTextField!
    @IBOutlet weak var sentenceTextField: NSTextField!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var chineseTextField: NSTextField!
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
    static var chinese = ""
    static var volcabulary = ""
    static var sentence_chinese = ""
    static var page = 1
    static var level = "N5"
    static var star = true
    
    static var errorType = "noData"
    
    static var selectedIndex = -1  // tableView 選擇的列號碼
    
    static var editing = false  // 編輯中
    static var adding = false  // 新增中
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        stepper.integerValue = MenuAddVolcabularyViewController.page // 1
        pageTextField.delegate = self // 連動 controlTextDidChange Function
        if MenuAddVolcabularyViewController.selectedIndex != -1  // 有選擇欄位，修改中
        {
            kanaTextField.stringValue = MenuAddVolcabularyViewController.kana
            sentenceTextField.stringValue = MenuAddVolcabularyViewController.sentence
            typeTextField.stringValue = MenuAddVolcabularyViewController.type
            chineseTextField.stringValue = MenuAddVolcabularyViewController.chinese
            volcabularyTextField.stringValue = MenuAddVolcabularyViewController.volcabulary
            sentence_chineseTextField.stringValue = MenuAddVolcabularyViewController.sentence_chinese
            pageTextField.stringValue = String(MenuAddVolcabularyViewController.page)
            
            switch MenuAddVolcabularyViewController.level{
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
            
            if StarCheckBox.state == .on
            {
                MenuAddVolcabularyViewController.star = true
            }
            else
            {
                MenuAddVolcabularyViewController.star = false
            }
            
            button.title = "修改"
        }
        else // 新增中
        {
            button.title = "新增"
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        // 監測頁數 textField 改動，連動更動 stepper 數值
        let textField = obj.object as! NSTextField
        let pageValue = Int(textField.stringValue) ?? 0
        if pageValue == 0  || pageValue > 1000 // 不是 輸入數值 或 超過範圍 (1~1000)，改動回原本的數字
        {
            MenuAddVolcabularyViewController.errorType = "pageValue"
            performSegue(withIdentifier: "MenuAddVolcabularyError", sender: self) // 跳轉到警告畫面
            textField.stringValue = String(stepper.integerValue)
        }
        else
        {
            stepper.integerValue = Int(textField.stringValue)!
        }
    }
    
    @IBAction func stepperChange(_ sender: NSStepper) {
        // Stepper 改動
        MenuAddVolcabularyViewController.page = sender.integerValue
        pageTextField.stringValue = String(sender.integerValue)
    }
    
    @IBAction func editOrAddButton(_ sender: Any)  // 新增或編輯按鈕
    {
        let kana = kanaTextField.stringValue
        let sentence = sentenceTextField.stringValue
        let type = typeTextField.stringValue
        let chinese = chineseTextField.stringValue
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
        if kana != "" && sentence != "" && type != "" && chinese != "" && volcabulary != "" && sentence_chinese != "" && page != 0
        {
            MenuAddVolcabularyViewController.kana = kana
            MenuAddVolcabularyViewController.sentence = sentence
            MenuAddVolcabularyViewController.type = type
            MenuAddVolcabularyViewController.chinese = chinese
            MenuAddVolcabularyViewController.volcabulary = volcabulary
            MenuAddVolcabularyViewController.sentence_chinese = sentence_chinese
            MenuAddVolcabularyViewController.page = page
            MenuAddVolcabularyViewController.level = level
            MenuAddVolcabularyViewController.star = star
            
            if MenuAddVolcabularyViewController.selectedIndex != -1  // 有選擇欄位，修改中
            {
                MenuAddVolcabularyViewController.editing = true
            }
            else // 新增中
            {
                MenuAddVolcabularyViewController.adding = true
            }
            
            self.dismiss(MenuAddVolcabularyViewController.self)
        }
        else  // 有欄位沒有輸入資料
        {
            MenuAddVolcabularyViewController.errorType = "noData"
            performSegue(withIdentifier: "MenuAddVolcabularyError", sender: self) // 跳轉到警告畫面
        }
    }
    
}
