//
//  quizViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/8/1.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa

class quizViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet var quizView: NSView!
    @IBOutlet weak var displayAndQuizItemView: NSView!
    @IBOutlet weak var quizDisplayView: NSView!
    @IBOutlet weak var quizCompleteView: NSView!
    
    var checked = false // 是否有選擇任何一個欄位
    var inputdataError = false // 是否有欄位輸入錯誤
    
    var pageRange = [Int]()
    var japanese = ""
    var kana = ""
    var japaneseDescription = ""
    var chineseDescription = ""
    var type = ""
    var example = ""
    var exampleChinese = ""
    var level = [Int]()
    var star = false
    
    var searchResults = [searchResult]() // 搜尋結果
    
    var searchSelected = [Bool]() // 該搜尋方式有被選擇
    var searchMethod = [Bool]() // 順序跟上面 SearchMethod 一樣，false: 包含, true: 完全相同
    var displayItem = [Bool]() // 順序跟上面 TextField 一樣，false: 不顯示, true: 顯示
    
    let userDefault = UserDefaults()
    var todayLearnedVolcabularyCount = 0 // 今天學習的單字數量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizView.isHidden = false
        displayAndQuizItemView.isHidden = true
        quizDisplayView.isHidden = true
        quizCompleteView.isHidden = true
        pageFromTextField.delegate = self
        pageToTextField.delegate = self
        pageFromStepper.integerValue = 1
        pageToStepper.integerValue = 1
        
        // 顯示項目和測驗項目邊框設定
        displayItemView.wantsLayer = true
        displayItemView.layer?.masksToBounds = true
        displayItemView.layer?.borderWidth = 0.5
        displayItemView.layer?.cornerRadius = 10
        displayItemView.layer?.borderColor = NSColor.gray.cgColor
        quizItemView.wantsLayer = true
        quizItemView.layer?.masksToBounds = true
        quizItemView.layer?.borderWidth = 0.5
        quizItemView.layer?.cornerRadius = 10
        quizItemView.layer?.borderColor = NSColor.gray.cgColor
    }
    
    // MARK: 範圍頁面
    @IBOutlet weak var pageCheckBox: NSButton!
    @IBOutlet weak var japaneseCheckBox: NSButton!
    @IBOutlet weak var kanaCheckBox: NSButton!
    @IBOutlet weak var japaneseDefinitionCheckBox: NSButton!
    @IBOutlet weak var chineseDefinitionCheckBox: NSButton!
    @IBOutlet weak var typeCheckBox: NSButton!
    @IBOutlet weak var exampleCheckBox: NSButton!
    @IBOutlet weak var exampleChineseCheckBox: NSButton!
    @IBOutlet weak var levelCheckBox: NSButton!
    @IBOutlet weak var starCheckBox: NSButton!
    
    @IBOutlet weak var pageFromTextField: NSTextField!
    @IBOutlet weak var pageFromStepper: NSStepper!
    @IBOutlet weak var pageToTextField: NSTextField!
    @IBOutlet weak var pageToStepper: NSStepper!
    @IBOutlet weak var japaneseTextField: NSTextField!
    @IBOutlet weak var kanaTextField: NSTextField!
    @IBOutlet weak var japaneseDescriptionTextField: NSTextField!
    @IBOutlet weak var chineseDescriptionTextField: NSTextField!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var exampleTextField: NSTextField!
    @IBOutlet weak var exampleChineseTextField: NSTextField!
    @IBOutlet weak var levelFromMenu: NSPopUpButton!
    @IBOutlet weak var levelToMenu: NSPopUpButton!
    @IBOutlet weak var starMenu: NSPopUpButton!
    
    @IBOutlet weak var japaneseSearchMethod: NSPopUpButton!
    @IBOutlet weak var kanaSearchMethod: NSPopUpButton!
    @IBOutlet weak var japaneseDescriptionSearchMethod: NSPopUpButton!
    @IBOutlet weak var chineseDescriptionSearchMethod: NSPopUpButton!
    @IBOutlet weak var typeSearchMethod: NSPopUpButton!
    @IBOutlet weak var exampleSearchMethod: NSPopUpButton!
    @IBOutlet weak var exampleChineseSearchMethod: NSPopUpButton!
    
    func controlTextDidChange(_ obj: Notification) {
        // 監測 pageToTextField 和 pageFromTextField 更動是否超過範圍
        let textField = obj.object as! NSTextField
        let pageValue = Int(textField.stringValue) ?? 0
        if pageValue == 0  || pageValue > 1000 // 不是 輸入數值 或 超過範圍 (1~1000)，改動回原本的數字
        {
            quizError.errorTitleText = "error"
            quizError.errorDescriptionText = "pageError"
            performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
        }
    }
    
    @IBAction func pageFromTextFieldChange(_ sender: Any) {
        // pageFromeTextField 完成數值輸入，更新 stepper 數值
        pageFromStepper.integerValue = Int(pageFromTextField.stringValue)!
    }
    
    @IBAction func pageToTextFieldChanged(_ sender: Any) {
        // pageToTextField 完成數值輸入，更新 stepper 數值
        pageToTextField.integerValue = Int(pageToTextField.stringValue)!
    }
    
    @IBAction func pageFromStepperClicked(_ sender: NSStepper) {
        // pageFromStepper 更動
        pageFromTextField.stringValue = String(sender.integerValue)
    }
    
    @IBAction func pageToStepperClicked(_ sender: NSStepper) {
        // pageToStepper 更動
        pageToTextField.stringValue = String(sender.integerValue)
    }
    
    @IBAction func levelFromMenuClicked(_ sender: Any) {
        // 自動調整 menu 可選擇的級別
        var levelFrom = -1
        switch levelFromMenu.indexOfSelectedItem // 級別從...
        {
        case 0:
            levelFrom = 5 // N5
        case 1:
            levelFrom = 4 // N4
        case 2:
            levelFrom = 3 // N3
        case 3:
            levelFrom = 2 // N2
        case 4:
            levelFrom = 1 // N1
        default:
            print("error")
        }
        
        switch levelFrom // 到...級別
        {
        case 5:
            levelToMenu.item(at: 0)?.isEnabled = true
            levelToMenu.item(at: 1)?.isEnabled = true
            levelToMenu.item(at: 2)?.isEnabled = true
            levelToMenu.item(at: 3)?.isEnabled = true
            levelToMenu.selectItem(at: 0)
        case 4:
            levelToMenu.item(at: 0)?.isEnabled = false
            levelToMenu.item(at: 1)?.isEnabled = true
            levelToMenu.item(at: 2)?.isEnabled = true
            levelToMenu.item(at: 3)?.isEnabled = true
            levelToMenu.selectItem(at: 1)
        case 3:
            levelToMenu.item(at: 0)?.isEnabled = false
            levelToMenu.item(at: 1)?.isEnabled = false
            levelToMenu.item(at: 2)?.isEnabled = true
            levelToMenu.item(at: 3)?.isEnabled = true
            levelToMenu.selectItem(at: 2)
        case 2:
            levelToMenu.item(at: 0)?.isEnabled = false
            levelToMenu.item(at: 1)?.isEnabled = false
            levelToMenu.item(at: 2)?.isEnabled = false
            levelToMenu.item(at: 3)?.isEnabled = true
            levelToMenu.selectItem(at: 3)
        case 1:
            levelToMenu.item(at: 0)?.isEnabled = false
            levelToMenu.item(at: 1)?.isEnabled = false
            levelToMenu.item(at: 2)?.isEnabled = false
            levelToMenu.item(at: 3)?.isEnabled = false
            levelToMenu.selectItem(at: 4)
        default:
            print("error")
        }
    }
    
    @IBAction func quizViewNextButton(_ sender: Any) {
        // 下一步按鍵
        if pageCheckBox.state == .on // 頁數
        {
            checked = true
            searchSelected.append(true)
            if pageFromTextField.stringValue != ""
            {
                if Int(pageFromTextField.stringValue)! <= Int(pageToTextField.stringValue)!
                {
                    searchMethod.append(true)
                    pageRange.append(Int(pageFromTextField.stringValue)!)
                    pageRange.append(Int(pageToTextField.stringValue)!)
                }
                else // 範圍錯誤
                {
                    inputdataError = true // 欄位數值有問題
                    quizError.errorTitleText = "error"
                    quizError.errorDescriptionText = "rangeError"
                    performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if japaneseCheckBox.state == .on // 日文
        {
            checked = true
            searchSelected.append(true)
            if japaneseTextField.stringValue != ""
            {
                japanese = japaneseTextField.stringValue
                if japaneseSearchMethod.indexOfSelectedItem == 0 // 包含
                {
                    searchMethod.append(false)
                }
                else if japaneseSearchMethod.indexOfSelectedItem == 1 // 完全相同
                {
                    searchMethod.append(true)
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if kanaCheckBox.state == .on // 假名
        {
            checked = true
            searchSelected.append(true)
            if kanaTextField.stringValue != ""
            {
                kana = kanaTextField.stringValue
                if kanaSearchMethod.indexOfSelectedItem == 0 // 包含
                {
                    searchMethod.append(false)
                }
                else if kanaSearchMethod.indexOfSelectedItem == 1 // 完全相同
                {
                    searchMethod.append(true)
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if japaneseDefinitionCheckBox.state == .on // 日文解釋
        {
            checked = true
            searchSelected.append(true)
            if japaneseDescriptionTextField.stringValue != ""
            {
                japaneseDescription = japaneseDescriptionTextField.stringValue
                if japaneseDescriptionSearchMethod.indexOfSelectedItem == 0 // 包含
                {
                    searchMethod.append(false)
                }
                else if japaneseDescriptionSearchMethod.indexOfSelectedItem == 1 // 完全相同
                {
                    searchMethod.append(true)
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if chineseDefinitionCheckBox.state == .on // 中文解釋
        {
            checked = true
            searchSelected.append(true)
            if chineseDescriptionTextField.stringValue != ""
            {
                chineseDescription = chineseDescriptionTextField.stringValue
                if chineseDescriptionSearchMethod.indexOfSelectedItem == 0 // 包含
                {
                    searchMethod.append(false)
                }
                else if chineseDescriptionSearchMethod.indexOfSelectedItem == 1 // 完全相同
                {
                    searchMethod.append(true)
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if typeCheckBox.state == .on // 類型
        {
            checked = true
            searchSelected.append(true)
            if typeTextField.stringValue != ""
            {
                type = typeTextField.stringValue
                if typeSearchMethod.indexOfSelectedItem == 0 // 包含
                {
                    searchMethod.append(false)
                }
                else if typeSearchMethod.indexOfSelectedItem == 1 // 完全相同
                {
                    searchMethod.append(true)
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if exampleCheckBox.state == .on // 日文例句
        {
            checked = true
            searchSelected.append(true)
            if exampleTextField.stringValue != ""
            {
                example = exampleTextField.stringValue
                if exampleSearchMethod.indexOfSelectedItem == 0 // 包含
                {
                    searchMethod.append(false)
                }
                else if exampleSearchMethod.indexOfSelectedItem == 1 // 完全相同
                {
                    searchMethod.append(true)
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if exampleChineseCheckBox.state == .on // 中文例句
        {
            checked = true
            searchSelected.append(true)
            if exampleChineseTextField.stringValue != ""
            {
                exampleChinese = exampleChineseTextField.stringValue
                if exampleChineseSearchMethod.indexOfSelectedItem == 0 // 包含
                {
                    searchMethod.append(false)
                }
                else if exampleChineseSearchMethod.indexOfSelectedItem == 1 // 完全相同
                {
                    searchMethod.append(true)
                }
            }
            else // 沒有輸入值
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if levelCheckBox.state == .on // 等級
        {
            checked = true
            searchSelected.append(true)
            if levelFromMenu.indexOfSelectedItem <= levelToMenu.indexOfSelectedItem
            {
                searchMethod.append(true)
                switch levelFromMenu.indexOfSelectedItem {
                case 0:
                    level.append(5)
                case 1:
                    level.append(4)
                case 2:
                    level.append(3)
                case 3:
                    level.append(2)
                case 4:
                    level.append(1)
                default:
                    inputdataError = true // 欄位數值有問題
                    quizError.errorTitleText = "error"
                    quizError.errorDescriptionText = "noData"
                    performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
                }
                switch levelToMenu.indexOfSelectedItem {
                case 0:
                    level.append(5)
                case 1:
                    level.append(4)
                case 2:
                    level.append(3)
                case 3:
                    level.append(2)
                case 4:
                    level.append(1)
                default:
                    inputdataError = true // 欄位數值有問題
                    quizError.errorTitleText = "error"
                    quizError.errorDescriptionText = "noData"
                    performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
                }
            }
            else // 範圍錯誤
            {
                inputdataError = true // 欄位數值有問題
                quizError.errorTitleText = "error"
                quizError.errorDescriptionText = "rangeError"
                performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if starCheckBox.state == .on // 標記
        {
            checked = true
            searchSelected.append(true)
            searchMethod.append(true)
            switch starMenu.indexOfSelectedItem {
            case 0:
                star = true
            case 1:
                star = false
            default:
                star = false
            }
        }
        else // 沒有選擇該項目
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if checked == false // 沒有選擇任何一個欄位
        {
            quizError.errorTitleText = "error"
            quizError.errorDescriptionText = "noSelection"
            performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
        }
        else if !inputdataError// 有選擇欄位，並且沒有欄位輸入問題，往下一個頁面前進
        {
            quizView.isHidden = true
            displayAndQuizItemView.isHidden = false
            quizDisplayView.isHidden = true
            quizCompleteView.isHidden = true
            search() // quizSearch.swift
            print("搜尋結果是：")
            for word in searchResults
            {
                print(word.volcabulary)
            }
        }
        else if inputdataError // 有欄位沒有輸入，重設搜尋資料
        {
            searchMethod.removeAll()
            searchSelected.removeAll()
            checked = false
            inputdataError = false
        }
        inputdataError = false
    }
    
    // MARK: 範圍頁面
    @IBOutlet weak var displayItemView: NSView!
    @IBOutlet weak var quizItemView: NSView!
    
}
