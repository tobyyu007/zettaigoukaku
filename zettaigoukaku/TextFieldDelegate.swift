//
//  TextFieldDelegate.swift
//  OutlineViewReorder
//
//  Created by Toby on 2020/7/2.
//  Copyright © 2020 Toby. All rights reserved.
//
//  Main usage: FunctionList outline view 調整 (只需要改變有註解的地方)
//
//  Reference: https://github.com/KinematicSystems/NSOutlineViewReorder


import Cocoa

extension FunctionList: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        //printDebug("text edit end \(obj.debugDescription)");
        let textField = obj.object as! NSTextField
        let row = theOutline.row(for: textField)
        let item = theOutline.item(atRow: row)
        
        let newName:String = textField.stringValue
        
        if let theItem = item as? BaseItem
        {
            theItem.name = newName
        }
    }
}
