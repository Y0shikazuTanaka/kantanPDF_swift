//
//  DropContentView.swift
//  kantanPDF
//
//  Created by 田中智子 on 2016/12/07.
//  Copyright © 2016年 田中智子. All rights reserved.
//

import Cocoa

protocol DropContentViewDelegate {
    func performDragOperation(sender: NSDraggingInfo)
}

class DropContentView: NSView {
    var delegate: DropContentViewDelegate?

    override func awakeFromNib() {
        // ドラッグイベントを有効化
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    /*
     * ドラッグを受け付けるタイプを指定
     * @param NSDraggingInfo
     * @return NSDragOperation 受付タイプ
     */
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.register(forDraggedTypes: [NSFilenamesPboardType])
        return NSDragOperation.generic
    }
    
    /*
     * ドラッグされたときに呼び出される
     * @param NSDraggingInfo
     * @return true:ドラッグ許可 false:ドラッグキャンセル
     */
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        // コントローラーへ通知
        delegate?.performDragOperation(sender: sender)
        return true
    }
    
}
