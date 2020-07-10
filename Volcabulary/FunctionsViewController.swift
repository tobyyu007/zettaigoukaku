//
//  FunctionDetailsViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/3.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference of TableView: https://www.youtube.com/watch?v=VfVYX7nO9dQ
//  Refernece of Right click menu: https://stackoverflow.com/questions/6186961/cocoa-how-to-have-a-context-menu-when-you-right-click-on-a-cell-of-nstableview


import Cocoa
import WebKit

class Volcabulary: NSObject
{
    @objc dynamic var star: Bool
    @objc dynamic var page: Int
    @objc dynamic var volcabulary: String
    @objc dynamic var kana: String
    @objc dynamic var chinese: String
    @objc dynamic var type: String
    @objc dynamic var sentence: String
    @objc dynamic var sentence_chinese: String
    @objc dynamic var level: String
    
    init(star: Bool, page: Int, volcabulary: String, kana: String, chinese: String, type: String, sentence: String, sentence_chinese: String, level: String)
    {
        self.star = star
        self.page = page
        self.volcabulary = volcabulary
        self.kana = kana
        self.chinese = chinese
        self.type = type
        self.sentence = sentence
        self.sentence_chinese = sentence_chinese
        self.level = level
    }
}


class FunctionsViewController: NSViewController{

    @IBOutlet weak var volcabularyview: NSView!
    @IBOutlet weak var volcabularyTableView: NSTableView!
    @IBOutlet weak var crawVolcabularyView: NSView!
    @IBOutlet weak var mojiImageView: NSImageView!
    @IBOutlet weak var inputImageView: NSImageView!
    
    
    var timer = Timer()
    static var FunctionChoice: String = "VolcabularyView"
    
    @objc dynamic var Volcabularies: [Volcabulary] = [Volcabulary(star: true,
                                                                  page: 629,
                                                                  volcabulary: "ああ",
                                                                  kana: "ああ",
                                                                  chinese: "啊、哎呀",
                                                                  type: "他五",
                                                                  sentence: "ああ、そうですが",
                                                                  sentence_chinese: "阿！是嗎！",
                                                                  level: "N5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        scheduledTimerWithTimeInterval()
        crawVolcabularyView.isHidden = true
        
        let mojiImage = #imageLiteral(resourceName: "MOJi")
        mojiImage.size = NSSize(width: 150, height: 150)
        mojiImageView.image = mojiImage
        let inputImage = NSImage(named: "NSUser")
        inputImage?.size = NSSize(width: 150, height: 140)
        inputImageView.image = inputImage
        
        let volcabularyTableMenu = NSMenu()  // 在 tabelView 新增 menu
        volcabularyTableMenu.addItem(NSMenuItem(title: "新增", action: #selector(tableViewAddItemClicked(_:)), keyEquivalent: ""))
        volcabularyTableMenu.addItem(NSMenuItem(title: "編輯", action: #selector(tableViewEditItemClicked(_:)), keyEquivalent: ""))
        volcabularyTableMenu.addItem(NSMenuItem(title: "刪除", action: #selector(tableViewDeleteItemClicked(_:)), keyEquivalent: ""))
        volcabularyTableView.menu = volcabularyTableMenu
    }
    
    
    // MARK: - 單字功能
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting()  // 0.1 秒跑一次
    {
        // 選單改變
        if FunctionsViewController.FunctionChoice == "VolcabularyView"
        {
            volcabularyview.isHidden = false
            crawVolcabularyView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "AddVolcabularyView"
        {
            volcabularyview.isHidden = true
            crawVolcabularyView.isHidden = false
        }
        else
        {
            volcabularyview.isHidden = true
            crawVolcabularyView.isHidden = true
        }
        
        // 從 menu 編輯回來改變
        if MenuAddVolcabularyViewController.editing  // 修改
        {
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].volcabulary = MenuAddVolcabularyViewController.volcabulary
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].kana = MenuAddVolcabularyViewController.kana
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].chinese = MenuAddVolcabularyViewController.chinese
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].type = MenuAddVolcabularyViewController.type
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].sentence = MenuAddVolcabularyViewController.sentence
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].sentence_chinese = MenuAddVolcabularyViewController.sentence_chinese
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].star = MenuAddVolcabularyViewController.star
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].page = MenuAddVolcabularyViewController.page
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].level = MenuAddVolcabularyViewController.level
            
            MenuAddVolcabularyViewController.selectedIndex = -1
            MenuAddVolcabularyViewController.editing = false
        }
        else if MenuAddVolcabularyViewController.adding  // 新增
        {
            Volcabularies.append(contentsOf: [Volcabulary(star: MenuAddVolcabularyViewController.star,
                                                          page: MenuAddVolcabularyViewController.page,
                                                          volcabulary: MenuAddVolcabularyViewController.volcabulary,
                                                          kana: MenuAddVolcabularyViewController.kana,
                                                          chinese: MenuAddVolcabularyViewController.chinese,
                                                          type: MenuAddVolcabularyViewController.type,
                                                          sentence: MenuAddVolcabularyViewController.sentence,
                                                          sentence_chinese: MenuAddVolcabularyViewController.sentence_chinese,
                                                          level: MenuAddVolcabularyViewController.level)] as [Volcabulary])
            
            MenuAddVolcabularyViewController.adding = false
        }
    }
    
    @objc private func tableViewAddItemClicked(_ sender: AnyObject)  // menu 新增
    {
        performSegue(withIdentifier: "menuAddVolcabulary", sender: self)  // 跳轉到新增視窗
    }
    
    @objc private func tableViewEditItemClicked(_ sender: AnyObject)  // menu 編輯
    {
        let index = volcabularyTableView.selectedRow  // 取出選擇的欄位號碼
        if index != -1  // 有選擇項目
        {
            MenuAddVolcabularyViewController.kana = Volcabularies[index].kana
            MenuAddVolcabularyViewController.sentence = Volcabularies[index].sentence
            MenuAddVolcabularyViewController.type = Volcabularies[index].type
            MenuAddVolcabularyViewController.chinese = Volcabularies[index].chinese
            MenuAddVolcabularyViewController.volcabulary = Volcabularies[index].volcabulary
            MenuAddVolcabularyViewController.sentence_chinese = Volcabularies[index].sentence_chinese
            MenuAddVolcabularyViewController.star = Volcabularies[index].star
            MenuAddVolcabularyViewController.page = Volcabularies[index].page
            MenuAddVolcabularyViewController.level = Volcabularies[index].level
            
            MenuAddVolcabularyViewController.selectedIndex = index
            performSegue(withIdentifier: "menuAddVolcabulary", sender: self)  // 跳轉到編輯視窗
        }
    }

    @objc private func tableViewDeleteItemClicked(_ sender: AnyObject)  // menu 刪除
    {
        let index = volcabularyTableView.selectedRow  // 取出選擇的欄位號碼
        if index != -1  // 有選擇項目
        {
            Volcabularies.remove(at: index)
        }
    }
    
    
    
    // MARK: - 新增單字功能
}

