//
//  MetaDataSubView.swift
//  kantanPDF
//
//  Created by 田中智子 on 2017/02/08.
//  Copyright © 2017年 田中智子. All rights reserved.
//

import Cocoa

enum SubViewTag: String {
    case FileName
    case Title
    case Auther
    case Creator
    case OwnerPass
    case UserPass
    case Print
    case Copy
}

enum CheckBoxStatus: Int {
    case Hidden
    case NoSelected
    case Selected
}

protocol MetaDataSubViewDelegate: class {
    func didEditText(text: String, identifer: String?, chkBoxSts: CheckBoxStatus)
    func didEditRadioButton(radioBtnSts: RadioBtnStatus, identifer: String?, chkBoxSts: CheckBoxStatus)
}

class MetaDataSubView: NSStackView, MetaDataTextSubViewDelegate, MetaDataSelectSubViewDelegate {
    weak open var dataViewDelegate: MetaDataSubViewDelegate?
    
    @IBOutlet weak var fileNameDatView: MetaDataTextSubView!
    @IBOutlet weak var titleDatView: MetaDataTextSubView!
    @IBOutlet weak var authorDatView: MetaDataTextSubView!
    @IBOutlet weak var creatorDatView: MetaDataTextSubView!
    @IBOutlet weak var ownerPassDatView: MetaDataTextSubView!
    @IBOutlet weak var userPassDatView: MetaDataTextSubView!
    @IBOutlet weak var allowsPrintView: MetaDataSelectSubView!
    @IBOutlet weak var allowsCopyView: MetaDataSelectSubView!
    
    /// view draw
    ///
    /// - Parameter dirtyRect: NSRect
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
    /// view読み込み完了時に呼び出される
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fileNameDatView.identifier = SubViewTag.FileName.rawValue
        fileNameDatView.textSubViewDelegate = self
        titleDatView.identifier = SubViewTag.Title.rawValue
        titleDatView.textSubViewDelegate = self
        authorDatView.identifier = SubViewTag.Auther.rawValue
        authorDatView.textSubViewDelegate = self
        creatorDatView.identifier = SubViewTag.Creator.rawValue
        creatorDatView.textSubViewDelegate = self
        ownerPassDatView.identifier = SubViewTag.OwnerPass.rawValue
        ownerPassDatView.textSubViewDelegate = self
        userPassDatView.identifier = SubViewTag.UserPass.rawValue
        userPassDatView.textSubViewDelegate = self
        allowsPrintView.identifier = SubViewTag.Print.rawValue
        allowsPrintView.selectSubViewDelegate = self
        allowsCopyView.identifier = SubViewTag.Copy.rawValue
        allowsCopyView.selectSubViewDelegate = self

        allItemDesable()
    }
    
    /// view項目を初期化
    func initViewItem() {
        fileNameDatView.initViewItem()
        titleDatView.initViewItem()
        authorDatView.initViewItem()
        creatorDatView.initViewItem()
        ownerPassDatView.initViewItem()
        userPassDatView.initViewItem()
        allowsPrintView.initViewItem()
        allowsCopyView.initViewItem()
    }
    
    /// 全項目非活性
    func allItemDesable() {
        fileNameDatView.allItemDesable()
        titleDatView.allItemDesable()
        authorDatView.allItemDesable()
        creatorDatView.allItemDesable()
        ownerPassDatView.allItemDesable()
        userPassDatView.allItemDesable()
        allowsPrintView.allItemDesable()
        allowsCopyView.allItemDesable()
    }
    
    /// メタデータ編集欄へデータセット
    ///
    /// - Parameter mngDatas: 選択メタデータリスト
    func setMngDats(mngDatas: [PdfMngData]) {
        if mngDatas.isEmpty {
            return
        }
        let mngDat = mngDatas.first

        if mngDatas.count <= 1 {
            fileNameDatView.setData(text: (mngDat?.metaData.fileName)!, checkSts: CheckBoxStatus.Hidden)
            titleDatView.setData(text: (mngDat?.metaData.title)!, checkSts: CheckBoxStatus.Hidden)
            authorDatView.setData(text: (mngDat?.metaData.author)!, checkSts: CheckBoxStatus.Hidden)
            creatorDatView.setData(text: (mngDat?.metaData.creator)!, checkSts: CheckBoxStatus.Hidden)
            ownerPassDatView.setData(text: (mngDat?.metaData.ownerPassword)!, checkSts: CheckBoxStatus.Hidden)
            userPassDatView.setData(text: (mngDat?.metaData.userPassword)!, checkSts: CheckBoxStatus.Hidden)
            allowsPrintView.setData(radioStatus: (mngDat?.metaData.allowsPrinting)!, checkSts: CheckBoxStatus.Hidden)
            allowsCopyView.setData(radioStatus: (mngDat?.metaData.allowsCopying)!, checkSts: CheckBoxStatus.Hidden)
        }
        else {
            var t1: String? = nil
            var t2: String? = nil
            var t3: String? = nil
            var t4: String? = nil
            var t5: String? = nil
            var t6: String? = nil
            var t7: RadioBtnStatus = RadioBtnStatus.NonSelect
            var t8: RadioBtnStatus = RadioBtnStatus.NonSelect
            for enume in mngDatas.enumerated() {
                if enume.offset == 0 {
                    t1 = enume.element.metaData.fileName
                    t2 = enume.element.metaData.author
                    t3 = enume.element.metaData.creator
                    t4 = enume.element.metaData.title
                    t5 = enume.element.metaData.ownerPassword
                    t6 = enume.element.metaData.userPassword
                    t7 = enume.element.metaData.allowsPrinting
                    t8 = enume.element.metaData.allowsCopying
                }
                else {
                    if t1 !=  enume.element.metaData.fileName {
                        t1 = nil
                    }
                    if t2 !=  enume.element.metaData.author {
                        t2 = nil
                    }
                    if t3 !=  enume.element.metaData.creator {
                        t3 = nil
                    }
                    if t4 !=  enume.element.metaData.title {
                        t4 = nil
                    }
                    if t5 !=  enume.element.metaData.ownerPassword {
                        t5 = nil
                    }
                    if t6 !=  enume.element.metaData.userPassword {
                        t6 = nil
                    }
                    if t7 != enume.element.metaData.allowsPrinting {
                        t7 = RadioBtnStatus.NonSelect
                    }
                    if t8 != enume.element.metaData.allowsCopying {
                        t8 = RadioBtnStatus.NonSelect
                    }
                }
            }
            
            fileNameDatView.setData(text: t1 == nil ? String() : t1!, checkSts: CheckBoxStatus.NoSelected)
            titleDatView.setData(text: t4 == nil ? String() : t4!, checkSts: CheckBoxStatus.NoSelected)
            authorDatView.setData(text: t2 == nil ? String() : t2!, checkSts: CheckBoxStatus.NoSelected)
            creatorDatView.setData(text: t3 == nil ? String() : t3!, checkSts: CheckBoxStatus.NoSelected)
            ownerPassDatView.setData(text: t5 == nil ? String() : t5!, checkSts: CheckBoxStatus.NoSelected)
            userPassDatView.setData(text: t6 == nil ? String() : t6!, checkSts: CheckBoxStatus.NoSelected)
            allowsPrintView.setData(radioStatus: t7, checkSts: CheckBoxStatus.NoSelected)
            allowsCopyView.setData(radioStatus: t8, checkSts: CheckBoxStatus.NoSelected)
        }
    }
    
    // MARK: MetaDataTextSubViewDelegate
    func didEditText(text: String, identifer: String?, chkBoxSts: CheckBoxStatus) {
        dataViewDelegate?.didEditText(text: text, identifer: identifer, chkBoxSts: chkBoxSts)
    }
    
    // MARK: MetaDataSelectSubViewDelegate
    func didEditRadioButton(radioBtnSts: RadioBtnStatus, identifer: String?, chkBoxSts: CheckBoxStatus) {
        dataViewDelegate?.didEditRadioButton(radioBtnSts: radioBtnSts, identifer: identifer, chkBoxSts: chkBoxSts)
    }
}
