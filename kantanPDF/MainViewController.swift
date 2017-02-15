//
//  ViewController.swift
//  kantanPDF
//
//  Created by 田中智子 on 2016/12/07.
//  Copyright © 2016年 田中智子. All rights reserved.
//

import Cocoa

enum ButtonLbl: String {
    case Start
    case Cancel
}
enum OutlineViewIdentifer: String {
    case FolderName
    case FileName
    case Path
}

class MainViewController: NSViewController,
FileOutlineViewDelegate, NSOutlineViewDataSource, MainViewModelDelegate, DropContentViewDelegate, MetaDataSubViewDelegate {

    @IBOutlet weak var metaDataView: MetaDataSubView!
    @IBOutlet weak var fileListOutlineView: FileOutlineView!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var startCancelBtn: NSButton!
    
    let model = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! DropContentView
        view.delegate = self
        model.delegate = self
        metaDataView.dataViewDelegate = self
    }
    
    /// StartCancelボタンイベント
    ///
    /// - Parameter sender: NSButtonインスタンス
    @IBAction func startCancelAction(_ sender: NSButton) {
        switch sender.title {
        case ButtonLbl.Start.rawValue:
            progressBar.doubleValue = 0
            sender.title = ButtonLbl.Cancel.rawValue
            model.startAction()
        default:
            sender.title = ButtonLbl.Start.rawValue
            model.cancelAction()
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    /// MARK: MetaDataSubViewDelegate
    /// メタデータ編集後に呼ばれる
    func didEditText(text: String, identifer: String?, chkBoxSts: CheckBoxStatus) {
        let reLoadIndexs = model.editText(text: text, identifer: identifer, chkBoxSts: chkBoxSts)
        metaDataView.setMngDats(mngDatas: model.selectMngDat)
        for index in reLoadIndexs {
            fileListOutlineView.reloadItem(index)
        }
    }
    
    func didEditRadioButton(radioBtnSts: RadioBtnStatus, identifer: String?, chkBoxSts: CheckBoxStatus) {
        let reLoadIndexs = model.editRadioButton(radioBtnSts: radioBtnSts, identifer: identifer, chkBoxSts: chkBoxSts)
        metaDataView.setMngDats(mngDatas: model.selectMngDat)
        for index in reLoadIndexs {
            fileListOutlineView.reloadItem(index)
        }
    }

    
    /// MARK: DropContentViewDelegate
    /// フォルダのドロップを通知
    ///
    /// - Parameter sender: ドロップ通知
    func performDragOperation(sender: NSDraggingInfo) {
        model.dropActionPdf(sender: sender)
        fileListOutlineView.reloadData()
    }
    
    /// MARK: MainViewModelDelegate
    func pdfMngChangDataState(mngData: PdfMngData, exePercent: Int) {
        switch mngData.exeState {
        case .Unexecuted:
            print("Unexecuted")
        case .Executing:
            print("Executing")
        case .Executed:
            print("Executed")
            progressBar.doubleValue = Double(exePercent)
        case .Cancel:
            print("Cancel")
        default:
            print("Error")
        }
    }
    
    func pdfConvertEnd() {
        startCancelBtn.title = ButtonLbl.Start.rawValue
    }


    /// MARK: NSOutlineViewDataSource
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return model.cnvertList.count
    }
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    /// MARK: FileOutlineViewDelegate
    func deleteKyeDown() {
        print("deleteKeyDown")
        model.deleteEvent()
        fileListOutlineView.reloadData()
    }

    func selectionShouldChange(in outlineView: NSOutlineView) -> Bool {
        print("func selectionShouldChange(in outlineView: NSOutlineView) -> Bool")
        model.selectMngDat.removeAll()
        metaDataView.allItemDesable()
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        let index = item as! Int
        model.selectMngDat.append(model.cnvertList[index])
        print("func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool")
        return true
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        print("func outlineViewSelectionDidChange(_ notification: Notification)")
        if model.selectMngDat.count != 0 {
            metaDataView.initViewItem()
            metaDataView.setMngDats(mngDatas: model.selectMngDat)
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return index
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let index = item as! Int
        let view = outlineView.make(withIdentifier: "cell", owner: self) as? NSTableCellView

        if tableColumn?.identifier == OutlineViewIdentifer.FolderName.rawValue {
            view?.textField?.stringValue = model.cnvertList[index].metaData.fileName
        }
        else if tableColumn?.identifier == OutlineViewIdentifer.FileName.rawValue {
            view?.textField?.stringValue = model.cnvertList[index].metaData.title
        }
        else if tableColumn?.identifier == OutlineViewIdentifer.Path.rawValue {
            view?.textField?.stringValue = model.cnvertList[index].metaData.direPath
        }
        else {
            print("その他Cell")
        }
        
        return view
    }


    


}

