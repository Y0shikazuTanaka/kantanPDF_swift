//
//  MetaDataSelectSubView.swift
//  kantanPDF
//
//  Created by 田中智子 on 2017/02/05.
//  Copyright © 2017年 田中智子. All rights reserved.
//

import Cocoa

enum RadioBtnStatus: Int {
    case NonSelect
    case OkSelect
    case NoSelect
}

/// MetaDataSelectSubViewDelegate
protocol MetaDataSelectSubViewDelegate: class {
    func didEditRadioButton(radioBtnSts: RadioBtnStatus, identifer: String?, chkBoxSts: CheckBoxStatus)
}

class MetaDataSelectSubView: NSStackView {
    weak open var selectSubViewDelegate: MetaDataSelectSubViewDelegate?
    
    @IBOutlet weak var titleLbl: NSTextField!
    @IBOutlet weak var radioOk: NSButton!
    @IBOutlet weak var radioNo: NSButton!
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
        radioOk.isEnabled = true
        radioNo.isEnabled = true
        checkBox.isEnabled = true
        radioOk.state = NSOffState
        radioNo.state = NSOffState
        checkBox.isHidden = true
        checkBox.state = NSOffState
    }

    /// 全項目非活性
    func allItemDesable() {
        radioOk.isEnabled = false
        radioNo.isEnabled = false
        checkBox.isEnabled = false
        checkBox.isHidden = true
        checkBox.state = NSOffState
        radioOk.state = NSOffState
        radioNo.state = NSOffState
    }

    /// radioNoのアクションメソッド
    ///
    /// - Parameter sender: NSButtonインスタンス
    @IBAction func actionRadioNo(sender: NSButton) {
        Swift.print("actionRadioNo")
        radioOk.state = sender.state == NSOnState ? NSOffState : NSOnState
        if !checkBox.isHidden {
            checkBox.state = NSOnState
        }
        
        let state: RadioBtnStatus = sender.state == NSOnState ? .NoSelect : .OkSelect
        selectSubViewDelegate?.didEditRadioButton(radioBtnSts:state , identifer: self.identifier, chkBoxSts: getCheckBoxStatus())
    }
    
    /// radioOkのアクションメソッド
    ///
    /// - Parameter sender: NSButtonインスタンス
    @IBAction func actionRadioOk(sender: NSButton) {
        Swift.print("actionRadioOk")
        radioNo.state = sender.state == NSOnState ? NSOffState : NSOnState
        if !checkBox.isHidden {
            checkBox.state = NSOnState
        }
        
        let state: RadioBtnStatus = sender.state == NSOnState ? .OkSelect : .NoSelect
        selectSubViewDelegate?.didEditRadioButton(radioBtnSts:state , identifer: self.identifier, chkBoxSts: getCheckBoxStatus())
    }
    
    
    /// チェックボックスの状態を取得
    ///
    /// - Returns: CheckBoxStatus
    private func getCheckBoxStatus() -> CheckBoxStatus {
        if checkBox.isHidden == true {
            return .Hidden
        }
        else {
            return checkBox.state == NSOnState ? .Selected : .NoSelected
        }
    }

    /// データセット
    ///
    /// - Parameters:
    ///   - availability: true:可 false:不可
    ///   - checkSts: チェックボックスステータス
    func setData(radioStatus: RadioBtnStatus, checkSts: CheckBoxStatus) {
        
        switch radioStatus {
        case RadioBtnStatus.NonSelect:
            radioOk.state = NSOffState
            radioNo.state = NSOffState
        case RadioBtnStatus.OkSelect:
            radioOk.state = NSOnState
            radioNo.state = NSOffState
        case RadioBtnStatus.NoSelect:
            radioOk.state = NSOffState
            radioNo.state = NSOnState
        }

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

}
