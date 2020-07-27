<span align="center">

# 絶対合格

</span>
<span align="center">
<img src="https://theyus.asuscomm.com/JJY/zettaigoukaku.png" align="center">
</span>

## 功能
- 管理單字
- 從 [MOJi 辭書](https://www.mojidict.com)輔助輸入單字
- 雲端單字同步

## 系統需求
1. macOS 10.13 以上

## 編譯方法
### 專案用到 CocoaPods，必須安裝才可以使用
#### 使用的 CocoaPods 套件
1. [Alamofire](https://github.com/Alamofire/Alamofire)
2. [Kanna](https://github.com/tid-kijyun/Kanna)
3. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
4. [ZIPFoundation](https://github.com/weichsel/ZIPFoundation)
5. [NMSSH](https://github.com/NMSSH/NMSSH)

## 安裝 CocoaPods 方法
1. 打開 terminal，輸入以下指令安裝
```console
sudo gem install cocoapods
```
2. 在 terminal 中 cd 到專案資料夾
3. 建立專案 Podfile
```console
pod init
```
4. 編輯 Podfile
```console
open Podfile
```
5. 加入專案所需要的套件
```console
pod 'Alamofire', '~> 5.2'
pod 'Kanna', '~> 5.2.2'
pod 'SwiftyJSON', '~> 4.0'
pod 'NMSSH'
pod 'ZIPFoundation', '~> 0.9'
```
6. 安裝套件
```console
pod install
```
7. 使用 xcworkspace 檔開啟專案
