//
//  TestData.swift
//  OutlineViewReorder
//
//  Created by Toby on 2020/7/2.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference: https://github.com/KinematicSystems/NSOutlineViewReorder


import Foundation

class BaseItem {
    var name:String = ""
    
    func dump()
    {
        print(name)
    }
}

class TestItem: BaseItem {
    override func dump()
    {
        print("Item: ", terminator:"")
        super.dump()
    }
}

class FolderItem: BaseItem {
    var items:[TestItem] = []
    
    override func dump()
    {
        print("Folder: ", terminator:"")
        super.dump()

        for item in items
        {
            print("  ", terminator:"")
            item.dump()
        }
    }
}

class TestData
{
    var items:[BaseItem] = []
    
    init() {
        
        /*
        for i in 1...5
        {
            let item = TestItem()
            item.name = "RootItem.\(i)"
            items.append(item)
        }
        */
        
        // 加入 Funtion List 功能選項
        
        var item = TestItem()
        item.name = "單字"
        items.append(item)
        
        item = TestItem()
        item.name = "新增單字"
        items.append(item)
        
        item = TestItem()
        item.name = "測驗"
        items.append(item)
        
        /*
        for i in 1...5
        {
            let folder = FolderItem()
            folder.name = "Folder.\(i)"
            for j in 1...3
            {
                let item = TestItem()
                item.name = folder.name + ".Child.\(j)"
                folder.items.append(item)
            }

            items.append(folder)
        }
        let folder = FolderItem()
        folder.name = "Empty"
        items.append(folder)
        */
    }
   
    func dump() {
        for item in items
        {
            item.dump()
        }
    }
}
