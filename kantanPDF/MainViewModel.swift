//
//  MainViewModel.swift
//  kantanPDF
//
//  Created by 田中智子 on 2016/12/07.
//  Copyright © 2016年 田中智子. All rights reserved.
//

import Cocoa

class MainViewModel: NSObject {
    
    /*
     * ドロップイベントからPDF作成
     * @param ドラッグ情報
     */
    func dropActionPdf(sender: NSDraggingInfo) -> Void {
        // ディレクトリパスリスト
        let dirPathList = getAllDirPathList(sender: sender)
        // ディレクトリごとにPDF作成
        for dirPath in dirPathList {
            let title = (dirPath as NSString).lastPathComponent as String
            createPDFFile(direPath: dirPath, pdfTitle: title)
        }
    }

    /*
     * ドラッグ情報からディレクトリパスを全て取得する。
     * @param ドラッグ情報
     * @return ディレクトリパスリスト
     */
    func getAllDirPathList(sender: NSDraggingInfo) -> [String] {
        let dragPathList :[String] = sender.draggingPasteboard().propertyList(forType: NSFilenamesPboardType) as! [String]
        let fileMg = FileManager.default
        
        var rsltPathlist = [String]()
        
        for dragPath in dragPathList {
            var isDir: ObjCBool = ObjCBool(false)
            fileMg.fileExists(atPath: dragPath, isDirectory: &isDir)
            if isDir.boolValue {
                rsltPathlist.append(dragPath)
            }
            
            let cntntList = fileMg.subpaths(atPath: dragPath)
            for cntnt in cntntList! {
                let cntntFullPath = (dragPath as NSString).appendingPathComponent(cntnt)
                isDir = ObjCBool(false)
                fileMg.fileExists(atPath: cntntFullPath, isDirectory: &isDir)
                if isDir.boolValue {
                    rsltPathlist.append(cntntFullPath)
                }
            }
        }
        return rsltPathlist
    }
    
    /*
     * ディレクトリ単位でPDFファイルを作成
     * @param PDFにするディレクトリ, PDFメタデータ内のタイトル
     */
    func createPDFFile(direPath: String, pdfTitle: String) {
        // ファイル一覧を取得
        let fileMg = FileManager.default
        var contentList = [String]()
        do {
            contentList = try fileMg.contentsOfDirectory(atPath: direPath)
        } catch {
            // エラーの場合
            print("contentsOfDirectory Error")
        }
    
        // ソート済みファイル一覧
        contentList.sort(){$0<$1}
        // 書き出し先
        let outptPath = direPath + ".pdf"
        
        // ファイル情報
        let fileInf = [kCGPDFContextTitle as String: pdfTitle]
        
        // コンテキスト作成
        var mediaBox:CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        let pdfContext = CGContext.init(NSURL.init(fileURLWithPath: outptPath), mediaBox: &mediaBox, fileInf as CFDictionary?)
        
        for content in contentList {
            let img = NSImage.init(contentsOfFile: (direPath as NSString).appendingPathComponent(content))
            if img == nil {
                // 変換できないものは処理しない
                continue
            }
            // イメージサイズ
            var rect = CGRect.init(x: 0, y: 0, width: (img?.size.width)!, height: (img?.size.height)!)
            // PDFページ書き込み
            pdfContext?.beginPage(mediaBox: &rect)
            pdfContext?.draw((img?.cgImage(forProposedRect: nil, context: nil, hints: nil))!, in: rect)
            pdfContext?.endPage()
        }
    }
    
}
