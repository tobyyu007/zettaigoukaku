//
//  CrawVolcabularyViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/9.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: 從 MOJi 辭書爬蟲 view controller
//
//  Need to install Cocoapods Alamofire package: https://github.com/Alamofire/Alamofire
//  Need to install Cocoapods Kanna package: https://github.com/tid-kijyun/Kanna
//  Reference to WebKit Javascript: https://stackoverflow.com/a/56180664
//  Reference to WebKit didFinish: https://stackoverflow.com/questions/25504481/wkwebview-content-loaded-function-never-get-called
//  Reference to Webcrawing on swift: https://medium.com/@wolfsky95/ios-swift-網路爬蟲程式應用-國內銀樓金價-c0864f8b3136
//                                    https://medium.com/@willard1218/使用-swift-寫爬蟲-以-104-網站為例-ccecdab3fee2



import Cocoa
import WebKit
import Alamofire
import Kanna

struct volcabularyData
{
    var volcabulary = ""
    var kana: String = ""
    var type = [String]()
    var japaneseDefenition = [String]()
    var chineseDefenition = [String]()
    var sentence = [String]()
    var sentence_chinese = [String]()
}

extension String {
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, count)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
}

class CrawVolcabularyViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var crawVolcabularyWebView: WKWebView!
    
    static var VD = volcabularyData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        preferredContentSize = view.frame.size // 防止大小調整
        if let url = URL(string: "https://www.mojidict.com") {
            crawVolcabularyWebView.load(URLRequest(url: url))
        }
        crawVolcabularyWebView.navigationDelegate = self
        crawVolcabularyWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil) // 偵測頁面改變
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 完成載入頁面
        let javascriptString = "var scrollingElement = (document.scrollingElement || document.body);" +
                                "scrollingElement.scrollTop = scrollingElement.scrollHeight;"
        // 將頁面滑到底部
        crawVolcabularyWebView.evaluateJavaScript(javascriptString){ (value, error) in
            if let err = error {
                print(err)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 偵測頁面改變
        if let key = change?[NSKeyValueChangeKey.newKey] {
            //print("observeValue \(key)") // url value
            crawData(webURL: String(describing: key))
            addVolcabularyViewController.progress = 10 // stringValue: 頁面載入中
            addVolcabularyViewController.webViewEnd = true
            self.dismiss(CrawVolcabularyViewController.self) // 輸入完單字後就關閉 webView 視窗
        }
    }
    
    func crawData(webURL: String)
    {
        AF.request(webURL).responseString{ response in
            if let html = response.value{
                addVolcabularyViewController.progress = 20 // stringValue: 抓取資料中
                self.parsehtml(html)
                //print(html)
            }
        }
    }
    
    func parsehtml(_ html1: String)
    {
        let doc = try? Kanna.HTML(html: html1, encoding:.utf8)
        
        // 日文單字
        for volcabulary in doc!.xpath("/html/body/div/div/div/div[2]/div[1]/div[1]/h3/span")
        {
            print(volcabulary.text!)
            CrawVolcabularyViewController.VD.volcabulary = volcabulary.text!
        }
        
        // 日文假名
        for kana in doc!.xpath("//div[@class='pron jp-font']")
        {
            // 只接受日文，去除其他的特殊符號
            let matched = kana.text!.filter { !$0.isWhitespace }.match("/[一-龠]+|[ぁ-ゔ]+|[ァ-ヴー]+|[a-zA-Z0-9]+|[ａ-ｚＡ-Ｚ０-９]+|[々〆〤]+/u")
            print(matched[0][0])
            CrawVolcabularyViewController.VD.kana = matched[0][0]
        }
        
        // 類型
        var resultString = String((doc?.head?.toHTML)!)
        resultString = resultString.components(separatedBy: "content=\"[")[1]  // 從 HTML head 剪出資訊
        resultString = resultString.components(separatedBy: "]")[0].traditionalize // 簡轉繁
        CrawVolcabularyViewController.VD.type = resultString.components(separatedBy: "·")
        print(CrawVolcabularyViewController.VD.type)
        
        // 日文、中文解釋
        var japaneseDefinitionResult = [String]()
        var chineseDefinitionResult = [String]()
        for definition in doc!.xpath("//div[@class='subdetail']")
        {
            let definitionString = String(describing: definition.text!)
            if definitionString.contains("（") // 正常情況，有中文解釋和日文解釋
            {
                var definitionChinese = definitionString.components(separatedBy: "（")[0]
                definitionChinese = definitionChinese.replacingOccurrences(of: "。", with: "")
                chineseDefinitionResult.append(definitionChinese.traditionalize) // 簡轉繁
                let definitionJapanese = definitionString.components(separatedBy: "（")[1]
                japaneseDefinitionResult.append(definitionJapanese.components(separatedBy: "）")[0])
            }
            else // 沒有日文解釋 ex: 半ば - 惯用语
            {
                chineseDefinitionResult.append(definitionString.traditionalize) // 簡轉繁
                japaneseDefinitionResult.append("")
            }
        }
        CrawVolcabularyViewController.VD.chineseDefenition = chineseDefinitionResult
        CrawVolcabularyViewController.VD.japaneseDefenition = japaneseDefinitionResult
        print(japaneseDefinitionResult)
        print(chineseDefinitionResult)
        
        // 日文例句
        var sentenceResult = [String]()
        for sentences in doc!.xpath("//div[/html/body/div/div/div/div[2]/div[1]/div[2]/div/div[2]/div[1]/div[1]/div[2]/div/div/p[1]/span]/div/div/p[1]/span")
        {
            if sentences.text!.contains("。")
            {
                let sentenceSeperated = sentences.text!.components(separatedBy: "。")[0]
                sentenceResult.append(sentenceSeperated)
            }
            else
            {
                sentenceResult.append(sentences.text!)
            }
        }
        CrawVolcabularyViewController.VD.sentence = sentenceResult
        print(sentenceResult)
        
        // 中文例句
        var chineseSentenceResult = [String]()
        for chineseSentences in doc!.xpath("//div[/html/body/div/div/div/div[2]/div[1]/div[2]/div/div[2]/div[1]/div[1]/div[2]/div/div/p[1]/span]/div/div/p[2]/span")
        {
            if chineseSentences.text!.contains("。")
            {
                let chineseSentenceSeperated = chineseSentences.text!.components(separatedBy: "。")[0].traditionalize
                chineseSentenceResult.append(chineseSentenceSeperated)
            }
            else
            {
                chineseSentenceResult.append(chineseSentences.text!.traditionalize)
            }
        }
        CrawVolcabularyViewController.VD.sentence_chinese = chineseSentenceResult
        addVolcabularyViewController.progress = 30 // stringValue: 抓取完成
        print(chineseSentenceResult)
    }
    
    @IBAction func cancel(_ sender: Any) {
        // "取消" 按鍵
        self.dismiss(CrawVolcabularyViewController.self)
        addVolcabularyViewController.webViewEnd = true
        addVolcabularyViewController.progress = -1
    }
}
