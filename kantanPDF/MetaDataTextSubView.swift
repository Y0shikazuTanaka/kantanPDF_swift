//
//  MetaDataTextSubView.swift
//  kantanPDF
//
//  Created by 田中智子 on 2017/02/05.
//  Copyright © 2017年 田中智子. All rights reserved.
//

import Cocoa


/// MetaDataTextSubViewDelegate
protocol MetaDataTextSubViewDelegate: class {
    func didEditText(text: String, identifer: String?, chkBoxSts: CheckBoxStatus)
}

class MetaDataTextSubView: NSStackView, NSTextFieldDelegate {

    weak open var textSubViewDelegate: MetaDataTextSubViewDelegate?
    @IBOutlet weak var titleLbl: NSTextField!
    @IBOutlet weak var textDataField: NSTextField!
    @IBOutlet weak var checkBox: NSButton!
    
    /// draw
    ///
    /// - Parameter dirtyRect: NSRect
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
    /// view項目を初期化
    func initViewItem() {
        textDataField.isEnabled = true
        checkBox.isEnabled = true
        textDataField.stringValue = String()
        checkBox.isHidden = true
        checkBox.state = NSOffState
    }
    
    /// 全項目非活性
    func allItemDesable() {
        textDataField.stringValue = String()
        textDataField.isEnabled = false
        checkBox.isHidden = true
        checkBox.isEnabled = false
    }
    
    /// データセットメソッド
    ///
    /// - Parameters:
    ///   - text: テキストフィールドテキスト
    ///   - checkSts: チェックボックスステータス
    func setData(text: String, checkSts: CheckBoxStatus) {
        textDataField.stringValue = text
        switch checkSts {
        case CheckBoxStatus.Hidden:
            checkBox.isHidden = true
            checkBox.state = NSOffState
        case CheckBoxStatus.NoSelected:
            checkBox.isHidden = false
            checkBox.state = NSOffState
        case CheckBoxStatus.Selected:
            checkBox.isHidden = false
            checkBox.state = NSOnState
        }
    }
    
    // MARK: NSTextFieldDelegate->NSControlTextEditingDelegate
    /// 編集開始時
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        if !checkBox.isHidden {
            checkBox.state = NSOnState
        }
        return true
    }
    
    /// 編集終了時
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        textSubViewDelegate?.didEditText(text: fieldEditor.string!, identifer: self.identifier, chkBoxSts: checkBox.isHidden == true ? CheckBoxStatus.Hidden : checkBox.state == NSOnState ? CheckBoxStatus.Selected : CheckBoxStatus.NoSelected)
        return true
    }
}
