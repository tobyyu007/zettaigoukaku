//
//  quizViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/8/1.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference of setting text vertical center in NSTextField: https://stackoverflow.com/a/45995951
//  Reference of underlined border in NSTextField: https://stackoverflow.com/questions/54591013/custom-border-on-nstextfield
//

import Cocoa

class quizViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet var quizView: NSView!
    @IBOutlet weak var displayAndQuizItemView: NSView!
    @IBOutlet weak var quizDisplayView: NSView!
    @IBOutlet weak var quizCompleteView: NSView!
    @IBOutlet weak var wrongVocabularyView: NSView!
    
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
    
    let userDefault = UserDefaults()
    var todayQuizzedVolcabularyCount = 0 // 今天學習的單字數量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizView.isHidden = false
        displayAndQuizItemView.isHidden = true
        quizDisplayView.isHidden = true
        quizCompleteView.isHidden = true
        wrongVocabularyView.isHidden = true
        
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
        
        if userDefault.value(forKey: "date") as? Date != nil && userDefault.value(forKey: "todayQuizzedVolcabularyCount") as? Int != nil
        {
            // 從 userDefault 讀出今天學習的單字數量
            let calendar = Calendar.current
            
            let pastDate = userDefault.value(forKey: "date") as! Date
            let currentDate = Date()
            
            let date1 = calendar.startOfDay(for: pastDate)
            let date2 = calendar.startOfDay(for: currentDate)
            let components = calendar.dateComponents([.day], from: date1, to: date2).day
            if components! > 1 // 今天以前的學習數量
            {
                todayQuizzedVolcabularyCount = 0
            }
            else // 今天學習的數量
            {
                let pastCount = userDefault.value(forKey: "todayQuizzedVolcabularyCount") as! Int
                todayQuizzedVolcabularyCount += pastCount
            }
        }
        else
        {
            let currentDate = Date()
            self.userDefault.setValue(currentDate, forKey: "date")
            self.userDefault.setValue(todayQuizzedVolcabularyCount, forKey: "todayQuizzedVolcabularyCount")
        }
    }
    
    func resetAllData() // 重設所有設定
    {
        starImageName = "filled"
        currentVolcabularyIndex = 0 // 現在測驗的單字索引
        nextVocabularyButton.title = "下一個"
        previousVocabularyButton.isEnabled = false
        
        quizView.isHidden = false
        displayAndQuizItemView.isHidden = true
        quizDisplayView.isHidden = true
        quizCompleteView.isHidden = true
        wrongVocabularyView.isHidden = true
        
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
        inputdataError = false
        
        japaneseTextField.stringValue = ""
        exampleTextField.stringValue = ""
        typeTextField.stringValue = ""
        japaneseDescriptionTextField.stringValue = ""
        chineseDescriptionTextField.stringValue = ""
        kanaTextField.stringValue = ""
        exampleChineseTextField.stringValue = ""
        pageFromTextField.stringValue = "1"
        pageToTextField.stringValue = "1"
        pageFromStepper.integerValue = 1
        pageToStepper.integerValue = 1
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
        
        displayItemCount = 0
        quizItemCount = 0
        correctItem = 0
        
        displayJapaneseCheckBox.state = .off
        displayKanaCheckBox.state = .off
        displayJapaneseDefinitionCheckBox.state = .on
        displayTypeCheckBox.state = .on
        displayLevelCheckBox.state = .off
        quizJapaneseCheckBox.state = .on
        quizKanaCheckBox.state = .on
        quizJapaneseDefinitionCheckBox.state = .off
        quizChineseDefinitionCheckBox.state = .off
        answer.removeAll()
        quizViewController.wrongAnswer.removeAll()
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
            wrongVocabularyView.isHidden = true
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
    
    // MARK: 顯示和測驗頁面
    @IBOutlet weak var displayItemView: NSView!
    @IBOutlet weak var quizItemView: NSView!
    
    @IBOutlet weak var displayJapaneseCheckBox: NSButton!
    @IBOutlet weak var displayKanaCheckBox: NSButton!
    @IBOutlet weak var displayJapaneseDefinitionCheckBox: NSButton!
    @IBOutlet weak var displayTypeCheckBox: NSButton!
    @IBOutlet weak var displayLevelCheckBox: NSButton!
    
    @IBOutlet weak var quizJapaneseCheckBox: NSButton!
    @IBOutlet weak var quizKanaCheckBox: NSButton!
    @IBOutlet weak var quizJapaneseDefinitionCheckBox: NSButton!
    @IBOutlet weak var quizChineseDefinitionCheckBox: NSButton!
    
    var displayItemCount = 0 // 有勾選的顯示項目
    var quizItemCount = 0 // 有勾選的測驗項目
    
    @IBAction func displayNextButton(_ sender: Any) {
        // 下一步按鍵
        todayQuizzedVolcabularyCount += searchResults.count
        // 顯示項目
        displayChineseDefinition.stringValue = searchResults[0].chineseDefinition
        if displayJapaneseCheckBox.state == .on // 日文
        {
            displayItemCount += 1
            displayVocabulary.isHidden = false
            displayVocabulary.stringValue = searchResults[0].volcabulary
        }
        if displayKanaCheckBox.state == .on // 假名
        {
            displayItemCount += 1
            displayKana.isHidden = false
            displayKana.stringValue = searchResults[0].kana
        }
        if displayJapaneseDefinitionCheckBox.state == .on // 日文解釋
        {
            displayItemCount += 1
            displayJapaneseDescription.isHidden = false
            displayJapaneseDescription.stringValue = searchResults[0].japaneseDefinition
        }
        if displayTypeCheckBox.state == .on // 類型
        {
            displayItemCount += 1
            displayType.isHidden = false
            displayType.stringValue = searchResults[0].type
        }
        if displayLevelCheckBox.state == .on // 等級
        {
            displayItemCount += 1
            displayLevel.isHidden = false
            displayLevel.stringValue = searchResults[0].level
        }
        
        // 測驗項目
        if quizJapaneseCheckBox.state == .on // 日文
        {
            quizVocabularyTextField.isEnabled = true
            quizItemCount += 1
        }
        if quizKanaCheckBox.state == .on // 假名
        {
            quizKanaTextField.isEnabled = true
            quizItemCount += 1
        }
        if quizJapaneseDefinitionCheckBox.state == .on // 日文解釋
        {
            quizJapaneseDefinitionTextField.isEnabled = true
            quizItemCount += 1
        }
        if quizChineseDefinitionCheckBox.state == .on // 中文解釋
        {
            quizChineseDefinitionTextField.isEnabled = true
            quizItemCount += 1
        }
        
        // 跳轉判斷
        if displayItemCount == 0 // 顯示沒有選擇任何一個選項
        {
            quizError.errorTitleText = "error"
            quizError.errorDescriptionText = "noSelection"
            performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
        }
        else if quizItemCount == 0 // 測驗沒有選擇任何一個選項
        {
            quizError.errorTitleText = "error"
            quizError.errorDescriptionText = "noSelection"
            performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
        }
        else if displayItemCount > 5 // 顯示只有設計顯示五個
        {
            quizError.errorTitleText = "error"
            quizError.errorDescriptionText = "selectionExceed"
            performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            displayItemCount = 0
        }
        else if quizItemCount > 4 // 顯示只有設計顯示四個
        {
            quizError.errorTitleText = "error"
            quizError.errorDescriptionText = "selectionExceed"
            performSegue(withIdentifier: "quizError", sender: self) // 跳轉到錯誤訊息
            quizItemCount = 0
        }
        else // 有選擇至少一個，往下一個頁面前進
        {
            quizView.isHidden = true
            displayAndQuizItemView.isHidden = true
            quizDisplayView.isHidden = false
            quizCompleteView.isHidden = true
            wrongVocabularyView.isHidden = true
            if searchResults.count == 1 // 顯示最後一個單字時
            {
                nextVocabularyButton.title = "完成"
            }
        }
        
    }
    
    
    @IBAction func displayCancelButton(_ sender: Any) {
        // 取消按鍵
        resetAllData()
    }
    
    // MARK: 測驗頁面
    @IBOutlet weak var displayChineseDefinition: NSTextField!
    @IBOutlet weak var displayType: NSTextField!
    @IBOutlet weak var displayLevel: NSTextField!
    @IBOutlet weak var displayVocabulary: NSTextField!
    @IBOutlet weak var displayKana: NSTextField!
    @IBOutlet weak var displayJapaneseDescription: NSTextField!
    
    @IBOutlet weak var quizVocabularyLabel: NSTextField!
    @IBOutlet weak var quizVocabularyTextField: NSTextField!
    @IBOutlet weak var quizKanaLabel: NSTextField!
    @IBOutlet weak var quizKanaTextField: NSTextFieldCell!
    @IBOutlet weak var quizJapaneseDefinitionLabel: NSTextField!
    @IBOutlet weak var quizJapaneseDefinitionTextField: NSTextField!
    @IBOutlet weak var quizChineseDefinitionLabel: NSTextField!
    @IBOutlet weak var quizChineseDefinitionTextField: NSTextFieldCell!
    
    @IBOutlet weak var previousVocabularyButton: NSButton!
    @IBOutlet weak var nextVocabularyButton: NSButton!
    
    var starImageName = "filled"
    var currentVolcabularyIndex = 0 // 現在測驗的單字索引
    let starImageFilled = #imageLiteral(resourceName: "starFill")
    let starImageEmpty = #imageLiteral(resourceName: "starEmpty")
    var correctItem = 0 // 測驗正確的數目
    var answer = Array(repeating: Array(repeating: "", count: 4), count: 1000) // 回答的內容
    static var wrongAnswer = Array(repeating: Array(repeating: false, count: 4), count: 1000) // 錯誤的單字

    @IBAction func nextVocabularyButtonClicked(_ sender: Any) // 下一個單字按鈕
    {
        if nextVocabularyButton.title == "完成"
        {
            // 記錄回答內容
            if quizJapaneseCheckBox.state == .on // 日文
            {
                answer[currentVolcabularyIndex][0] = quizVocabularyTextField.stringValue
            }
            if quizKanaCheckBox.state == .on // 假名
            {
                answer[currentVolcabularyIndex][1] = quizKanaTextField.stringValue
            }
            if quizJapaneseDefinitionCheckBox.state == .on // 日文解釋
            {
                answer[currentVolcabularyIndex][2] = quizJapaneseDefinitionTextField.stringValue
            }
            if quizChineseDefinitionCheckBox.state == .on // 中文解釋
            {
                answer[currentVolcabularyIndex][3] = quizChineseDefinitionTextField.stringValue
            }
            
            var checkIndex = 0
            for ans in answer
            {
                if ans[0] != "" && ans[0] == searchResults[checkIndex].volcabulary // 日文
                {
                    correctItem += 1
                }
                else // 答案錯誤
                {
                    quizViewController.wrongAnswer[checkIndex][0] = true
                }
                
                if ans[1] != "" && ans[1] == searchResults[checkIndex].kana // 假名
                {
                    correctItem += 1
                }
                else // 答案錯誤
                {
                    quizViewController.wrongAnswer[checkIndex][1] = true
                }
                
                if ans[2] != "" && ans[2] == searchResults[checkIndex].japaneseDefinition // 日文解釋
                {
                    correctItem += 1
                }
                else // 答案錯誤
                {
                    quizViewController.wrongAnswer[checkIndex][2] = true
                }
                
                if ans[3] != "" && ans[3] == searchResults[checkIndex].chineseDefinition // 中文解釋
                {
                    correctItem += 1
                }
                else // 答案錯誤
                {
                    quizViewController.wrongAnswer[checkIndex][3] = true
                }
                
                checkIndex += 1
            }
            
            allQuizzedVocabularyCount.stringValue = "在測驗的" + String(searchResults.count) + " 個單字中"
            correctVocabularyCountText.stringValue = String(correctItem) + " 個單字"
            
            quizView.isHidden = true
            displayAndQuizItemView.isHidden = true
            quizDisplayView.isHidden = true
            quizCompleteView.isHidden = false
            wrongVocabularyView.isHidden = true
        }
        else // 顯示下一個
        {
            // 記錄回答內容
            if quizJapaneseCheckBox.state == .on // 日文
            {
                answer[currentVolcabularyIndex][0] = quizVocabularyTextField.stringValue
            }
            if quizKanaCheckBox.state == .on // 假名
            {
                answer[currentVolcabularyIndex][1] = quizKanaTextField.stringValue
            }
            if quizJapaneseDefinitionCheckBox.state == .on // 日文解釋
            {
                answer[currentVolcabularyIndex][2] = quizJapaneseDefinitionTextField.stringValue
            }
            if quizChineseDefinitionCheckBox.state == .on // 中文解釋
            {
                answer[currentVolcabularyIndex][3] = quizChineseDefinitionTextField.stringValue
            }
            
            currentVolcabularyIndex += 1
            previousVocabularyButton.isEnabled = true
            displayVocabulary.stringValue = searchResults[currentVolcabularyIndex].volcabulary
            displayKana.stringValue = searchResults[currentVolcabularyIndex].kana
            displayJapaneseDescription.stringValue = searchResults[currentVolcabularyIndex].japaneseDefinition
            displayType.stringValue = searchResults[currentVolcabularyIndex].type
            displayLevel.stringValue = searchResults[currentVolcabularyIndex].level
            displayChineseDefinition.stringValue = searchResults[currentVolcabularyIndex].chineseDefinition
            
            if currentVolcabularyIndex+1 > searchResults.count-1 // 最後一個單字
            {
                nextVocabularyButton.title = "完成"
            }
            
            quizVocabularyTextField.stringValue = ""
            quizKanaTextField.stringValue = ""
            quizJapaneseDefinitionTextField.stringValue = ""
            quizChineseDefinitionTextField.stringValue = ""
        }
    }
    
    @IBAction func previousVocabularyButtonClicked(_ sender: Any) // 上一個單字按鈕
    {
        currentVolcabularyIndex -= 1
        nextVocabularyButton.title = "下一個"
        displayVocabulary.stringValue = searchResults[currentVolcabularyIndex].volcabulary
        displayKana.stringValue = searchResults[currentVolcabularyIndex].kana
        displayJapaneseDescription.stringValue = searchResults[currentVolcabularyIndex].japaneseDefinition
        displayType.stringValue = searchResults[currentVolcabularyIndex].type
        displayLevel.stringValue = searchResults[currentVolcabularyIndex].level
        displayChineseDefinition.stringValue = searchResults[currentVolcabularyIndex].chineseDefinition

        if currentVolcabularyIndex == 0 // 第一個單字
        {
            previousVocabularyButton.isEnabled = false
        }
        
        quizVocabularyTextField.stringValue = ""
        quizKanaTextField.stringValue = ""
        quizJapaneseDefinitionTextField.stringValue = ""
        quizChineseDefinitionTextField.stringValue = ""
    }
    
    @IBAction func cancelVocabularyButtonClicked(_ sender: Any) // 取消按鈕
    {
        resetAllData()
    }
    
    // MARK: 學習完成
    @IBOutlet weak var allQuizzedVocabularyCount: NSTextField!
    @IBOutlet weak var correctVocabularyCountText: NSTextField!
    
    @IBAction func TaiyouxiulebaButtonClicked(_ sender: Any) // "太優秀了吧!"按鈕
    {
        resetAllData()
    }
    
    @IBAction func WocuoleshenmeButtonClicked(_ sender: Any) // "我錯了什麼?" 按鈕
    {
        quizView.isHidden = true
        displayAndQuizItemView.isHidden = true
        quizDisplayView.isHidden = true
        quizCompleteView.isHidden = true
        wrongVocabularyView.isHidden = false
        
        if quizViewController.wrongAnswer[0][0] // 日文錯誤
        {
            wrongVocabulary.attributedStringValue = searchResults[0].volcabulary.strikeThroughCenter()
        }
        else // 沒有錯誤
        {
            wrongVocabulary.stringValue = searchResults[0].volcabulary
        }
        
        if quizViewController.wrongAnswer[0][1] // 假名錯誤
        {
            wrongKana.attributedStringValue = searchResults[0].kana.strikeThroughCenter()
        }
        else
        {
            wrongKana.stringValue = searchResults[0].kana
        }
        
        if quizViewController.wrongAnswer[0][2] // 日文解釋錯誤
        {
            wrongJapaneseDefinition.attributedStringValue = searchResults[0].japaneseDefinition.strikeThroughLeft()
        }
        else
        {
            wrongJapaneseDefinition.stringValue = searchResults[0].japaneseDefinition
        }
        
        if quizViewController.wrongAnswer[0][3] // 中文解釋錯誤
        {
            wrongChineseDefinition.attributedStringValue = searchResults[0].japaneseDefinition.strikeThroughRight()
        }
        else
        {
            wrongChineseDefinition.stringValue = searchResults[0].chineseDefinition
        }
        
        wrongChineseExample.stringValue = searchResults[0].sentence_chinese
        wrongJapaneseExample.stringValue = searchResults[0].sentence
        wrongType.stringValue = searchResults[0].type
        wrongLevel.stringValue = searchResults[0].level
    }
    
    // MARK: 錯誤單字
    @IBOutlet weak var wrongVocabulary: NSTextField!
    @IBOutlet weak var wrongChineseDefinition: NSTextField!
    @IBOutlet weak var wrongKana: NSTextField!
    @IBOutlet weak var wrongJapaneseDefinition: NSTextField!
    @IBOutlet weak var wrongChineseExample: NSTextField!
    @IBOutlet weak var wrongJapaneseExample: NSTextField!
    @IBOutlet weak var wrongType: NSTextField!
    @IBOutlet weak var wrongLevel: NSTextField!
    
}

class displayChineseDefinitionDisplaySetting : NSTextFieldCell {
    // 中文解釋顯示設定，置中跟底線
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)

        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.height - minimumHeight) - 15
        titleRect.size.height = minimumHeight

        return titleRect
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }
    
    let borderThickness: CGFloat = 1

    // Add extra height, to accomodate the underlined border, as the minimum required size for the NSTextField
    override var cellSize: NSSize {
        let originalSize = super.cellSize
        return NSSize(width: originalSize.width, height: originalSize.height + borderThickness)
    }

    // Render the custom border for the NSTextField
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        // Area that covers the NSTextField itself. That is the total height minus our custom border size.
        let interiorFrame = NSRect(x: 0, y: 0, width: cellFrame.width, height: cellFrame.height - borderThickness)

        let path = NSBezierPath()
        path.lineWidth = borderThickness
        // Line width is at the center of the line.
        path.move(to: NSPoint(x: 0, y: cellFrame.height - (borderThickness / 2)))
        path.line(to: NSPoint(x: cellFrame.width, y: cellFrame.height - (borderThickness / 2)))
        NSColor.white.setStroke()
        path.stroke()

        // Pass in area minus the border thickness in the height
        drawInterior(withFrame: interiorFrame, in: controlView)
    }
}

class verticalCenterTextFieldCell: NSTextFieldCell {
    // textField 置中顯示設定，編輯時也可以用
    func adjustedFrame(toVerticallyCenterText rect: NSRect) -> NSRect {
        // super would normally draw text at the top of the cell
        var titleRect = super.titleRect(forBounds: rect)

        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight

        return titleRect
    }

    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        super.edit(withFrame: adjustedFrame(toVerticallyCenterText: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
    }

    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: adjustedFrame(toVerticallyCenterText: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: adjustedFrame(toVerticallyCenterText: cellFrame), in: controlView)
    }

    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.draw(withFrame: cellFrame, in: controlView)
    }
}

class TextFieldChange: NSTextField {

    override func updateTrackingAreas() {
        for area in self.trackingAreas {
            self.removeTrackingArea(area)
        }
        self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false)
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        var strikeThroughed = false // 該 label 是否是劃掉的
        let attributes = self.attributedStringValue.attributes(at: 0, effectiveRange: nil)
        for attr in attributes // 檢查該 string 所有 attributes
        {
            if attr.key.rawValue == "NSStrikethrough"
            {
                strikeThroughed = true
            }
        }
        
        if strikeThroughed // 該 label 是劃掉的
        {
            for answers in quizViewController.wrongAnswer
            {
                print(answers)
            }
        }
        else // 一般數值
        {
            
        }
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        //print("printExited")
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        //print("mouseEntered")
    }

}

extension String {
    func strikeThroughCenter() -> NSAttributedString // string 劃掉加上置中
    {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor( red: CGFloat(203/255.0), green: CGFloat(27/255.0), blue: CGFloat(69/255.0), alpha: CGFloat(1.0) ) , range: NSMakeRange(0, attributeString.length))
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        attributeString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func strikeThroughRight() -> NSAttributedString // string 劃掉加上置右
    {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor( red: CGFloat(203/255.0), green: CGFloat(27/255.0), blue: CGFloat(69/255.0), alpha: CGFloat(1.0) ) , range: NSMakeRange(0, attributeString.length))
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.right
        attributeString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func strikeThroughLeft() -> NSAttributedString // string 劃掉加上置左
    {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor( red: CGFloat(203/255.0), green: CGFloat(27/255.0), blue: CGFloat(69/255.0), alpha: CGFloat(1.0) ) , range: NSMakeRange(0, attributeString.length))
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        attributeString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
