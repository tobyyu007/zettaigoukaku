//
//  OutlineDelegate.swift
//  OutlineViewReorder
//
//  Created by Toby on 2020/7/2.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: FunctionList outline view 調整 (只需要改變有註解的地方)
//
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
                // 改變 icon
                cell.imageView!.image = vocabularyImage
            }
            else if aItem.name == "新增單字"
            {
                // 改變 icon
                cell.imageView!.image = addvocabularyImage
            }
            else if aItem.name == "學習"
            {
                // 改變 icon
                cell.imageView!.image = learnImage
            }
            else if aItem.name == "測驗"
            {
                // 改變 icon
                cell.imageView!.image = testImage
            }
        }
        
        return cell
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSUserInterfaceItemIdentifier(_ input: String) -> NSUserInterfaceItemIdentifier {
    return NSUserInterfaceItemIdentifier(rawValue: input)
}
