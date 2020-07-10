//
//  CrawVolcabularyViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/9.
//  Copyright © 2020 Toby. All rights reserved.
//  Need to install Cocoapods Alamfire package: https://github.com/Alamofire/Alamofire
//  Need to install Cocoapods Kanna package: https://github.com/tid-kijyun/Kanna
//  Reference to WebKit Javascript: https://stackoverflow.com/a/56180664
//  Reference to WebKit didFinish: https://stackoverflow.com/questions/25504481/wkwebview-content-loaded-function-never-get-called
//  Reference to Webcrawing on swift: https://medium.com/@wolfsky95/ios-swift-網路爬蟲程式應用-國內銀樓金價-c0864f8b3136


import Cocoa
import WebKit
import Alamofire
import Kanna

struct volcabularyData
{
    var kana: String = ""
    var chinese: String = ""
    var type: String = ""
    var sentence: String = ""
    var sentence_chinese: String = ""
}

class CrawVolcabularyViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var crawVolcabularyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let url = URL(string: "https://www.mojidict.com") {
            crawVolcabularyWebView.load(URLRequest(url: url))
        }
        crawVolcabularyWebView.navigationDelegate = self
        crawVolcabularyWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil) // 偵測頁面改變
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 完成載入頁面
        print("Finished navigating to url \(String(describing: webView.url))")
        let javascriptString = "var scrollingElement = (document.scrollingElement || document.body);" +
                                "scrollingElement.scrollTop = scrollingElement.scrollHeight;"
        crawVolcabularyWebView.evaluateJavaScript(javascriptString){ (value, error) in
            print(value ?? "javascript execution error")
            if let err = error {
                print(err)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 偵測頁面改變
        if let key = change?[NSKeyValueChangeKey.newKey] {
            print("observeValue \(key)") // url value
            crawData(webURL: String(describing: key))
            self.dismiss(CrawVolcabularyViewController.self)
        }
    }
    
    func crawData(webURL: String)
    {
        AF.request(webURL).responseString{ response in
            if let html = response.value{
                self.parsehtml(html)
            }
        }
    }
    
    func parsehtml(_ html1: String)
    {
        var doc = try? Kanna.HTML(html: html1, encoding:.utf8)
        var VD = volcabularyData()
        
        for data in doc!.xpath("/html/body/div/div/div/div[2]/div[1]/div[2]/div/div[2]/div/div[1]/div[1]/span[1]"){
            print(data.text)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(CrawVolcabularyViewController.self)
    }
}
