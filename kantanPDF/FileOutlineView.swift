//
//  FileOutlineView.swift
//  kantanPDF
//
//  Created by 田中智子 on 2017/02/15.
//  Copyright © 2017年 田中智子. All rights reserved.
//

import Cocoa

protocol FileOutlineViewDelegate: NSOutlineViewDelegate  {
   func deleteKyeDown()
}

class FileOutlineView: NSOutlineView {
    private weak var fovDelegate: FileOutlineViewDelegate?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
            fovDelegate = super.delegate as! FileOutlineViewDelegate?
            fovDelegate?.deleteKyeDown()
            return
            
        }
        super.keyDown(with: event)
    }
    
}
