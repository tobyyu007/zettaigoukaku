//
//  learnViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/23.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa
import WebKit

class searchResult
{
    var star: Bool
    var page: Int
    var volcabulary: String
    var kana: String
    var japaneseDefinition: String
    var chineseDefinition: String
    var type: String
    var sentence: String
    var sentence_chinese: String
    var level: String
    
    init(star: Bool, page: Int, volcabulary: String, kana: String, japaneseDefinition: String, chineseDefinition: String, type: String, sentence: String, sentence_chinese: String, level: String)
    {
        self.star = star
        self.page = page
        self.volcabulary = volcabulary
        self.kana = kana
        self.japaneseDefinition = japaneseDefinition
        self.chineseDefinition = chineseDefinition
        self.type = type
        self.sentence = sentence
        self.sentence_chinese = sentence_chinese
        self.level = level
    }
}

class learnViewController: NSViewController {
    
    @IBOutlet weak var learnView: NSView!
    @IBOutlet weak var displayItemView: NSView!
    @IBOutlet weak var volcabularyDisplayView: NSView!
    
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
    @IBOutlet weak var pageToTextField: NSTextField!
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
    
    var checked = false
    
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
    
    var searchResults = [searchResult]()
    
    var searchSelected = [Bool]() // 該搜尋方式有被選擇
    var searchMethod = [Bool]() // 順序跟上面 SearchMethod 一樣，false: 包含, true: 完全相同
    var displayItem = [Bool]() // 順序跟上面 TextField 一樣，false: 不顯示, true: 顯示
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        learnView.isHidden = false
        displayItemView.isHidden = true
        volcabularyDisplayView.isHidden = true
    }
    
    // MARK: 範圍頁面
    @IBAction func levelFromMenuClicked(_ sender: Any) {
        // 自動調整可選擇的等級
        var levelFrom = -1
        switch levelFromMenu.indexOfSelectedItem {
        case 0:
            levelFrom = 5
        case 1:
            levelFrom = 4
        case 2:
            levelFrom = 3
        case 3:
            levelFrom = 2
        case 4:
            levelFrom = 1
        default:
            print("error")
        }
        
        switch levelFrom{
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
    
    @IBAction func rangeVIewNextButton(_ sender: Any) {
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
                    learnError.errorTitleText = "error"
                    learnError.errorDescriptionText = "rangeError"
                    performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
                }
            }
            else // 沒有輸入值
            {
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "noData"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
                    learnError.errorTitleText = "error"
                    learnError.errorDescriptionText = "noData"
                    performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
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
                    learnError.errorTitleText = "error"
                    learnError.errorDescriptionText = "noData"
                    performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
                }
            }
            else // 範圍錯誤
            {
                learnError.errorTitleText = "error"
                learnError.errorDescriptionText = "rangeError"
                performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
            }
        }
        else
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
        else
        {
            searchSelected.append(false)
            searchMethod.append(false)
        }
        
        if checked == false // 沒有選擇任何一個欄位
        {
            learnError.errorTitleText = "error"
            learnError.errorDescriptionText = "noSelection"
            performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
        }
        else // 有選擇欄位，往下一個頁面前進
        {
            learnView.isHidden = true
            displayItemView.isHidden = false
            volcabularyDisplayView.isHidden = true
            checked = false
            search()
            print("searchResult is")
            for word in searchResults
            {
                print(word.volcabulary)
            }
            
            // 初始化數值
            japaneseTextField.stringValue = ""
            exampleTextField.stringValue = ""
            typeTextField.stringValue = ""
            japaneseDescriptionTextField.stringValue = ""
            chineseDescriptionTextField.stringValue = ""
            kanaTextField.stringValue = ""
            exampleChineseTextField.stringValue = ""
            pageFromTextField.stringValue = "1"
            pageToTextField.stringValue = "1"
            levelToMenu.selectItem(at: 0)
            levelFromMenu.selectItem(at: 0)
            starMenu.selectItem(at: 0)
            japaneseSearchMethod.selectItem(at: 0)
            kanaSearchMethod.selectItem(at: 0)
            japaneseDescriptionSearchMethod.selectItem(at: 0)
            chineseDescriptionSearchMethod.selectItem(at: 0)
            typeSearchMethod.selectItem(at: 0)
            exampleSearchMethod.selectItem(at: 0)
            exampleChineseSearchMethod.selectItem(at: 0)
            pageCheckBox.state = .off
            japaneseCheckBox.state = .off
            kanaCheckBox.state = .off
            japaneseDefinitionCheckBox.state = .off
            chineseDefinitionCheckBox.state = .off
            typeCheckBox.state = .off
            exampleCheckBox.state = .off
            exampleChineseCheckBox.state = .off
            levelCheckBox.state = .off
            starCheckBox.state = .off
        }
    }
    
    
    // MARK: 顯示項目頁面
    @IBOutlet weak var displayPageCheckBox: NSButton!
    @IBOutlet weak var displayJapaneseCheckBox: NSButton!
    @IBOutlet weak var displayKanaCheckBox: NSButton!
    @IBOutlet weak var displayJapaneseDefinitionCheckBox: NSButton!
    @IBOutlet weak var displayChineseDefinitionCheckBox: NSButton!
    @IBOutlet weak var displayTypeCheckBox: NSButton!
    @IBOutlet weak var displayExampleCheckBox: NSButton!
    @IBOutlet weak var displayChineseExampleCheckBox: NSButton!
    @IBOutlet weak var displayLevelCheckBox: NSButton!
    @IBOutlet weak var displayStarCheckBox: NSButton!
    
    var displayChecked = false
    
    @IBAction func displayNextButton(_ sender: Any) {
        // 下一步按鍵
        if displayPageCheckBox.state == .on // 頁面
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayJapaneseCheckBox.state == .on // 日文
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayKanaCheckBox.state == .on // 假名
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayJapaneseDefinitionCheckBox.state == .on // 日文解釋
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayChineseDefinitionCheckBox.state == .on // 中文解釋
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayTypeCheckBox.state == .on // 類型
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayExampleCheckBox.state == .on // 日文例句
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayChineseExampleCheckBox.state == .on // 中文例句
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayLevelCheckBox.state == .on // 等級
        {
            displayChecked = true
            displayItem.append(true)
        }
        if displayStarCheckBox.state == .on // 標記
        {
            displayChecked = true
            displayItem.append(true)
        }
        
        if !displayChecked // 沒有選擇任何一個選項
        {
            learnError.errorTitleText = "error"
            learnError.errorDescriptionText = "noSelection"
            performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
        }
        else // 有選擇至少一個
        {
            displayChecked = false
            learnView.isHidden = true
            displayItemView.isHidden = true
            volcabularyDisplayView.isHidden = false
            
            displayPageCheckBox.state = .off
            displayJapaneseCheckBox.state = .on
            displayKanaCheckBox.state = .on
            displayJapaneseDefinitionCheckBox.state = .on
            displayChineseDefinitionCheckBox.state = .on
            displayTypeCheckBox.state = .on
            displayExampleCheckBox.state = .on
            displayChineseExampleCheckBox.state = .on
            displayLevelCheckBox.state = .on
            displayStarCheckBox.state = .off
        }
    }
    
    
    @IBAction func displayCancelButton(_ sender: Any) {
        // 取消按鍵
        learnView.isHidden = false
        displayItemView.isHidden = true
        volcabularyDisplayView.isHidden = true
        displayChecked = false
        displayItem.removeAll()
        searchResults.removeAll()
        searchMethod.removeAll()
        searchSelected.removeAll()
        pageRange.removeAll()
        level.removeAll()
        japanese = ""
        kana = ""
        japaneseDescription = ""
        chineseDescription = ""
        type = ""
        example = ""
        exampleChinese = ""
        star = false
        checked = false
        
        levelToMenu.item(at: 0)?.isEnabled = true
        levelToMenu.item(at: 1)?.isEnabled = true
        levelToMenu.item(at: 2)?.isEnabled = true
        levelToMenu.item(at: 3)?.isEnabled = true
        
        displayPageCheckBox.state = .off
        displayJapaneseCheckBox.state = .on
        displayKanaCheckBox.state = .on
        displayJapaneseDefinitionCheckBox.state = .on
        displayChineseDefinitionCheckBox.state = .on
        displayTypeCheckBox.state = .on
        displayExampleCheckBox.state = .on
        displayChineseExampleCheckBox.state = .on
        displayLevelCheckBox.state = .on
        displayStarCheckBox.state = .off
    }
    
    // MARK: 單字顯示
    @IBOutlet weak var pageDisplay: NSTextField!
    @IBOutlet weak var volcabularyDisplay: NSTextFieldCell!
    @IBOutlet weak var kanaDisplay: NSTextField!
    @IBOutlet weak var japaneseDefinition: NSTextField!
    @IBOutlet weak var chineseDefinition: NSTextField!
    @IBOutlet weak var typeDisplay: NSTextFieldCell!
    @IBOutlet weak var japaneseExample: NSTextField!
    @IBOutlet weak var chineseExample: NSTextField!
    @IBOutlet weak var levelDisplay: NSTextField!
    
    
}
