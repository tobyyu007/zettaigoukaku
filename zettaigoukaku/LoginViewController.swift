//
//  ViewController.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/7/1.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: 登入視窗 view controller，同步使用者 volcabulary 資料
//
//  Reference of NMSSH: https://github.com/NMSSH/NMSSH
//  Reference of ZIPFoundation: https://github.com/weichsel/ZIPFoundation
//

import Cocoa
import SwiftUI
import NMSSH
import ZIPFoundation

class LoginViewController: NSViewController {

    @IBOutlet weak var accountTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var rememberAccountCheckBox: NSButton!
    
    @IBOutlet weak var loginView: NSVisualEffectView!
    @IBOutlet weak var syncView: NSVisualEffectView!
    @IBOutlet weak var processIndicator: NSProgressIndicator!
    
    let userDefault = UserDefaults()
    static var userName = ""
    
    @IBAction func loginButton(_ sender: Any) {
        // 跳轉到主視窗
        if accountTextField.stringValue == "toby" && passwordTextField.stringValue == "1234" || accountTextField.stringValue == "yue" && passwordTextField.stringValue == "1234"
        {
            loginView.isHidden = true
            syncView.isHidden = false
            processIndicator.startAnimation(nil)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                // 等待 view 改為正在同步畫面
                // 這邊是特殊寫法，沒有寫等待秒數，可是可以達到效果
                if self.rememberAccountCheckBox.state == .on
                {
                    // 將帳號密碼記在 userDefault 裡面
                    self.userDefault.setValue(self.accountTextField.stringValue, forKey: "account")
                    self.userDefault.setValue(self.passwordTextField.stringValue, forKey: "password")
                }
                LoginViewController.userName = self.accountTextField.stringValue // 紀錄使用者名稱讓其他 view controller 使用
                self.createUserDirectory()
                self.connectToServer()
            }
            
        }
        else // 帳號密碼錯誤
        {
            LoginErrorViewController.errorDescriptionType = "accountError"
            performSegue(withIdentifier: "loginError", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.isHidden = false
        syncView.isHidden = true
        if userDefault.value(forKey: "account") as? String != nil && userDefault.value(forKey: "password") as? String != nil
        {
            // 如果先前有在 userDefault 中紀錄帳號密碼
            accountTextField.stringValue = userDefault.value(forKey: "account") as! String
            passwordTextField.stringValue = userDefault.value(forKey: "password") as! String
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func createUserDirectory()
    {
        // 如果沒有該使用者的資料夾，新增一個
        let userURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("/Users/" + LoginViewController.userName)
        do
        {
            try FileManager.default.createDirectory(atPath: userURL.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    
    func connectToServer()
    {
        // 使用 SFTP 連接伺服器
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("/Users/" + LoginViewController.userName + "/" + LoginViewController.userName + ".zip")
        let session = NMSSHSession(host: "theyus.asuscomm.com:2003", andUsername: "project")
        session.connect()
        if session.isConnected{
            session.authenticate(byPassword: "ZDbkDtJo^rUK")
            if session.isAuthorized{
                let SFTPSession = NMSFTP(session: session)
                SFTPSession.connect() // 重要
                if SFTPSession.isConnected{
                    do{
                        // 下載使用者 zip 檔案 (伺服器檔案路徑：zettaigoukaku/[使用者名稱].zip)
                        try SFTPSession.contents(atPath: "zettaigoukaku/" + LoginViewController.userName + ".zip")?.write(to: fileURL)
                        unzipFile()
                    }
                    catch let error as NSError
                    {
                        print("Couldn't write file: \(error.localizedDescription)")
                    }
                    SFTPSession.disconnect()
                }
            }
            else{
                loginView.isHidden = false
                syncView.isHidden = true
                LoginErrorViewController.errorDescriptionType = "serverError"
                performSegue(withIdentifier: "loginError", sender: self)
                print("can't authenticate SFTP")
            }
        }
        else{
            loginView.isHidden = false
            syncView.isHidden = true
            LoginErrorViewController.errorDescriptionType = "serverError"
            performSegue(withIdentifier: "loginError", sender: self)
            print("can't connect with SFTP")
        }
    }
    
    func unzipFile()
    {
        // 解壓縮下載的檔案
        do
        {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("/Users/" + LoginViewController.userName)
            let enumerator = FileManager.default.enumerator(atPath: fileURL.path)
            let filePaths = enumerator!.allObjects.filter{($0 as AnyObject).contains("Volcabularies")} as! [String]
            if filePaths.count > 0 // 如果已經有該使用者的 Volcabularies 資料夾
            {
                try FileManager.default.removeItem(atPath: fileURL.path + "/" + filePaths[0]) // 刪除現有 Volcabularies 資料夾
                try FileManager().unzipItem(at: fileURL.appendingPathComponent(LoginViewController.userName + ".zip"), to: fileURL) // 解壓縮 zip 檔
            }
            else // 沒有 zip 檔
            {
                try FileManager().unzipItem(at: fileURL.appendingPathComponent(LoginViewController.userName + ".zip"), to: fileURL) // 解壓縮 zip 檔
            }
            
            // 全部登入工作完成
            performSegue(withIdentifier: "LoginToMain", sender: self) // 跳轉到主頁面
            self.view.window?.close()  // 關閉 login 視窗
        }
        catch let error as NSError{
            print("Couldn't unzip file: \(error.localizedDescription)")
        }
    }
}
