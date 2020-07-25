//
//  FunctionDetailsViewController.swift
//  Volcabulary
//
//  Created by Toby on 2020/7/3.
//  Copyright © 2020 Toby. All rights reserved.
//  Main usage: 主視窗右方 view controller 總管
//  Volcabulary data folder: /Users/toby/Library/Containers/Toby.zettaigoukaku/Data/Documents/Volcabularies
//  Reference of TableView: https://www.youtube.com/watch?v=VfVYX7nO9dQ
//  Reference of Right click menu: https://stackoverflow.com/questions/6186961/cocoa-how-to-have-a-context-menu-when-you-right-click-on-a-cell-of-nstableview
//  Reference of iconset: https://iconmonstr.com
//  Reference of SwifyJSON: https://github.com/SwiftyJSON/SwiftyJSON
//  Reference of saving struct array to JSON: https://stackoverflow.com/a/37757022


import Cocoa
import WebKit
import SwiftyJSON

class Volcabulary: NSObject
{
    @objc dynamic var star: Bool
    @objc dynamic var page: Int
    @objc dynamic var volcabulary: String
    @objc dynamic var kana: String
    @objc dynamic var japaneseDefinition: String
    @objc dynamic var chineseDefinition: String
    @objc dynamic var type: String
    @objc dynamic var sentence: String
    @objc dynamic var sentence_chinese: String
    @objc dynamic var level: String
    
    init(star: Bool, page: Int, volcabulary: String, kana: String, japaneseDefinition: String, chineseDefinition: String, type: String, sentence: String, sentence_chinese: String, level: String)
    {
        self.star = star
        self.page = page
        self.volcabulary = volcabulary
        self.kana = kana
        self.japaneseDefinition = japaneseDefinition
        self.chineseDefinition = chineseDefinition
        self.type = type
        self.sentence = sentence
        self.sentence_chinese = sentence_chinese
        self.level = level
    }
    
    init?(json: JSON)
    {
        guard let star = json["star"].bool,
            let page = json["page"].int,
            let volcabulary = json["volcabulary"].string,
            let kana = json["kana"].string,
            let japaneseDefinition = json["japaneseDefinition"].string,
            let chineseDefinition = json["chineseDefinition"].string,
            let type = json["type"].string,
            let sentence = json["sentence"].string,
            let sentence_chinese = json["sentence_chinese"].string,
            let level = json["level"].string
        else{return nil}
        
        self.star = star
        self.page = page
        self.volcabulary = volcabulary
        self.kana = kana
        self.japaneseDefinition = japaneseDefinition
        self.chineseDefinition = chineseDefinition
        self.type = type
        self.sentence = sentence
        self.sentence_chinese = sentence_chinese
        self.level = level
    }
    
    var asJSON: JSON {
        var json: JSON = [:]
        json["star"].bool = star
        json["page"].int = page
        json["volcabulary"].string = volcabulary
        json["kana"].string = kana
        json["japaneseDefinition"].string = japaneseDefinition
        json["chineseDefinition"].string = chineseDefinition
        json["type"].string = type
        json["sentence"].string = sentence
        json["sentence_chinese"].string = sentence_chinese
        json["level"].string = level
        return json
    }
}


class FunctionsViewController: NSViewController{

    @IBOutlet weak var volcabularyview: NSView!
    @IBOutlet weak var volcabularyTableView: NSTableView!
    @IBOutlet var functionsView: NSView!
    @IBOutlet weak var addVolcabulary: NSView!
    @IBOutlet weak var learnView: NSView!
    @IBOutlet weak var testView: NSView!
    
    var timer = Timer()
    static var FunctionChoice: String = "VolcabularyView"
    
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Volcabularies")
    var isDirectory: ObjCBool = false
    
    @objc dynamic var Volcabularies = [Volcabulary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        scheduledTimerWithTimeInterval()
        addVolcabulary.isHidden = true
        
        // 如果沒有 Volcabulary 資料夾，新增一個
        do
        {
            try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        // 檢查資料夾內有沒有單字
        let enumerator = FileManager.default.enumerator(atPath: fileURL.path)
        let filePaths = enumerator!.allObjects as! [String]
        let jsonFilePaths = filePaths.filter{$0.contains(".json")}
        if jsonFilePaths.count > 0 // 已經有單字
        {
            // 將所有單字讀進 Volcabularies array
            for jsonFilePath in jsonFilePaths
            {
                if jsonFilePath != ".DS_Store"
                {
                    do
                    {
                        let fullPath = fileURL.path + "/" + jsonFilePath
                        let data = try Data(contentsOf: URL(fileURLWithPath: fullPath))
                        let dataJSON = try JSON(data: data)
                        let newVolcabulary = Volcabulary(json: dataJSON)! as Volcabulary
                        Volcabularies.append(newVolcabulary)
                    }
                    catch let error as NSError
                    {
                        NSLog("Unable to open JSON file \(error.debugDescription)")
                    }
                }
            }
        }
        else // 目前沒有單字資料
        {
            // 初始化資料
            Volcabularies.append(contentsOf: [Volcabulary(star: true,
                                                        page: 1,
                                                        volcabulary: "ああ",
                                                        kana: "ああ",
                                                        japaneseDefinition: "肯定",
                                                        chineseDefinition: "啊、哎呀",
                                                        type: "他五",
                                                        sentence: "ああ、そうですが",
                                                        sentence_chinese: "阿！是嗎！",
                                                        level: "N5")])

            saveFile(volcabulary: Volcabularies[0], name: Volcabularies[0].volcabulary)
        }
        
        let volcabularyTableMenu = NSMenu()  // 在 tabelView 新增 menu
        volcabularyTableMenu.addItem(NSMenuItem(title: "新增", action: #selector(tableViewAddItemClicked(_:)), keyEquivalent: ""))
        volcabularyTableMenu.addItem(NSMenuItem(title: "編輯", action: #selector(tableViewEditItemClicked(_:)), keyEquivalent: ""))
        volcabularyTableMenu.addItem(NSMenuItem(title: "刪除", action: #selector(tableViewDeleteItemClicked(_:)), keyEquivalent: ""))
        volcabularyTableView.menu = volcabularyTableMenu
    }
    
    func saveFile(volcabulary: Volcabulary, name: String)
    {
        // 新增 json 檔案到 Volcabulary 資料夾，使用單字名稱儲存
        do {
            let data = try! volcabulary.asJSON.rawData()
            let volcabularyNameURL = fileURL.appendingPathComponent(name + ".json")
            let created = FileManager.default.createFile(atPath: volcabularyNameURL.path, contents: nil, attributes: nil)
            if created
            {
                let file = try FileHandle(forWritingTo: volcabularyNameURL)
                file.write(data as Data)
                print("JSON data was written to the file successfully!")
            }
            else
            {
                print("can't create file")
            }
        } catch let error as NSError {
            print("Couldn't write file: \(error.localizedDescription)")
        }
    }
    
    func deleteFile(name: String)
    {
        // 刪除單字 json 檔案
        let fileManager = FileManager.default
        let fullPath = fileURL.path + "/" + name + ".json"
        
        do
        {
            try fileManager.removeItem(atPath: fullPath)
        }
        catch let error as NSError
        {
            print("Couldn't delete file: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 單字功能
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @IBAction func starCheckBox(_ sender: NSButton) {
        // 列表中標記 checkbox 隨時可更新
        let index = volcabularyTableView.row(for: sender)
        print(index)
        if sender.state == .on
        {
            Volcabularies[index].star = true
        }
        else if sender.state == .off
        {
            Volcabularies[index].star = false
        }
    }
    
    
    @objc func updateCounting()  // 0.1 秒跑一次
    {
        // 選單改變，顯示或隱藏 view
        if FunctionsViewController.FunctionChoice == "VolcabularyView"
        {
            // 單字
            volcabularyview.isHidden = false
            addVolcabulary.isHidden = true
            learnView.isHidden = true
            testView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "AddVolcabularyView"
        {
            // 新增單字
            volcabularyview.isHidden = true
            addVolcabulary.isHidden = false
            learnView.isHidden = true
            testView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "LearnView"
        {
            // 學習
            volcabularyview.isHidden = true
            addVolcabulary.isHidden = true
            learnView.isHidden = false
            testView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "TestView"
        {
            // 測驗
            volcabularyview.isHidden = true
            addVolcabulary.isHidden = true
            learnView.isHidden = true
            testView.isHidden = false
        }
        else
        {
            volcabularyview.isHidden = true
            addVolcabulary.isHidden = true
            learnView.isHidden = true
            testView.isHidden = true
        }
    
        // 從 menu 編輯回來改變
        if MenuAddVolcabularyViewController.editing  // 修改
        {
            // 先刪除檔案
            deleteFile(name: Volcabularies[MenuAddVolcabularyViewController.selectedIndex].volcabulary)
            
            // 再新增檔案
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].volcabulary = MenuAddVolcabularyViewController.volcabulary
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].kana = MenuAddVolcabularyViewController.kana
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].japaneseDefinition = MenuAddVolcabularyViewController.japaneseDescription
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].chineseDefinition = MenuAddVolcabularyViewController.chineseDescription
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].type = MenuAddVolcabularyViewController.type
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].sentence = MenuAddVolcabularyViewController.sentence
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].sentence_chinese = MenuAddVolcabularyViewController.sentence_chinese
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].star = MenuAddVolcabularyViewController.star
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].page = MenuAddVolcabularyViewController.page
            Volcabularies[MenuAddVolcabularyViewController.selectedIndex].level = MenuAddVolcabularyViewController.level
            
            // 存檔
            saveFile(volcabulary: Volcabularies[MenuAddVolcabularyViewController.selectedIndex], name: Volcabularies[MenuAddVolcabularyViewController.selectedIndex].volcabulary)
            
            MenuAddVolcabularyViewController.selectedIndex = -1
            MenuAddVolcabularyViewController.editing = false
        }
            
        // menu 新增
        else if MenuAddVolcabularyViewController.adding
        {
            Volcabularies.append(contentsOf: [Volcabulary(star: MenuAddVolcabularyViewController.star,
                                                          page: MenuAddVolcabularyViewController.page,
                                                          volcabulary: MenuAddVolcabularyViewController.volcabulary,
                                                          kana: MenuAddVolcabularyViewController.kana,
                                                          japaneseDefinition: MenuAddVolcabularyViewController.japaneseDescription,
                                                          chineseDefinition: MenuAddVolcabularyViewController.chineseDescription,
                                                          type: MenuAddVolcabularyViewController.type,
                                                          sentence: MenuAddVolcabularyViewController.sentence,
                                                          sentence_chinese: MenuAddVolcabularyViewController.sentence_chinese,
                                                          level: MenuAddVolcabularyViewController.level)] as [Volcabulary])
            
            // 存檔
            saveFile(volcabulary: Volcabularies[Volcabularies.count-1], name: Volcabularies[Volcabularies.count-1].volcabulary)
            
            MenuAddVolcabularyViewController.adding = false
        }
        
        // 從 "新增單字" 頁面新增
        if addVolcabularyViewController.volcabularyAdded == true
        {
            Volcabularies.append(contentsOf: [Volcabulary(star: addVolcabularyViewController.star,
                                                            page: addVolcabularyViewController.page,
                                                            volcabulary: addVolcabularyViewController.volcabulary,
                                                            kana: addVolcabularyViewController.kana,
                                                            japaneseDefinition: addVolcabularyViewController.japaneseDefinition,
                                                            chineseDefinition: addVolcabularyViewController.chineseDefinition,
                                                            type: addVolcabularyViewController.type,
                                                            sentence: addVolcabularyViewController.sentence,
                                                            sentence_chinese: addVolcabularyViewController.sentenceChinese,
                                                            level: addVolcabularyViewController.level)] as [Volcabulary])
            
            // 存檔
            saveFile(volcabulary: Volcabularies[Volcabularies.count-1], name: Volcabularies[Volcabularies.count-1].volcabulary)
            
            addVolcabularyViewController.volcabularyAdded = false
        }
    }
    
    @objc private func tableViewAddItemClicked(_ sender: AnyObject)  // 按下 menu 新增
    {
        performSegue(withIdentifier: "menuAddVolcabulary", sender: self)  // 跳轉到新增視窗
    }
    
    @objc private func tableViewEditItemClicked(_ sender: AnyObject)  // 按下 menu 編輯
    {
        let index = volcabularyTableView.selectedRow  // 取出選擇的欄位號碼
        if index != -1  // 有選擇項目
        {
            MenuAddVolcabularyViewController.kana = Volcabularies[index].kana
            MenuAddVolcabularyViewController.sentence = Volcabularies[index].sentence
            MenuAddVolcabularyViewController.type = Volcabularies[index].type
            MenuAddVolcabularyViewController.japaneseDescription = Volcabularies[index].japaneseDefinition
            MenuAddVolcabularyViewController.chineseDescription = Volcabularies[index].chineseDefinition
            MenuAddVolcabularyViewController.volcabulary = Volcabularies[index].volcabulary
            MenuAddVolcabularyViewController.sentence_chinese = Volcabularies[index].sentence_chinese
            MenuAddVolcabularyViewController.star = Volcabularies[index].star
            MenuAddVolcabularyViewController.page = Volcabularies[index].page
            MenuAddVolcabularyViewController.level = Volcabularies[index].level
            
            MenuAddVolcabularyViewController.selectedIndex = index
            performSegue(withIdentifier: "menuAddVolcabulary", sender: self)  // 跳轉到編輯視窗
        }
    }

    @objc private func tableViewDeleteItemClicked(_ sender: AnyObject)  // 按下 menu 刪除
    {
        let index = volcabularyTableView.selectedRow  // 取出選擇的欄位號碼
        deleteFile(name: Volcabularies[index].volcabulary) // 刪除檔案
        if index != -1  // 有選擇項目
        {
            Volcabularies.remove(at: index) // 移除 functionList 項目
        }
    }
    
    // MARK: - 新增單字功能
}

extension JSON{
    mutating func appendIfArray(json:JSON){
        if var arr = self.array{
            arr.append(json)
            self = JSON(arr);
        }
    }
    
    mutating func appendIfDictionary(key:String,json:JSON){
        if var dict = self.dictionary{
            dict[key] = json;
            self = JSON(dict);
        }
    }
}
