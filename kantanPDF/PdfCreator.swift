//
//  PdfCreator.swift
//  kantanPDF
//
//  Created by 田中智子 on 2017/01/23.
//  Copyright © 2017年 田中智子. All rights reserved.
//

import Cocoa

let kExtensionPdf = ".pdf"

enum PDFError : Error {
    case NoDirectory
    case DirEmpty
    case Cancel
    case EtcError(String)
}

/// PDFメタデータ
struct PDFMetaData {
    var direPath: String = String()
    var fileName: String = String()
    var author: String = String()
    var creator: String = String()
    var title: String = String()
    var ownerPassword: String = String()
    var userPassword: String = String()
    var allowsPrinting: RadioBtnStatus = RadioBtnStatus.OkSelect
    var allowsCopying: RadioBtnStatus = RadioBtnStatus.OkSelect
}

class PdfCreator: NSObject {
    
    private var isCancel: Bool = false
    
    /// PDF作成
    ///
    /// - Parameter metaData: PDFメタデータ構造体
    /// - Throws: PDFError
    func createPDFFile(metaData: PDFMetaData!) throws {
        if isCancel {
            throw PDFError.Cancel
        }

        // ファイル一覧を取得
        let fileMg = FileManager.default
        var contentList = [String]()
        do {
            contentList = try fileMg.contentsOfDirectory(atPath: metaData.direPath)
            if contentList.count == 0 {
                throw PDFError.DirEmpty
            }
        } catch {
            throw PDFError.EtcError("contentsOfDirectory Error")
        }
        
        // ソート済みファイル一覧
        contentList.sort(){$0<$1}
        // 書き出し先
        let outptPath = ((metaData.direPath as NSString).deletingLastPathComponent as NSString).appendingPathComponent(metaData.fileName) + kExtensionPdf
        
        // ファイル情報
        let fileInf = createPdfMetaData(metaData: metaData)

        // コンテキスト作成
        var mediaBox:CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        let pdfContext = CGContext.init(NSURL.init(fileURLWithPath: outptPath), mediaBox: &mediaBox, fileInf)
        
        for content in contentList {
            if isCancel {
                throw PDFError.Cancel
            }
            
            let img = NSImage.init(contentsOfFile: (metaData.direPath as NSString).appendingPathComponent(content))
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
    
    
    /// cancelフラグを立てる
    func cancel() {
        isCancel = true
    }
    
    /// PDFメタデータ作成
    ///
    /// - Parameter metaData: PDFメタデータ構造体
    /// - Throws: PDFError
    /// - Returns: PDFメタデータ
    private func createPdfMetaData(metaData: PDFMetaData!) -> CFDictionary {
        
        var pdfMeta = Dictionary<String, Any>()
        
        if !metaData.author.isEmpty {
            pdfMeta[kCGPDFContextAuthor as String] = metaData.author
        }
        if !metaData.creator.isEmpty {
            pdfMeta[kCGPDFContextCreator as String] = metaData.creator
        }
        if !metaData.title.isEmpty {
            pdfMeta[kCGPDFContextTitle as String] = metaData.title
        }
        if !metaData.ownerPassword.isEmpty {
            pdfMeta[kCGPDFContextOwnerPassword as String] = metaData.ownerPassword
        }
        if !metaData.userPassword.isEmpty {
            pdfMeta[kCGPDFContextUserPassword as String] = metaData.userPassword
        }
        pdfMeta[kCGPDFContextAllowsPrinting as String] = metaData.allowsPrinting == RadioBtnStatus.OkSelect ? kCFBooleanTrue : kCFBooleanFalse
        pdfMeta[kCGPDFContextAllowsCopying as String] = metaData.allowsCopying == RadioBtnStatus.OkSelect ? kCFBooleanTrue : kCFBooleanFalse
        
        return pdfMeta as CFDictionary
    }
}
