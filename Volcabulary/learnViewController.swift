//
//  learnViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/23.
//  Copyright © 2020 Toby. All rights reserved.
//

import Cocoa
import WebKit

class learnViewController: NSViewController {
    
    @IBOutlet weak var pageCheckBox: NSButton!
    @IBOutlet weak var japaneseCheckBox: NSButton!
    @IBOutlet weak var chineseCheckBox: NSButton!
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
    @IBOutlet weak var chineseTextField: NSTextField!
    @IBOutlet weak var japaneseDescriptionTextField: NSTextField!
    @IBOutlet weak var chineseDescriptionTextField: NSTextField!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var exampleTextField: NSTextField!
    @IBOutlet weak var exampleChineseTextField: NSTextField!
    @IBOutlet weak var levelFromMenu: NSPopUpButton!
    @IBOutlet weak var levelToMenu: NSPopUpButton!
    @IBOutlet weak var starMenu: NSPopUpButton!
    
    @IBOutlet weak var japaneseSearchMethod: NSPopUpButton!
    @IBOutlet weak var chineseSearchMethod: NSPopUpButton!
    @IBOutlet weak var japaneseDescriptionSearchMethod: NSPopUpButton!
    @IBOutlet weak var chineseDescriptionSearchMethod: NSPopUpButton!
    @IBOutlet weak var typeSearchMethod: NSPopUpButton!
    @IBOutlet weak var exampleSearchMethod: NSPopUpButton!
    @IBOutlet weak var exampleChineseSearchMethod: NSPopUpButton!
    
    var checked = false
    
    var pageRange = [Int]()
    var japanese = ""
    var chinese = ""
    var japaneseDescription = ""
    var chineseDescription = ""
    var type = ""
    var example = ""
    var exampleChinese = ""
    var level = [String]()
    var star = false
    
    var searchMethod = [Bool]() // 順序跟上面 IBOutlet 一樣，false: 包含, true: 完全相同
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    @IBAction func rangeVIewNextButton(_ sender: Any) {
        if pageCheckBox.state == .on // 頁數
        {
            checked = true
            if pageFromTextField.stringValue != ""
            {
                if Int(pageFromTextField.stringValue)! <= Int(pageToTextField.stringValue)!
                {
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
        if japaneseCheckBox.state == .on // 日文
        {
            checked = true
            if japaneseTextField.stringValue != ""
            {
                japanese = japaneseTextField.stringValue
                if japaneseSearchMethod.indexOfSelectedItem == 1 // 包含
                {
                    searchMethod.append(false)
                }
                else if japaneseSearchMethod.indexOfSelectedItem == 2 // 完全相同
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
        if chineseCheckBox.state == .on // 中文
        {
            checked = true
            if chineseTextField.stringValue != ""
            {
                chinese = chineseTextField.stringValue
                if chineseSearchMethod.indexOfSelectedItem == 1 // 包含
                {
                    searchMethod.append(false)
                }
                else if chineseSearchMethod.indexOfSelectedItem == 2 // 完全相同
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
        if japaneseDefinitionCheckBox.state == .on // 日文解釋
        {
            checked = true
            if japaneseDescriptionTextField.stringValue != ""
            {
                japaneseDescription = japaneseDescriptionTextField.stringValue
                if japaneseDescriptionSearchMethod.indexOfSelectedItem == 1 // 包含
                {
                    searchMethod.append(false)
                }
                else if japaneseDescriptionSearchMethod.indexOfSelectedItem == 2 // 完全相同
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
        if chineseDefinitionCheckBox.state == .on // 中文解釋
        {
            checked = true
            if chineseDescriptionTextField.stringValue != ""
            {
                chineseDescription = chineseDescriptionTextField.stringValue
                if chineseDescriptionSearchMethod.indexOfSelectedItem == 1 // 包含
                {
                    searchMethod.append(false)
                }
                else if chineseDescriptionSearchMethod.indexOfSelectedItem == 2 // 完全相同
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
        if typeCheckBox.state == .on // 類型
        {
            checked = true
            if typeTextField.stringValue != ""
            {
                type = typeTextField.stringValue
                if typeSearchMethod.indexOfSelectedItem == 1 // 包含
                {
                    searchMethod.append(false)
                }
                else if typeSearchMethod.indexOfSelectedItem == 2 // 完全相同
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
        if exampleCheckBox.state == .on // 日文例句
        {
            checked = true
            if exampleTextField.stringValue != ""
            {
                example = exampleTextField.stringValue
                if exampleSearchMethod.indexOfSelectedItem == 1 // 包含
                {
                    searchMethod.append(false)
                }
                else if exampleSearchMethod.indexOfSelectedItem == 2 // 完全相同
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
        if exampleChineseCheckBox.state == .on // 中文例句
        {
            checked = true
            if exampleChineseTextField.stringValue != ""
            {
                exampleChinese = exampleChineseTextField.stringValue
                if exampleChineseSearchMethod.indexOfSelectedItem == 1 // 包含
                {
                    searchMethod.append(false)
                }
                else if exampleChineseSearchMethod.indexOfSelectedItem == 2 // 完全相同
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
        if levelCheckBox.state == .on // 等級
        {
            checked = true
            if levelFromMenu.indexOfSelectedItem <= levelToMenu.indexOfSelectedItem
            {
                switch levelFromMenu.indexOfSelectedItem {
                case 1:
                    level.append("N5")
                case 2:
                    level.append("N4")
                case 3:
                    level.append("N3")
                case 4:
                    level.append("N2")
                case 5:
                    level.append("N1")
                default:
                    learnError.errorTitleText = "error"
                    learnError.errorDescriptionText = "noData"
                    performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
                }
                switch levelToMenu.indexOfSelectedItem {
                case 1:
                    level.append("N5")
                case 2:
                    level.append("N4")
                case 3:
                    level.append("N3")
                case 4:
                    level.append("N2")
                case 5:
                    level.append("N1")
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
        
        if starCheckBox.state == .on // 標記
        {
            checked = true
            switch starMenu.indexOfSelectedItem {
            case 1:
                star = true
            case 2:
                star = false
            default:
                star = false
            }
        }
        
        if checked == false // 沒有選擇任何一個欄位
        {
            learnError.errorTitleText = "error"
            learnError.errorDescriptionText = "noSelection"
            performSegue(withIdentifier: "learnError", sender: self) // 跳轉到錯誤訊息
        }
        checked = false
    }
    
}
