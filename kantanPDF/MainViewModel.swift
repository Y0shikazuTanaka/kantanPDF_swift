//
//  MainViewModel.swift
//  kantanPDF
//
//  Created by 田中智子 on 2016/12/07.
//  Copyright © 2016年 田中智子. All rights reserved.
//

import Cocoa

let exclueExtentions = [""]
let exclueFilenames = [".DS_Store"]

class MainViewModel: NSObject, PDFCreateManagerDelegate {
    var cnvertList:[PdfMngData] = []
    var selectMngDat:[PdfMngData] = []
    let pdfCreateMg = PdfCreateManager()

    /// イニシャライズ
    override init() {
        super.init()
        pdfCreateMg.delegate = self
    }
    
    /// ドロップイベントからPDF作成
    ///
    /// - Parameter sender: ドラッグ情報
    func dropActionPdf(sender: NSDraggingInfo) {
        // ディレクトリパスリスト
        let dirPathList = getAllDirPathList(sender: sender)
        // ディレクトリごとにPDF作成
        
        for dirPath in dirPathList {
            let fileName = (dirPath as NSString).lastPathComponent as String
            var mngDat = PdfMngData()
            mngDat.metaData.direPath = dirPath
            mngDat.metaData.title = fileName
            mngDat.metaData.fileName = fileName
            cnvertList.append(mngDat)
        }
    }
    
    /// ドラッグ情報からディレクトリパスを全て取得する。
    ///
    /// - Parameter sender: ドラッグ情報
    /// - Returns: ディレクトリパスリスト
    func getAllDirPathList(sender: NSDraggingInfo) -> [String] {
        let dragPathList :[String] = sender.draggingPasteboard().propertyList(forType: NSFilenamesPboardType) as! [String]
        var rsltPathlist = [String]()
        for dragPath in dragPathList {
            if checkDirInFiles(dirPath: dragPath) {
                rsltPathlist.append(dragPath)
            }
            rsltPathlist += nestDirList(dirPath: dragPath)
        }
        return rsltPathlist
    }
    
    /// ネストディレクトリを全て取得する
    ///
    /// - Parameter dirPath: dirPath
    /// - Returns: dirPath List
    func nestDirList(dirPath: String) -> [String] {
        var rsltPaths = [String]()
        let content = try! FileManager.default.contentsOfDirectory(atPath: dirPath)
        let dirs = content.filter({dir in
            let filePath = (dirPath as NSString).appendingPathComponent(dir)
            var isDirectory: ObjCBool = false
            FileManager.default.fileExists(atPath: filePath, isDirectory:&isDirectory)
            return isDirectory.boolValue
        })
        for dir in dirs {
            let tmpPath = (dirPath as NSString).appendingPathComponent(dir)
            if checkDirInFiles(dirPath: tmpPath) {
                rsltPaths.append(tmpPath)
            }
            rsltPaths += nestDirList(dirPath: tmpPath)
        }
        return rsltPaths
    }
    
    
    /// ディレクトリを除くファイルが存在するかチェックする
    ///
    /// - Parameter dirPath: パス
    /// - Returns: boole
    func checkDirInFiles(dirPath: String) -> Bool {
        let fileMg = FileManager.default
        let paths = try! fileMg.contentsOfDirectory(atPath: dirPath)
        for path in paths {
            if exclueFilenames.index(of: path) != nil {
                continue
            }
            var isDir: ObjCBool = ObjCBool(false)
            fileMg.fileExists(atPath: (dirPath as NSString).appendingPathComponent(path), isDirectory: &isDir)
            if !isDir.boolValue {
                let extention = (path as NSString).pathExtension as String
                if exclueExtentions.index(of: extention) == nil {
                    return true
                }
            }
        }
        return false
    }
    
    
    /// メタデータ編集時に呼び出し
    ///
    /// - Parameters:
    ///   - text: テキスト
    ///   - identifer: 各Subviewの識別子
    ///   - chkBoxSts: チェックボックスの状態
    func editText(text: String, identifer: String?, chkBoxSts: CheckBoxStatus) -> [Int] {
        var reLoadIndex: [Int] = []
        if chkBoxSts == .NoSelected {
            return reLoadIndex
        }
        for var slctMngDat in selectMngDat.enumerated() {
            for mngDat in cnvertList.enumerated() {
                if slctMngDat.element.metaData.direPath == mngDat.element.metaData.direPath {
                    if identifer == SubViewTag.FileName.rawValue {
                        slctMngDat.element.metaData.fileName = text
                    }
                    else if identifer == SubViewTag.Title.rawValue {
                        slctMngDat.element.metaData.title = text
                    }
                    else if identifer == SubViewTag.Auther.rawValue {
                        slctMngDat.element.metaData.author = text
                    }
                    else if identifer == SubViewTag.Creator.rawValue {
                        slctMngDat.element.metaData.creator = text
                    }
                    else if identifer == SubViewTag.OwnerPass.rawValue {
                        slctMngDat.element.metaData.ownerPassword = text
                    }
                    else if identifer == SubViewTag.UserPass.rawValue {
                        slctMngDat.element.metaData.userPassword = text
                    }
                    selectMngDat[slctMngDat.offset] = slctMngDat.element
                    cnvertList[mngDat.offset] = slctMngDat.element
                    reLoadIndex.append(mngDat.offset)
                }
            }
        }
        return reLoadIndex
    }
    
    /// メタデータ編集時に呼び出し
    ///
    /// - Parameters:
    ///   - radioBtnSts: ラジオボタン状態
    ///   - identifer: 各Subviewの識別子
    ///   - chkBoxSts: チェックボックスの状態
    func editRadioButton(radioBtnSts: RadioBtnStatus, identifer: String?, chkBoxSts: CheckBoxStatus) -> [Int] {
        var reLoadIndex: [Int] = []
        if chkBoxSts == .NoSelected {
            return reLoadIndex
        }
        for var slctMngDat in selectMngDat.enumerated() {
            for mngDat in cnvertList.enumerated() {
                if slctMngDat.element.metaData.direPath == mngDat.element.metaData.direPath {
                    if identifer == SubViewTag.Print.rawValue {
                        slctMngDat.element.metaData.allowsPrinting = radioBtnSts
                    }
                    else if identifer == SubViewTag.Copy.rawValue {
                        slctMngDat.element.metaData.allowsCopying = radioBtnSts
                    }
                    selectMngDat[slctMngDat.offset] = slctMngDat.element
                    cnvertList[mngDat.offset] = slctMngDat.element
                    reLoadIndex.append(mngDat.offset)
                }
            }
        }
        return reLoadIndex
    }

    
    /// 変換スタートアクション
    func startAction() {
        pdfCreateMg.startPdfConvert(cnverts: cnvertList)
    }
    
    /// 変換キャンセル
    func cancelAction() {
        pdfCreateMg.cancel()
    }
    
    // MARK: PDFCreateManagerDelegate
    
    /// PDFCreateManagerDelegate
    ///
    /// - Parameter mngData: PDFメタデータ
    func changDataState(mngData: PDFMetaData) {
        
    }
}
