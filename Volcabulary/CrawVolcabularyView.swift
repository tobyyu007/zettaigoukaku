//
//  CrawVolcabularyView.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/9.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference to WebKit Javascript: https://stackoverflow.com/a/56180664
//  Reference to WebKit didFinish: https://stackoverflow.com/questions/25504481/wkwebview-content-loaded-function-never-get-called

import Cocoa
import WebKit

class CrawVolcabularyView: NSView, WKNavigationDelegate{

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // 爬蟲設定
        let source = "document.getElementById('searchbar').value = '不足' ;" // 輸入搜尋欄位的值
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
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
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 完成載入頁面
        print("Finished navigating to url \(String(describing: webView.url))")
        // 模擬在搜尋欄按 "enter" 鍵
        let javascriptString = "const ke = new KeyboardEvent('keydown', {bubbles: true, cancelable: true, keyCode: 13});" +
                                "searchbar.dispatchEvent(ke);"
        webView.evaluateJavaScript(javascriptString){ (value, error) in
            print(value ?? "javascript execution error")
            if let err = error {
                print(err)
            }
        }
    }
}
