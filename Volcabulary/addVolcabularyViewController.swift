//
//  addVolcabularyViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/13.
//  Copyright © 2020 Toby. All rights reserved.
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
    
    @IBOutlet weak var addSuccessfulImageView: NSImageView!
    
    
    static var volcabularyAdded = false
    static var webViewEnd = false
    static var progress = 0
    
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
        addVolcabularyInfo.isHidden = true
        progressView.isHidden = true
        crawResultView.isHidden = true
        addSuccessfulView.isHidden = true
        progressBarLabel.stringValue = "從 moji 辭書網頁顯示中"
        scheduledTimerWithTimeInterval()
        let addSuccessfulImage = #imageLiteral(resourceName: "CheckMark")
        addSuccessfulImage.size = NSSize(width: 150, height: 150)
        addSuccessfulImageView.image = addSuccessfulImage
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting()  // 0.1 秒跑一次
    {
        if addVolcabularyViewController.webViewEnd == true
        {
            if addVolcabularyViewController.progress != -1
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
            else
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
        addVolcabulary.isHidden = true
        crawResultView.isHidden = true
        addVolcabularyInfo.isHidden = false
        addSuccessfulView.isHidden = true
    }
    
    @IBAction func mojiAddButton(_ sender: Any) {
        addVolcabulary.isHidden = true
        progressView.isHidden = false
        performSegue(withIdentifier: "showMojiWebView", sender: self)
        progressBar.startAnimation(nil)
    }
    
    @IBAction func nextStep(_ sender: Any) {
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
        addVolcabulary.isHidden = false
        crawResultView.isHidden = true
        addVolcabularyInfo.isHidden = true
        addSuccessfulView.isHidden = true
        addVolcabularyViewController.webViewEnd = false
        addVolcabularyViewController.progress = 0
    }
    
    @IBAction func volcabularyInfoCancelButton(_ sender: Any) {
        addVolcabulary.isHidden = false
        crawResultView.isHidden = true
        addVolcabularyInfo.isHidden = true
        addSuccessfulView.isHidden = true
        addVolcabularyViewController.webViewEnd = false
        addVolcabularyViewController.progress = 0
    }
    
    @IBAction func addButton(_ sender: Any) {
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
            
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.addSuccessfulView.isHidden = true
                self.addVolcabulary.isHidden = false
                self.crawResultView.isHidden = true
                self.addVolcabularyInfo.isHidden = true
            }
        }
        
        else
        {
            performSegue(withIdentifier: "addVolcabularyError", sender: self)
        }
    }
    
}
