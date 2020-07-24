//
//  addVolcabularyViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/13.
//  Copyright © 2020 Toby. All rights reserved.
//  Main usage: "新增單字" 功能 view controller 總管
//  頁面流程: 選擇加入模式 -> 手動輸入 -> 單字資訊 -> 新增 -> 加入成功
//                     -> 使用 MOJi 辭書輔助輸入 -> 跳出 moji 辭書 webView -> 爬蟲結果 -> 單字資訊 -> 新增 -> 加入成功
//

import Cocoa

class addVolcabularyViewController: NSViewController {

    @IBOutlet weak var mojiImageView: NSImageView!
    @IBOutlet weak var manuallyInputImageView: NSImageView!
    @IBOutlet weak var addVolcabulary: NSView!
    @IBOutlet weak var addVolcabularyInfo: NSView!
    @IBOutlet weak var progressView: NSView!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var progressBarLabel: NSTextField!
    @IBOutlet weak var crawResultView: NSView!
    @IBOutlet weak var addSuccessfulView: NSView!
    
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
    
    @IBOutlet weak var sentenceChineseMenu: NSPopUpButton!
    @IBOutlet weak var sentenceMenu: NSPopUpButton!
    @IBOutlet weak var typeMenu: NSPopUpButton!
    @IBOutlet weak var chineseDescriptionMenu: NSPopUpButton!
    @IBOutlet weak var japaneseDescriptionMenu: NSPopUpButton!
    @IBOutlet weak var linkWithJapaneseSentenceCheckBox: NSButtonCell!
    @IBOutlet weak var linkWithJapaneseDescriptionCheckBox: NSButton!
    
    
    @IBOutlet weak var addSuccessfulImageView: NSImageView!
    
    
    static var volcabularyAdded = false // 控制 FunctionsViewController 是否要加入字典
    static var webViewEnd = false // 控制 webView 是否結束了
    static var progress = 0 // 控制進度條進度
    
    static var kana = ""
    static var sentence = ""
    static var type = ""
    static var japaneseDefinition = ""
    static var chineseDefinition = ""
    static var volcabulary = ""
    static var sentenceChinese = ""
    static var level = ""
    static var page = 0
    static var star = true
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let mojiImage = #imageLiteral(resourceName: "MOJi")
        mojiImage.size = NSSize(width: 150, height: 150)
        mojiImageView.image = mojiImage
        let inputImage = #imageLiteral(resourceName: "ManuallyAddVolcabulary") // Icon collection website: https://iconmonstr.com
        inputImage.size = NSSize(width: 150, height: 150)
        manuallyInputImageView.image = inputImage
        let addSuccessfulImage = #imageLiteral(resourceName: "CheckMark")
        addSuccessfulImage.size = NSSize(width: 150, height: 150)
        addSuccessfulImageView.image = addSuccessfulImage
        
        addVolcabularyInfo.isHidden = true
        progressView.isHidden = true
        crawResultView.isHidden = true
        addSuccessfulView.isHidden = true
        sentenceMenu.isEnabled = false
        japaneseDescriptionMenu.isEnabled = false
        progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting()  // 0.1 秒跑一次
    {
        // moji 辭書 webView 關閉
        if addVolcabularyViewController.webViewEnd == true
        {
            if addVolcabularyViewController.progress != -1 // 有輸入單字並跳轉頁面
            {
                switch addVolcabularyViewController.progress {
                case 10:
                    progressBarLabel.stringValue = "頁面載入中"
                    progressBar.increment(by: 10)
                case 20:
                    progressBarLabel.stringValue = "抓取資料中"
                    progressBar.increment(by: 10)
                case 30:
                    progressBarLabel.stringValue = "抓取完成"
                    progressBar.increment(by: 10)
                    addVolcabularyViewController.webViewEnd = false
                    addVolcabularyViewController.progress = 0
                    
                    // 將抓取到的資料填入 menu，顯示在 "爬蟲結果" 頁面
                    for i in 0..<CrawVolcabularyViewController.VD.sentence_chinese.count
                    {
                        sentenceChineseMenu.addItem(withTitle: CrawVolcabularyViewController.VD.sentence_chinese[i])
                    }
                    for i in 0..<CrawVolcabularyViewController.VD.sentence.count
                    {
                        sentenceMenu.addItem(withTitle: CrawVolcabularyViewController.VD.sentence[i])
                    }
                    for i in 0..<CrawVolcabularyViewController.VD.type.count
                    {
                        typeMenu.addItem(withTitle: CrawVolcabularyViewController.VD.type[i])
                    }
                    for i in 0..<CrawVolcabularyViewController.VD.chineseDefenition.count
                    {
                        chineseDescriptionMenu.addItem(withTitle: CrawVolcabularyViewController.VD.chineseDefenition[i])
                    }
                    for i in 0..<CrawVolcabularyViewController.VD.japaneseDefenition.count
                    {
                        japaneseDescriptionMenu.addItem(withTitle: CrawVolcabularyViewController.VD.japaneseDefenition[i])
                    }
                    
                    progressView.isHidden = true
                    crawResultView.isHidden = false
                    addVolcabularyInfo.isHidden = true
                    addSuccessfulView.isHidden = true
                    
                default:
                    progressBarLabel.stringValue = "抓取錯誤"
                    addVolcabularyViewController.webViewEnd = false
                    addVolcabularyViewController.progress = 0
                }
            }
            else // 按 "取消" 關閉 webView
            {
                addVolcabularyViewController.webViewEnd = false
                addVolcabularyViewController.progress = 0
                addVolcabularyInfo.isHidden = true
                progressView.isHidden = true
                addVolcabulary.isHidden = false
            }
        }
    }
        
    
    @IBAction func manuallyAdd(_ sender: Any) {
        // "手動輸入" 按鍵
        addVolcabulary.isHidden = true
        crawResultView.isHidden = true
        addVolcabularyInfo.isHidden = false
        addSuccessfulView.isHidden = true
    }
    
    @IBAction func mojiAddButton(_ sender: Any) {
        // "使用 moji 輔助輸入" 按鍵
        addVolcabulary.isHidden = true
        progressView.isHidden = false
        performSegue(withIdentifier: "showMojiWebView", sender: self)
        progressBar.startAnimation(nil)
    }
    
    @IBAction func nextStep(_ sender: Any) {
        // "下一步" 按鍵
        volcabularyTextField.stringValue = CrawVolcabularyViewController.VD.volcabulary
        kanaTextField.stringValue = CrawVolcabularyViewController.VD.kana
        sentence_chineseTextField.stringValue = CrawVolcabularyViewController.VD.sentence_chinese[sentenceChineseMenu.indexOfSelectedItem]
        sentenceTextField.stringValue = CrawVolcabularyViewController.VD.sentence[sentenceMenu.indexOfSelectedItem]
        typeTextField.stringValue = CrawVolcabularyViewController.VD.type[typeMenu.indexOfSelectedItem]
        chineseDescriptionTextField.stringValue = CrawVolcabularyViewController.VD.chineseDefenition[chineseDescriptionMenu.indexOfSelectedItem]
        japaneseDescriptionTextField.stringValue = CrawVolcabularyViewController.VD.japaneseDefenition[japaneseDescriptionMenu.indexOfSelectedItem]
        addVolcabulary.isHidden = true
        crawResultView.isHidden = true
        addVolcabularyInfo.isHidden = false
        addSuccessfulView.isHidden = true
    }
    
    @IBAction func crawResultCancelButton(_ sender: Any) {
        // "爬蟲結果" 頁面 "取消" 按鍵
        progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
        addVolcabulary.isHidden = false
        crawResultView.isHidden = true
        addVolcabularyInfo.isHidden = true
        addSuccessfulView.isHidden = true
        addVolcabularyViewController.webViewEnd = false
        addVolcabularyViewController.progress = 0
    }
    
    @IBAction func volcabularyInfoCancelButton(_ sender: Any) {
        // "單字資訊" 頁面 “取消" 按鍵
        progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
        addVolcabulary.isHidden = false
        crawResultView.isHidden = true
        addVolcabularyInfo.isHidden = true
        addSuccessfulView.isHidden = true
        addVolcabularyViewController.webViewEnd = false
        addVolcabularyViewController.progress = 0
    }
    
    @IBAction func addButton(_ sender: Any) {
        // "單字資訊" 頁面 "新增" 按鍵
        addVolcabularyViewController.kana = kanaTextField.stringValue
        addVolcabularyViewController.sentence = sentenceTextField.stringValue
        addVolcabularyViewController.type = typeTextField.stringValue
        addVolcabularyViewController.japaneseDefinition = japaneseDescriptionTextField.stringValue
        addVolcabularyViewController.chineseDefinition = chineseDescriptionTextField.stringValue
        addVolcabularyViewController.volcabulary = volcabularyTextField.stringValue
        addVolcabularyViewController.sentenceChinese = sentence_chineseTextField.stringValue
        
        if addVolcabularyViewController.kana != "" && addVolcabularyViewController.sentence != "" && addVolcabularyViewController.type != "" && addVolcabularyViewController.japaneseDefinition != "" && addVolcabularyViewController.chineseDefinition != "" && addVolcabularyViewController.volcabulary != "" && addVolcabularyViewController.sentenceChinese != ""
        {
            addSuccessfulView.isHidden = false
            addVolcabularyInfo.isHidden = true
            switch levelMenu.indexOfSelectedItem {
            case 0:
                addVolcabularyViewController.level = "N5"
            case 1:
                addVolcabularyViewController.level = "N4"
            case 2:
                addVolcabularyViewController.level = "N3"
            case 3:
                addVolcabularyViewController.level = "N2"
            case 4:
                addVolcabularyViewController.level = "N1"
            default:
                break
            }
            
            addVolcabularyViewController.page = Int(pageTextField.stringValue)!
            
            if StarCheckBox.state == .on
            {
                addVolcabularyViewController.star = true
            }
            else
            {
                addVolcabularyViewController.star = false
            }
            
            addVolcabularyViewController.volcabularyAdded = true
            progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
            addVolcabularyViewController.progress = 0
            
            // 顯示 "加入成功" 頁面 0.5 秒
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.addSuccessfulView.isHidden = true
                self.addVolcabulary.isHidden = false
                self.crawResultView.isHidden = true
                self.addVolcabularyInfo.isHidden = true
            }
        }
        
        else // 有欄位沒有輸入
        {
            performSegue(withIdentifier: "addVolcabularyError", sender: self)
        }
    }
    
    @IBAction func linkWithJapaneseSentence(_ sender: NSButton) {
        // 與日文例句連動 checkbox
        if sender.state == .on
        {
            sentenceMenu.isEnabled = false
            sentenceMenu.selectItem(at: sentenceChineseMenu.indexOfSelectedItem)
        }
        else
        {
            sentenceMenu.isEnabled = true
        }
    }
    
    @IBAction func linkWithJapaneseDefinition(_ sender: NSButton) {
        // 與日文解釋連動 checkbox
        if sender.state == .on
        {
            japaneseDescriptionMenu.isEnabled = false
            japaneseDescriptionMenu.selectItem(at: chineseDescriptionMenu.indexOfSelectedItem)
        }
        else
        {
            japaneseDescriptionMenu.isEnabled = true
        }
    }
    
    @IBAction func japaneseSentenceMenuLink(_ sender: Any) {
        // 日文例句選單自動跟著選擇更新
        if linkWithJapaneseSentenceCheckBox.state == .on
        {
            sentenceMenu.selectItem(at: sentenceChineseMenu.indexOfSelectedItem)
        }
    }
    
    @IBAction func japaneseDefinitionMenuLink(_ sender: Any) {
        // 日文解釋選單自動跟著選擇更新
        if linkWithJapaneseDescriptionCheckBox.state == .on
        {
            japaneseDescriptionMenu.selectItem(at: chineseDescriptionMenu.indexOfSelectedItem)
        }
    }
}
