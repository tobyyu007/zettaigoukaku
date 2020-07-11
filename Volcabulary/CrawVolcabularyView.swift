//
//  CrawVolcabularyView.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/9.
//  Copyright © 2020 Toby. All rights reserved.
//  Need to install Cocoapods Alamfire package: https://github.com/Alamofire/Alamofire
//  Need to install Cocoapods Kanna package: https://github.com/tid-kijyun/Kanna
//  Reference to WebKit Javascript: https://stackoverflow.com/a/56180664
//  Reference to WebKit didFinish: https://stackoverflow.com/questions/25504481/wkwebview-content-loaded-function-never-get-called

//  This class is deprecated due to unsuccessful search in MOJi


import Cocoa
import WebKit
import Alamofire
import Kanna

struct volcabularyDataOld
{
    var kana: String = ""
    var chinese: String = ""
    var type: String = ""
    var sentence: String = ""
    var sentence_chinese: String = ""
}

class CrawVolcabularyView: WKWebView, WKNavigationDelegate{

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // 爬蟲設定
        // 無法成功自動輸入跳轉到搜尋頁面 (原因：手動輸入後會轉換到內建的字典數值，引導到他的網頁)
        /*
        let source = "document.getElementById('searchbar').value = '不足';" // 輸入搜尋欄位的值 (可以輸入到搜尋欄)
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let userContentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        self.addSubview(webView)
        

        [webView.topAnchor.constraint(equalTo: self.topAnchor),
         webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
         webView.leftAnchor.constraint(equalTo: self.leftAnchor),
         webView.rightAnchor.constraint(equalTo: self.rightAnchor)].forEach  { anchor in
            anchor.isActive = true
        }

        if let url = URL(string: "https://www.mojidict.com") {
            webView.load(URLRequest(url: url))
        }
        // 爬蟲設定 end
        */
        
        
        //webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil) // 偵測頁面改變
    }
    
    /*
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 完成載入頁面
        // print("Finished navigating to url \(String(describing: webView.url))")
        // 模擬在搜尋欄按 "enter" 鍵 (可以成功按按鍵)
        // 因為無法成功模擬輸入，暫停按 "enter" 鍵功能
        /*
        let javascriptString = "document.getElementById('searchbar').value = '不足';" +
                                "if (document.getElementById('searchbar').value == '不足'){" +
                                "const ke = new KeyboardEvent('keydown', {bubbles: true, cancelable: true, keyCode: 13});" +
                                "searchbar.dispatchEvent(ke);}"
        
        webView.evaluateJavaScript(javascriptString){ (value, error) in
            print(value ?? "javascript execution error")
            if let err = error {
                print(err)
            }
        }
        */
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 偵測頁面改變
        if let key = change?[NSKeyValueChangeKey.newKey] {
            // print("observeValue \(key)") // url value
            crawData(webURL: String(describing: key))
        }
    }
    */
}
