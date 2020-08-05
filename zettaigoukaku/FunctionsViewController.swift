//
//  FunctionDetailsViewController.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/7/3.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: 主視窗右方 view controller 總管
//  Application data folder: /Users/toby/Library/Containers/Toby.zettaigoukaku/Data/Documents
//  User data folder: /Users/toby/Library/Containers/Toby.zettaigoukaku/Data/Documents/[username]
//
//  Reference of TableView: https://www.youtube.com/watch?v=VfVYX7nO9dQ
//  Reference of Right click menu: https://stackoverflow.com/questions/6186961/cocoa-how-to-have-a-context-menu-when-you-right-click-on-a-cell-of-nstableview
//  Reference of iconset: https://iconmonstr.com
//  Reference of SwifyJSON: https://github.com/SwiftyJSON/SwiftyJSON
//  Reference of saving struct array to JSON: https://stackoverflow.com/a/37757022
//  Reference of NMSSH: https://github.com/NMSSH/NMSSH
//

import Cocoa
import WebKit
import SwiftyJSON
import NMSSH

class VocabularyInstance
{
    var star: Bool
    var page: Int
    var volcabulary: String
    var kana: String
    var japaneseDefinition: String
    var chineseDefinition: String
    var type: String
    var sentence: String
    var sentence_chinese: String
    var level: String
    
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

class zettaigoukaku: NSObject
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
    @IBOutlet weak var addzettaigoukaku: NSView!
    @IBOutlet weak var learnView: NSView!
    @IBOutlet weak var testView: NSView!
    
    var timer = Timer()
    static var FunctionChoice: String = "zettaigoukakuView"
    
    let userURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("/Users/" + LoginViewController.userName)
    let userVolcabulariesURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("/Users/" + LoginViewController.userName + "/Volcabularies")
    var isDirectory: ObjCBool = false
    
    static var saveEnded = false // 表示是否儲存完成，是否可以離開儲存成功頁面
    
    @objc dynamic var Volcabularies = [zettaigoukaku]()
    static var VocabulariesInstance = [VocabularyInstance]()
    
    // MARK: 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        scheduledTimerWithTimeInterval()
        addzettaigoukaku.isHidden = true
        
        // 如果使用者資料夾內沒有 Volcabularies 資料夾，新增一個
        let userVolcabulariesURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("/Users/" + LoginViewController.userName + "/Volcabularies/")
        do
        {
            try FileManager.default.createDirectory(atPath: userVolcabulariesURL.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        // 檢查資料夾內有沒有單字
        let enumerator = FileManager.default.enumerator(atPath: userVolcabulariesURL.path)
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
                        let fullPath = userVolcabulariesURL.path + "/" + jsonFilePath
                        let data = try Data(contentsOf: URL(fileURLWithPath: fullPath))
                        let dataJSON = try JSON(data: data)
                        let newzettaigoukaku = zettaigoukaku(json: dataJSON)! as zettaigoukaku
                        Volcabularies.append(newzettaigoukaku)
                        let newzettaigoukaku2 = VocabularyInstance(json: dataJSON)! as VocabularyInstance
                        FunctionsViewController.VocabulariesInstance.append(newzettaigoukaku2)
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
            Volcabularies.append(contentsOf: [zettaigoukaku(star: true,
                                                        page: 1,
                                                        volcabulary: "ああ",
                                                        kana: "ああ",
                                                        japaneseDefinition: "肯定",
                                                        chineseDefinition: "啊、哎呀",
                                                        type: "他五",
                                                        sentence: "ああ、そうですが",
                                                        sentence_chinese: "阿！是嗎！",
                                                        level: "N5")])
            
            FunctionsViewController.VocabulariesInstance.append(contentsOf: [VocabularyInstance(star: true,
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
    
    // MARK: 自動更新 (View, 資料庫)
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting()  // 0.1 秒跑一次
    {
        // 選單改變，顯示或隱藏 view
        if FunctionsViewController.FunctionChoice == "zettaigoukakuView"
        {
            // 單字
            volcabularyview.isHidden = false
            addzettaigoukaku.isHidden = true
            learnView.isHidden = true
            testView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "AddzettaigoukakuView"
        {
            // 新增單字
            volcabularyview.isHidden = true
            addzettaigoukaku.isHidden = false
            learnView.isHidden = true
            testView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "LearnView"
        {
            // 學習
            volcabularyview.isHidden = true
            addzettaigoukaku.isHidden = true
            learnView.isHidden = false
            testView.isHidden = true
        }
        else if FunctionsViewController.FunctionChoice == "TestView"
        {
            // 測驗
            volcabularyview.isHidden = true
            addzettaigoukaku.isHidden = true
            learnView.isHidden = true
            testView.isHidden = false
        }
        else
        {
            volcabularyview.isHidden = true
            addzettaigoukaku.isHidden = true
            learnView.isHidden = true
            testView.isHidden = true
        }
    
        // 從 "單字" 頁面中 menu 編輯
        if MenuAddzettaigoukakuViewController.editing  // 修改
        {
            // 先刪除檔案
            deleteFile(name: Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].volcabulary)
            deleteFile(name: FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].volcabulary)
            
            // 再修改檔案
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].volcabulary = MenuAddzettaigoukakuViewController.volcabulary
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].kana = MenuAddzettaigoukakuViewController.kana
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].japaneseDefinition = MenuAddzettaigoukakuViewController.japaneseDescription
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].chineseDefinition = MenuAddzettaigoukakuViewController.chineseDescription
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].type = MenuAddzettaigoukakuViewController.type
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].sentence = MenuAddzettaigoukakuViewController.sentence
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].sentence_chinese = MenuAddzettaigoukakuViewController.sentence_chinese
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].star = MenuAddzettaigoukakuViewController.star
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].page = MenuAddzettaigoukakuViewController.page
            Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].level = MenuAddzettaigoukakuViewController.level
            
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].volcabulary = MenuAddzettaigoukakuViewController.volcabulary
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].kana = MenuAddzettaigoukakuViewController.kana
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].japaneseDefinition = MenuAddzettaigoukakuViewController.japaneseDescription
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].chineseDefinition = MenuAddzettaigoukakuViewController.chineseDescription
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].type = MenuAddzettaigoukakuViewController.type
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].sentence = MenuAddzettaigoukakuViewController.sentence
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].sentence_chinese = MenuAddzettaigoukakuViewController.sentence_chinese
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].star = MenuAddzettaigoukakuViewController.star
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].page = MenuAddzettaigoukakuViewController.page
            FunctionsViewController.VocabulariesInstance[MenuAddzettaigoukakuViewController.selectedIndex].level = MenuAddzettaigoukakuViewController.level
            
            // 存檔
            saveFile(volcabulary: Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex], name: Volcabularies[MenuAddzettaigoukakuViewController.selectedIndex].volcabulary)
            
            MenuAddzettaigoukakuViewController.selectedIndex = -1
            MenuAddzettaigoukakuViewController.editing = false
        }
            
        // 從 "單字" 頁面中 menu 新增
        else if MenuAddzettaigoukakuViewController.adding
        {
            Volcabularies.append(contentsOf: [zettaigoukaku(star: MenuAddzettaigoukakuViewController.star,
                                                          page: MenuAddzettaigoukakuViewController.page,
                                                          volcabulary: MenuAddzettaigoukakuViewController.volcabulary,
                                                          kana: MenuAddzettaigoukakuViewController.kana,
                                                          japaneseDefinition: MenuAddzettaigoukakuViewController.japaneseDescription,
                                                          chineseDefinition: MenuAddzettaigoukakuViewController.chineseDescription,
                                                          type: MenuAddzettaigoukakuViewController.type,
                                                          sentence: MenuAddzettaigoukakuViewController.sentence,
                                                          sentence_chinese: MenuAddzettaigoukakuViewController.sentence_chinese,
                                                          level: MenuAddzettaigoukakuViewController.level)] as [zettaigoukaku])
            
            FunctionsViewController.VocabulariesInstance.append(contentsOf: [VocabularyInstance(star: MenuAddzettaigoukakuViewController.star,
                                                            page: MenuAddzettaigoukakuViewController.page,
                                                            volcabulary: MenuAddzettaigoukakuViewController.volcabulary,
                                                            kana: MenuAddzettaigoukakuViewController.kana,
                                                            japaneseDefinition: MenuAddzettaigoukakuViewController.japaneseDescription,
                                                            chineseDefinition: MenuAddzettaigoukakuViewController.chineseDescription,
                                                            type: MenuAddzettaigoukakuViewController.type,
                                                            sentence: MenuAddzettaigoukakuViewController.sentence,
                                                            sentence_chinese: MenuAddzettaigoukakuViewController.sentence_chinese,
                                                            level: MenuAddzettaigoukakuViewController.level)] as [VocabularyInstance])
            
            // 存檔
            saveFile(volcabulary: Volcabularies[Volcabularies.count-1], name: Volcabularies[Volcabularies.count-1].volcabulary)
            
            MenuAddzettaigoukakuViewController.adding = false
        }
        
        // 從 "新增單字" 頁面新增
        if addzettaigoukakuViewController.volcabularyAdded == true
        {
            Volcabularies.append(contentsOf: [zettaigoukaku(star: addzettaigoukakuViewController.star,
                                                            page: addzettaigoukakuViewController.page,
                                                            volcabulary: addzettaigoukakuViewController.volcabulary,
                                                            kana: addzettaigoukakuViewController.kana,
                                                            japaneseDefinition: addzettaigoukakuViewController.japaneseDefinition,
                                                            chineseDefinition: addzettaigoukakuViewController.chineseDefinition,
                                                            type: addzettaigoukakuViewController.type,
                                                            sentence: addzettaigoukakuViewController.sentence,
                                                            sentence_chinese: addzettaigoukakuViewController.sentenceChinese,
                                                            level: addzettaigoukakuViewController.level)] as [zettaigoukaku])
            
            FunctionsViewController.VocabulariesInstance.append(contentsOf: [VocabularyInstance(star: MenuAddzettaigoukakuViewController.star,
                                                                                                page: MenuAddzettaigoukakuViewController.page,
                                                                                                volcabulary: MenuAddzettaigoukakuViewController.volcabulary,
                                                                                                kana: MenuAddzettaigoukakuViewController.kana,
                                                                                                japaneseDefinition: MenuAddzettaigoukakuViewController.japaneseDescription,
                                                                                                chineseDefinition: MenuAddzettaigoukakuViewController.chineseDescription,
                                                                                                type: MenuAddzettaigoukakuViewController.type,
                                                                                                sentence: MenuAddzettaigoukakuViewController.sentence,
                                                                                                sentence_chinese: MenuAddzettaigoukakuViewController.sentence_chinese,
                                                                                                level: MenuAddzettaigoukakuViewController.level)] as [VocabularyInstance])
            
            // 存檔
            saveFile(volcabulary: Volcabularies[Volcabularies.count-1], name: Volcabularies[Volcabularies.count-1].volcabulary)
            addzettaigoukakuViewController.volcabularyAdded = false
            FunctionsViewController.saveEnded = true // 可以關閉 "儲存成功" 視窗
        }
    }
    
    // MARK: 各種檔案處理
    func saveFile(volcabulary: zettaigoukaku, name: String)
    {
        // 新增 json 檔案到 zettaigoukaku 資料夾，使用單字名稱儲存
        do {
            let data = try! volcabulary.asJSON.rawData()
            let volcabularyNameURL = userVolcabulariesURL.appendingPathComponent(name + ".json")
            let created = FileManager.default.createFile(atPath: volcabularyNameURL.path, contents: nil, attributes: nil)
            // 新增空白 json 檔案
            if created
            {
                let file = try FileHandle(forWritingTo: volcabularyNameURL)
                file.write(data as Data) // 寫入
                print("JSON data was written to the file successfully!")
                zipAndUploadFile()
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
        let volcabularyNameURL = userVolcabulariesURL.appendingPathComponent(name + ".json")
        
        do
        {
            try FileManager.default.removeItem(atPath: volcabularyNameURL.path)
            zipAndUploadFile()
        }
        catch let error as NSError
        {
            print("Couldn't delete file: \(error.localizedDescription)")
        }
    }
    
    func zipAndUploadFile()
    {
        // 把 Volcabularies 資料夾 zip 起來
        let volcabularyZIPLocation = userURL.appendingPathComponent(LoginViewController.userName + ".zip")
        do
        {
            let enumerator = FileManager.default.enumerator(atPath: userURL.path)
            let filePaths = enumerator!.allObjects.filter{($0 as AnyObject).contains(LoginViewController.userName + ".zip")} as! [String]
            if filePaths.count > 0 // 如果已經有 zip 檔
            {
                try FileManager.default.removeItem(atPath: userURL.path + "/" + filePaths[0]) // 刪除現有 zip 檔
                try FileManager().zipItem(at: userVolcabulariesURL, to: volcabularyZIPLocation) // 新增 zip 檔
            }
            else // 沒有 zip 檔
            {
                try FileManager().zipItem(at: userVolcabulariesURL, to: volcabularyZIPLocation) // 新增 zip 檔
            }
        }
        catch let error as NSError{
            print("Couldn't zip file: \(error.localizedDescription)")
        }
        
        // 傳送 zip 檔案到伺服器，用 SFTP 連線
        let session = NMSSHSession(host: "theyus.asuscomm.com:2003", andUsername: "project")
        session.connect()
        if session.isConnected{
            session.authenticate(byPassword: "ZDbkDtJo^rUK")
            if session.isAuthorized{
                let SFTPSession = NMSFTP(session: session)
                SFTPSession.connect() // 重要
                if SFTPSession.isConnected{
                    // 上傳 zip 檔案到伺服器 (伺服器檔案路徑：zettaigoukaku/[使用者名稱].zip)
                    SFTPSession.writeFile(atPath: volcabularyZIPLocation.path, toFileAtPath: "zettaigoukaku/" + LoginViewController.userName + ".zip")
                    SFTPSession.disconnect()
                }
            }
            else{
                print("can't authenticate SFTP")
            }
        }
        else{
            print("can't connect with SFTP")
        }
    }
    
    static func isDuplicate(newzettaigoukaku: String) -> Bool
    {
        // 檢查資料夾內有沒有單字
        let pathURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("/Users/" + LoginViewController.userName + "/Volcabularies")
        let enumerator = FileManager.default.enumerator(atPath: pathURL.path)
        let filePaths = enumerator!.allObjects as! [String]
        let jsonFilePaths = filePaths.filter{$0.contains(newzettaigoukaku + ".json")}
        if jsonFilePaths.count > 0 // 已經有該單字
        {
            return true
        }
        else // 目前沒有該單字資料
        {
            return false
        }
    }
    
    // MARK: Button 觸發
    @IBAction func starCheckBox(_ sender: NSButton) {
        // 列表中標記 checkbox 隨時可更新
        let index = volcabularyTableView.row(for: sender)
        print(index)
        if sender.state == .on
        {
            Volcabularies[index].star = true
            FunctionsViewController.VocabulariesInstance[index].star = true
        }
        else if sender.state == .off
        {
            Volcabularies[index].star = false
            FunctionsViewController.VocabulariesInstance[index].star = false
        }
    }
    
    
    @objc private func tableViewAddItemClicked(_ sender: AnyObject)  // 按下 menu 新增
    {
        performSegue(withIdentifier: "menuAddzettaigoukaku", sender: self)  // 跳轉到新增視窗
    }
    
    @objc private func tableViewEditItemClicked(_ sender: AnyObject)  // 按下 menu 編輯
    {
        let index = volcabularyTableView.selectedRow  // 取出選擇的欄位號碼
        if index != -1  // 有選擇項目
        {
            MenuAddzettaigoukakuViewController.kana = Volcabularies[index].kana
            MenuAddzettaigoukakuViewController.sentence = Volcabularies[index].sentence
            MenuAddzettaigoukakuViewController.type = Volcabularies[index].type
            MenuAddzettaigoukakuViewController.japaneseDescription = Volcabularies[index].japaneseDefinition
            MenuAddzettaigoukakuViewController.chineseDescription = Volcabularies[index].chineseDefinition
            MenuAddzettaigoukakuViewController.volcabulary = Volcabularies[index].volcabulary
            MenuAddzettaigoukakuViewController.sentence_chinese = Volcabularies[index].sentence_chinese
            MenuAddzettaigoukakuViewController.star = Volcabularies[index].star
            MenuAddzettaigoukakuViewController.page = Volcabularies[index].page
            MenuAddzettaigoukakuViewController.level = Volcabularies[index].level
            
            MenuAddzettaigoukakuViewController.selectedIndex = index
            performSegue(withIdentifier: "menuAddzettaigoukaku", sender: self)  // 跳轉到編輯視窗
        }
    }

    @objc private func tableViewDeleteItemClicked(_ sender: AnyObject)  // 按下 menu 刪除
    {
        let index = volcabularyTableView.selectedRow  // 取出選擇的欄位號碼
        deleteFile(name: Volcabularies[index].volcabulary) // 刪除檔案
        if index != -1  // 有選擇項目
        {
            Volcabularies.remove(at: index) // 移除 functionList 項目
            FunctionsViewController.VocabulariesInstance.remove(at: index)
        }
    }
}
