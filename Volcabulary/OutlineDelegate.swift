//
//  OutlineDelegate.swift
//  OutlineViewReorder
//
//  Created by Toby on 2020/7/2.
//  Copyright © 2020 Toby. All rights reserved.
//  Reference: https://github.com/KinematicSystems/NSOutlineViewReorder

import Cocoa

extension FunctionList: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cell = outlineView.makeView(withIdentifier: convertToNSUserInterfaceItemIdentifier("OutlineColItem"), owner: self) as! OutlineItemView
        
        cell.textField!.delegate = self
        
        if let folderItem = item as? FolderItem
        {
            cell.textField!.stringValue = folderItem.name
            cell.imageView!.image = folderImage
        }
        else if let aItem = item as? TestItem
        {
            cell.textField!.stringValue = aItem.name
            if aItem.name == "單字"
            {
                cell.imageView!.image = vocabularyImage
            }
            else if aItem.name == "新增單字"
            {
                cell.imageView!.image = addvocabularyImage
            }
            else if aItem.name == "測驗"
            {
                cell.imageView!.image = testImage
            }
        }
        
        return cell
    }

//    func outlineView(outlineView: NSOutlineView, shouldExpandItem item: AnyObject) -> Bool {
//        return (draggedNode == nil)
//    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSUserInterfaceItemIdentifier(_ input: String) -> NSUserInterfaceItemIdentifier {
    return NSUserInterfaceItemIdentifier(rawValue: input)
}
