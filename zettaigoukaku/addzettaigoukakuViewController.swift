//
//  addzettaigoukakuViewController.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/7/13.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: "新增單字" 功能 view controller 總管
//
//  頁面流程: 選擇加入模式 -> 手動輸入 -> 單字資訊 -> 新增 -> 加入成功
//                     -> 使用 MOJi 辭書輔助輸入 -> 跳出 moji 辭書 webView -> 爬蟲結果 -> 單字資訊 -> 新增 -> 加入成功
//

import Cocoa

class addzettaigoukakuViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var mojiImageView: NSImageView!
    @IBOutlet weak var manuallyInputImageView: NSImageView!
    @IBOutlet weak var addzettaigoukaku: NSView!
    @IBOutlet weak var addzettaigoukakuInfo: NSView!
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
        let inputImage = #imageLiteral(resourceName: "ManuallyAddzettaigoukaku")
        inputImage.size = NSSize(width: 150, height: 150)
        manuallyInputImageView.image = inputImage
        let addSuccessfulImage = #imageLiteral(resourceName: "CheckMark")
        addSuccessfulImage.size = NSSize(width: 150, height: 150)
        addSuccessfulImageView.image = addSuccessfulImage
        
        stepper.integerValue = 1
        addzettaigoukakuInfo.isHidden = true
        progressView.isHidden = true
        crawResultView.isHidden = true
        addSuccessfulView.isHidden = true
        sentenceMenu.isEnabled = false
        japaneseDescriptionMenu.isEnabled = false
        progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
        scheduledTimerWithTimeInterval()
        pageTextField.delegate = self // 連動 controlTextDidChange Function
        stepper.integerValue = 1
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    // MARK: 自動更新
    @objc func updateCounting()  // 0.1 秒跑一次
    {
        // moji 辭書 webView 關閉
        if addzettaigoukakuViewController.webViewEnd == true
        {
            if addzettaigoukakuViewController.progress != -1 // 有輸入單字並跳轉頁面
            {
                switch addzettaigoukakuViewController.progress {
                case 10:
                    progressBarLabel.stringValue = "頁面載入中"
                    progressBar.increment(by: 10)
                case 20:
                    progressBarLabel.stringValue = "抓取資料中"
                    progressBar.increment(by: 10)
                case 30:
                    progressBarLabel.stringValue = "抓取完成"
                    progressBar.increment(by: 10)
                    addzettaigoukakuViewController.webViewEnd = false
                    addzettaigoukakuViewController.progress = 0
                    
                    // 將抓取到的資料填入 menu，顯示在 "爬蟲結果" 頁面
                    for i in 0..<CrawzettaigoukakuViewController.VD.sentence_chinese.count
                    {
                        sentenceChineseMenu.addItem(withTitle: CrawzettaigoukakuViewController.VD.sentence_chinese[i])
                    }
                    for i in 0..<CrawzettaigoukakuViewController.VD.sentence.count
                    {
                        sentenceMenu.addItem(withTitle: CrawzettaigoukakuViewController.VD.sentence[i])
                    }
                    for i in 0..<CrawzettaigoukakuViewController.VD.type.count
                    {
                        typeMenu.addItem(withTitle: CrawzettaigoukakuViewController.VD.type[i])
                    }
                    for i in 0..<CrawzettaigoukakuViewController.VD.chineseDefenition.count
                    {
                        chineseDescriptionMenu.addItem(withTitle: CrawzettaigoukakuViewController.VD.chineseDefenition[i])
                    }
                    for i in 0..<CrawzettaigoukakuViewController.VD.japaneseDefenition.count
                    {
                        japaneseDescriptionMenu.addItem(withTitle: CrawzettaigoukakuViewController.VD.japaneseDefenition[i])
                    }
                    
                    progressView.isHidden = true
                    crawResultView.isHidden = false
                    addzettaigoukakuInfo.isHidden = true
                    addSuccessfulView.isHidden = true
                    
                default:
                    progressBarLabel.stringValue = "抓取錯誤"
                    addzettaigoukakuViewController.webViewEnd = false
                    addzettaigoukakuViewController.progress = 0
                }
            }
            else // 按 "取消" 關閉 webView
            {
                addzettaigoukakuViewController.webViewEnd = false
                addzettaigoukakuViewController.progress = 0
                addzettaigoukakuInfo.isHidden = true
                progressView.isHidden = true
                addzettaigoukaku.isHidden = false
            }
        }
        
        if FunctionsViewController.saveEnded == true
        {
            // 等待 FunctionsViewController saveFile 完成
            self.addSuccessfulView.isHidden = true
            self.addzettaigoukaku.isHidden = false
            self.crawResultView.isHidden = true
            self.addzettaigoukakuInfo.isHidden = true
            FunctionsViewController.saveEnded = false
        }
    }
        
    // MARK: 新增單字頁面
    @IBAction func manuallyAdd(_ sender: Any) {
        // "手動輸入" 按鍵
        kanaTextField.stringValue = ""
        sentenceTextField.stringValue = ""
        typeTextField.stringValue = ""
        japaneseDescriptionTextField.stringValue = ""
        chineseDescriptionTextField.stringValue = ""
        volcabularyTextField.stringValue = ""
        sentence_chineseTextField.stringValue = ""
        pageTextField.stringValue = "1"
        levelMenu.selectItem(at: 0)
        StarCheckBox.state = .on
        
        addzettaigoukaku.isHidden = true
        crawResultView.isHidden = true
        addzettaigoukakuInfo.isHidden = false
        addSuccessfulView.isHidden = true
    }
    
    @IBAction func mojiAddButton(_ sender: Any) {
        // "使用 moji 輔助輸入" 按鍵
        addzettaigoukaku.isHidden = true
        progressView.isHidden = false
        performSegue(withIdentifier: "showMojiWebView", sender: self)
        progressBar.startAnimation(nil)
    }
    
    // MARK: 爬蟲結果頁面
    @IBAction func nextStep(_ sender: Any) {
        // "下一步" 按鍵
        volcabularyTextField.stringValue = CrawzettaigoukakuViewController.VD.volcabulary
        kanaTextField.stringValue = CrawzettaigoukakuViewController.VD.kana
        sentence_chineseTextField.stringValue = CrawzettaigoukakuViewController.VD.sentence_chinese[sentenceChineseMenu.indexOfSelectedItem]
        sentenceTextField.stringValue = CrawzettaigoukakuViewController.VD.sentence[sentenceMenu.indexOfSelectedItem]
        typeTextField.stringValue = CrawzettaigoukakuViewController.VD.type[typeMenu.indexOfSelectedItem]
        chineseDescriptionTextField.stringValue = CrawzettaigoukakuViewController.VD.chineseDefenition[chineseDescriptionMenu.indexOfSelectedItem]
        japaneseDescriptionTextField.stringValue = CrawzettaigoukakuViewController.VD.japaneseDefenition[japaneseDescriptionMenu.indexOfSelectedItem]
        addzettaigoukaku.isHidden = true
        crawResultView.isHidden = true
        addzettaigoukakuInfo.isHidden = false
        addSuccessfulView.isHidden = true
    }
    
    @IBAction func crawResultCancelButton(_ sender: Any) {
        // "爬蟲結果" 頁面 "取消" 按鍵
        progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
        addzettaigoukaku.isHidden = false
        crawResultView.isHidden = true
        addzettaigoukakuInfo.isHidden = true
        addSuccessfulView.isHidden = true
        addzettaigoukakuViewController.webViewEnd = false
        addzettaigoukakuViewController.progress = 0
        stepper.integerValue = 1
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
    
    // MARK: 單字資訊頁面
    func controlTextDidChange(_ obj: Notification) {
        // 監測頁數 textField 改動，連動更動 stepper 數值
        let textField = obj.object as! NSTextField
        let pageValue = Int(textField.stringValue) ?? 0
        if pageValue == 0  || pageValue > 1000 // 不是 輸入數值 或 超過範圍 (1~1000)，改動回原本的數字
        {
            AddzettaigoukakuErrorViewController.errorTitle = "adding"
            AddzettaigoukakuErrorViewController.errorContent = "pageError"
            performSegue(withIdentifier: "addzettaigoukakuError", sender: self) // 跳轉到警告畫面
            textField.stringValue = String(stepper.integerValue)
        }
        else // 正常數字範圍
        {
            stepper.integerValue = Int(textField.stringValue)!
        }
    }
    
    @IBAction func stepperChanger(_ sender: NSStepper) {
        // Stepper 改動
        pageTextField.stringValue = String(sender.integerValue)
    }
    
    
    @IBAction func volcabularyInfoCancelButton(_ sender: Any) {
        // "單字資訊" 頁面 “取消" 按鍵
        progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
        addzettaigoukaku.isHidden = false
        crawResultView.isHidden = true
        addzettaigoukakuInfo.isHidden = true
        addSuccessfulView.isHidden = true
        addzettaigoukakuViewController.webViewEnd = false
        addzettaigoukakuViewController.progress = 0
        stepper.integerValue = 1
    }
    
    @IBAction func addButton(_ sender: Any) {
        // "單字資訊" 頁面 "新增" 按鍵
        addzettaigoukakuViewController.kana = kanaTextField.stringValue
        addzettaigoukakuViewController.sentence = sentenceTextField.stringValue
        addzettaigoukakuViewController.type = typeTextField.stringValue
        addzettaigoukakuViewController.japaneseDefinition = japaneseDescriptionTextField.stringValue
        addzettaigoukakuViewController.chineseDefinition = chineseDescriptionTextField.stringValue
        addzettaigoukakuViewController.volcabulary = volcabularyTextField.stringValue
        addzettaigoukakuViewController.sentenceChinese = sentence_chineseTextField.stringValue
        
        if addzettaigoukakuViewController.kana != "" && addzettaigoukakuViewController.sentence != "" && addzettaigoukakuViewController.type != "" && addzettaigoukakuViewController.japaneseDefinition != "" && addzettaigoukakuViewController.chineseDefinition != "" && addzettaigoukakuViewController.volcabulary != "" && addzettaigoukakuViewController.sentenceChinese != ""
        {
            if !FunctionsViewController.isDuplicate(newzettaigoukaku: addzettaigoukakuViewController.volcabulary) // 正常新增單字
            {
                addSuccessfulView.isHidden = false
                addzettaigoukakuInfo.isHidden = true
                switch levelMenu.indexOfSelectedItem {
                case 0:
                    addzettaigoukakuViewController.level = "N5"
                case 1:
                    addzettaigoukakuViewController.level = "N4"
                case 2:
                    addzettaigoukakuViewController.level = "N3"
                case 3:
                    addzettaigoukakuViewController.level = "N2"
                case 4:
                    addzettaigoukakuViewController.level = "N1"
                default:
                    break
                }
                
                addzettaigoukakuViewController.page = Int(pageTextField.stringValue)!
                
                if StarCheckBox.state == .on
                {
                    addzettaigoukakuViewController.star = true
                }
                else
                {
                    addzettaigoukakuViewController.star = false
                }
                
                addzettaigoukakuViewController.volcabularyAdded = true
                progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
                addzettaigoukakuViewController.progress = 0
                pageTextField.stringValue = "1"
                levelMenu.selectItem(at: 0)
                StarCheckBox.state = .on
            }
            else // 是重複的單字
            {
                AddzettaigoukakuErrorViewController.errorTitle = "adding"
                AddzettaigoukakuErrorViewController.errorContent = "duplicates"
                performSegue(withIdentifier: "addzettaigoukakuError", sender: self)
            }
        }
        
        else // 有欄位沒有輸入
        {
            AddzettaigoukakuErrorViewController.errorTitle = "adding"
            AddzettaigoukakuErrorViewController.errorContent = "noData"
            performSegue(withIdentifier: "addzettaigoukakuError", sender: self)
        }
    }
}
