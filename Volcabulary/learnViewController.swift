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
    @IBOutlet weak var learnCompleteView: NSView!
    
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
    
    var searchResults = [searchResult]() // 搜尋結果
    
    var searchSelected = [Bool]() // 該搜尋方式有被選擇
    var searchMethod = [Bool]() // 順序跟上面 SearchMethod 一樣，false: 包含, true: 完全相同
    var displayItem = [Bool]() // 順序跟上面 TextField 一樣，false: 不顯示, true: 顯示
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        learnView.isHidden = false
        displayItemView.isHidden = true
        volcabularyDisplayView.isHidden = true
        learnCompleteView.isHidden = true
    }
    
    func resetAllData() // 重設所有設定
    {
        starImageName = "filled"
        currentVolcabularyIndex = 0
        nextVocabularyButton.title = "下一個"
        previousVocabularyButton.isEnabled = false
        
        learnView.isHidden = false
        displayItemView.isHidden = true
        volcabularyDisplayView.isHidden = true
        learnCompleteView.isHidden = true
        
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
        levelToMenu.item(at: 0)?.isEnabled = true
        levelToMenu.item(at: 1)?.isEnabled = true
        levelToMenu.item(at: 2)?.isEnabled = true
        levelToMenu.item(at: 3)?.isEnabled = true
        
        displayChecked = false
        
        displayPageCheckBox.state = .on
        displayJapaneseCheckBox.state = .on
        displayKanaCheckBox.state = .on
        displayJapaneseDefinitionCheckBox.state = .on
        displayChineseDefinitionCheckBox.state = .on
        displayTypeCheckBox.state = .on
        displayExampleCheckBox.state = .on
        displayChineseExampleCheckBox.state = .on
        displayLevelCheckBox.state = .on
        displayStarCheckBox.state = .on
    }
    
    // MARK: 範圍頁面
    @IBAction func levelFromMenuClicked(_ sender: Any) {
        // 自動調整可選擇的等級
        var levelFrom = -1
        switch levelFromMenu.indexOfSelectedItem // 從...
        {
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
        
        switch levelFrom // 到...
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
            learnCompleteView.isHidden = true
            search()
            print("searchResult is")
            for word in searchResults
            {
                print(word.volcabulary)
            }
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

    @IBOutlet weak var chineseDefinitionLabel: NSTextField!
    @IBOutlet weak var chineseExampleLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var japaneseDefinitionLabel: NSTextField!
    @IBOutlet weak var exampleLabel: NSTextField!
    @IBOutlet weak var levelLabel: NSTextField!
    
    var displayChecked = false
    
    @IBAction func displayNextButton(_ sender: Any) {
        // 下一步按鍵
        if displayPageCheckBox.state == .on // 頁面
        {
            displayChecked = true
            pageDisplay.isHidden = false
            pageDisplay.stringValue = "P" + String(searchResults[0].page)
        }
        if displayJapaneseCheckBox.state == .on // 日文
        {
            displayChecked = true
            volcabularyDisplay.isHidden = false
            volcabularyDisplay.stringValue = searchResults[0].volcabulary
        }
        if displayKanaCheckBox.state == .on // 假名
        {
            displayChecked = true
            kanaDisplay.isHidden = false
            kanaDisplay.stringValue = searchResults[0].kana
        }
        if displayJapaneseDefinitionCheckBox.state == .on // 日文解釋
        {
            displayChecked = true
            japaneseDefinitionLabel.isHidden = false
            japaneseDefinitionDisplay.isHidden = false
            japaneseDefinitionDisplay.stringValue = searchResults[0].japaneseDefinition
        }
        if displayChineseDefinitionCheckBox.state == .on // 中文解釋
        {
            displayChecked = true
            chineseDefinitionDisplay.isHidden = false
            chineseDefinitionLabel.isHidden = false
            chineseDefinitionDisplay.stringValue = searchResults[0].chineseDefinition
        }
        if displayTypeCheckBox.state == .on // 類型
        {
            displayChecked = true
            typeDisplay.isHidden = false
            typeLabel.isHidden = false
            typeDisplay.stringValue = searchResults[0].type
        }
        if displayExampleCheckBox.state == .on // 日文例句
        {
            displayChecked = true
            japaneseExampleDisplay.isHidden = false
            exampleLabel.isHidden = false
            japaneseExampleDisplay.stringValue = searchResults[0].sentence
        }
        if displayChineseExampleCheckBox.state == .on // 中文例句
        {
            displayChecked = true
            chineseExampleDisplay.isHidden = false
            chineseExampleLabel.isHidden = false
            chineseExampleDisplay.stringValue = searchResults[0].sentence_chinese
        }
        if displayLevelCheckBox.state == .on // 等級
        {
            displayChecked = true
            levelDisplay.isHidden = false
            levelLabel.isHidden = false
            levelDisplay.stringValue = searchResults[0].level
        }
        if displayStarCheckBox.state == .on // 標記
        {
            displayChecked = true
            starButtonDisplay.isHidden = false
            let starImageFilled = #imageLiteral(resourceName: "starFill")
            let starImageEmpty = #imageLiteral(resourceName: "starEmpty")
            if searchResults[0].star
            {
                starButtonDisplay.image = starImageFilled
            }
            else
            {
                starButtonDisplay.image = starImageEmpty
            }
        }
        
        if !displayChecked // 沒有選擇任何一個選項
        {
            learnError.errorTitleText = "error"
            learnError.errorDescriptionText = "noSelection"
            performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
        }
        else // 有選擇至少一個，往下一個頁面前進
        {
            learnView.isHidden = true
            displayItemView.isHidden = true
            volcabularyDisplayView.isHidden = false
            learnCompleteView.isHidden = true
            if searchResults.count == 1
            {
                nextVocabularyButton.title = "完成"
            }
        }
    }
    
    
    @IBAction func displayCancelButton(_ sender: Any) {
        // 取消按鍵
        resetAllData()
    }
    
    // MARK: 單字顯示
    @IBOutlet weak var pageDisplay: NSTextField!
    @IBOutlet weak var volcabularyDisplay: NSTextField!
    @IBOutlet weak var kanaDisplay: NSTextField!
    @IBOutlet weak var japaneseDefinitionDisplay: NSTextField!
    @IBOutlet weak var japaneseExampleDisplay: NSTextField!
    @IBOutlet weak var levelDisplay: NSTextField!
    @IBOutlet weak var chineseDefinitionDisplay: NSTextField!
    @IBOutlet weak var chineseExampleDisplay: NSTextField!
    @IBOutlet weak var typeDisplay: NSTextField!
    @IBOutlet weak var starButtonDisplay: NSButton!
    @IBOutlet weak var nextVocabularyButton: NSButton!
    @IBOutlet weak var previousVocabularyButton: NSButton!
    
    
    var starImageName = "filled" // 現在標記星星的狀態
    var currentVolcabularyIndex = 0 // 現在顯示的單字索引
    let starImageFilled = #imageLiteral(resourceName: "starFill")
    let starImageEmpty = #imageLiteral(resourceName: "starEmpty")
    
    @IBAction func nextVocabularyButtonClicked(_ sender: Any) // 下一個單字按鈕
    {
        if nextVocabularyButton.title == "完成"
        {
            learnView.isHidden = true
            displayItemView.isHidden = true
            volcabularyDisplayView.isHidden = true
            learnCompleteView.isHidden = false
        }
        else // 顯示下一個
        {
            currentVolcabularyIndex += 1
            previousVocabularyButton.isEnabled = true
            pageDisplay.stringValue = "P" + String(searchResults[currentVolcabularyIndex].page)
            volcabularyDisplay.stringValue = searchResults[currentVolcabularyIndex].volcabulary
            kanaDisplay.stringValue = searchResults[currentVolcabularyIndex].kana
            japaneseDefinitionDisplay.stringValue = searchResults[currentVolcabularyIndex].japaneseDefinition
            chineseDefinitionDisplay.stringValue = searchResults[currentVolcabularyIndex].chineseDefinition
            typeDisplay.stringValue = searchResults[currentVolcabularyIndex].type
            japaneseExampleDisplay.stringValue = searchResults[currentVolcabularyIndex].sentence
            chineseExampleDisplay.stringValue = searchResults[currentVolcabularyIndex].sentence_chinese
            levelDisplay.stringValue = searchResults[currentVolcabularyIndex].level
            
            if searchResults[currentVolcabularyIndex].star
            {
                starButtonDisplay.image = starImageFilled
                starImageName = "filled"
            }
            else
            {
                starButtonDisplay.image = starImageEmpty
                starImageName = "empty"
            }
            
            if currentVolcabularyIndex+1 > searchResults.count-1 // 最後一個單字
            {
                nextVocabularyButton.title = "完成"
            }
        }
    }
    
    @IBAction func previousVocabularyButtonClicked(_ sender: Any) // 上一個單字按鈕
    {
        currentVolcabularyIndex -= 1
        nextVocabularyButton.title = "下一個"
        pageDisplay.stringValue = "P" + String(searchResults[currentVolcabularyIndex].page)
        volcabularyDisplay.stringValue = searchResults[currentVolcabularyIndex].volcabulary
        kanaDisplay.stringValue = searchResults[currentVolcabularyIndex].kana
        japaneseDefinitionDisplay.stringValue = searchResults[currentVolcabularyIndex].japaneseDefinition
        chineseDefinitionDisplay.stringValue = searchResults[currentVolcabularyIndex].chineseDefinition
        typeDisplay.stringValue = searchResults[currentVolcabularyIndex].type
        japaneseExampleDisplay.stringValue = searchResults[currentVolcabularyIndex].sentence
        chineseExampleDisplay.stringValue = searchResults[currentVolcabularyIndex].sentence_chinese
        levelDisplay.stringValue = searchResults[currentVolcabularyIndex].level
        
        if searchResults[currentVolcabularyIndex].star
        {
            starButtonDisplay.image = starImageFilled
            starImageName = "filled"
        }
        else
        {
            starButtonDisplay.image = starImageEmpty
            starImageName = "empty"
        }
        
        if currentVolcabularyIndex == 0 // 第一個單字
        {
            previousVocabularyButton.isEnabled = false
        }
    }
    
    @IBAction func cancelVocabularyButtonClicked(_ sender: Any) // 取消按鈕
    {
        resetAllData()
    }
}
