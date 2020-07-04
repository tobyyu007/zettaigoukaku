//
//  FunctionDetailsViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/3.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference of Table list: https://www.youtube.com/watch?v=VfVYX7nO9dQ


import Cocoa

class Volcabulary: NSObject
{
    @objc dynamic var volcabulary: String
    @objc dynamic var kana: String
    @objc dynamic var chinese: String
    @objc dynamic var type: String
    @objc dynamic var sentence: String
    @objc dynamic var sentence_chinese: String
    
    init(volcabulary: String, kana: String, chinese: String, type: String, sentence: String, sentence_chinese: String)
    {
        self.volcabulary = volcabulary
        self.kana = kana
        self.chinese = chinese
        self.type = type
        self.sentence = sentence
        self.sentence_chinese = sentence_chinese
    }
}


class FunctionsViewController: NSViewController {

    @IBOutlet weak var volcabularyview: NSView!
    @IBOutlet weak var addvocabularyView: NSView!
    
    @IBOutlet weak var kanaTextField: NSTextField!
    @IBOutlet weak var sentenceTextField: NSTextField!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var chineseTextField: NSTextField!
    @IBOutlet weak var volcabularyTextField: NSTextField!
    @IBOutlet weak var sentence_chineseTextField: NSTextField!
    
    var timer = Timer()
    static var FunctionChoice: String = "VolcabularyView"
    
    @objc dynamic var Volcabularies: [Volcabulary] = [Volcabulary(volcabulary: "ああ", kana: "ああ", chinese: "啊、哎呀", type: "感", sentence: "ああ、そうですが", sentence_chinese: "阿！是嗎！")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        scheduledTimerWithTimeInterval()
        addvocabularyView.isHidden = true
    }
    
    
    // MARK: - 單字
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        //NSLog("counting..")
        if FunctionsViewController.FunctionChoice == "VolcabularyView"
        {
            volcabularyview.isHidden = false
            addvocabularyView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "AddVolcabularyView"
        {
            volcabularyview.isHidden = true
            addvocabularyView.isHidden = false
        }
        else
        {
            volcabularyview.isHidden = true
            addvocabularyView.isHidden = true
        }
    }
    
    // MARK: - 新增單字
    @IBAction func addButton(_ sender: Any) {
        let kana = kanaTextField.stringValue
        let sentence = sentenceTextField.stringValue
        let type = typeTextField.stringValue
        let chinese = chineseTextField.stringValue
        let volcabulary = volcabularyTextField.stringValue
        let sentence_chinese = sentence_chineseTextField.stringValue
        if kana != "" && sentence != "" && type != "" && chinese != "" && volcabulary != "" && sentence_chinese != ""
        {
            Volcabularies.append(contentsOf: [Volcabulary(volcabulary: volcabulary, kana: kana, chinese: chinese, type: type, sentence: sentence, sentence_chinese: sentence_chinese)] as [Volcabulary])
        }
        else
        {
            performSegue(withIdentifier: "AddVolcabularyError", sender: self)
        }
    }
}
