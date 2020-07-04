//
//  AddVolcabularyViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/4.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa

class MenuAddVolcabularyViewController: NSViewController {

    @IBOutlet weak var kanaTextField: NSTextField!
    @IBOutlet weak var sentenceTextField: NSTextField!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var chineseTextField: NSTextField!
    @IBOutlet weak var volcabularyTextField: NSTextField!
    @IBOutlet weak var sentence_chineseTextField: NSTextField!
    
    @IBOutlet weak var button: NSButton!
    
    static var kana = ""
    static var sentence = ""
    static var type = ""
    static var chinese = ""
    static var volcabulary = ""
    static var sentence_chinese = ""
    
    static var selectedIndex = -1  // tableView 選擇的列號碼
    
    static var editing = false  // 編輯中
    static var adding = false  // 新增中
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if MenuAddVolcabularyViewController.selectedIndex != -1  // 有選擇欄位，修改中
        {
            kanaTextField.stringValue = MenuAddVolcabularyViewController.kana
            sentenceTextField.stringValue = MenuAddVolcabularyViewController.sentence
            typeTextField.stringValue = MenuAddVolcabularyViewController.type
            chineseTextField.stringValue = MenuAddVolcabularyViewController.chinese
            volcabularyTextField.stringValue = MenuAddVolcabularyViewController.volcabulary
            sentence_chineseTextField.stringValue = MenuAddVolcabularyViewController.sentence_chinese
            button.title = "修改"
        }
        else // 新增中
        {
            button.title = "新增"
        }
    }
    
    @IBAction func editOrAddButton(_ sender: Any)  // 新增或編輯按鈕
    {
        let kana = kanaTextField.stringValue
        let sentence = sentenceTextField.stringValue
        let type = typeTextField.stringValue
        let chinese = chineseTextField.stringValue
        let volcabulary = volcabularyTextField.stringValue
        let sentence_chinese = sentence_chineseTextField.stringValue
        
        // 所有欄位都有輸入資料
        if kana != "" && sentence != "" && type != "" && chinese != "" && volcabulary != "" && sentence_chinese != ""
        {
            MenuAddVolcabularyViewController.kana = kana
            MenuAddVolcabularyViewController.sentence = sentence
            MenuAddVolcabularyViewController.type = type
            MenuAddVolcabularyViewController.chinese = chinese
            MenuAddVolcabularyViewController.volcabulary = volcabulary
            MenuAddVolcabularyViewController.sentence_chinese = sentence_chinese
            
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
            performSegue(withIdentifier: "MenuAddVolcabularyError", sender: self) // 跳轉到警告畫面
        }
    }
    
}
