//
//  OutlineDataSource.swift
//  OutlineViewReorder
//
//  Created by Toby on 2020/7/2.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference: https://github.com/KinematicSystems/NSOutlineViewReorder


import Cocoa

extension FunctionList: NSOutlineViewDataSource{
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil
        {
            return testData.items.count
        }
        else if let folderItem = item as? FolderItem
        {
            return folderItem.items.count
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil
        {
            return testData.items[index]
        }
        else if let folderItem = item as? FolderItem
        {
            return folderItem.items[index]
        }
        
        return "BAD ITEM"
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item is FolderItem)
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor objectValueForTableColumn: NSTableColumn?, byItem:Any?) -> Any? {
        if let item = byItem as? BaseItem
        {
            return item.name
        }
        
        return "???????"
    }
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSPasteboardPasteboardType(_ input: NSPasteboard.PasteboardType) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSPasteboardPasteboardType(_ input: String) -> NSPasteboard.PasteboardType {
    return NSPasteboard.PasteboardType(rawValue: input)
}
