//
//  PdfCreateManager.swift
//  kantanPDF
//
//  Created by 田中智子 on 2017/02/01.
//  Copyright © 2017年 田中智子. All rights reserved.
//

import Cocoa

protocol PDFCreateManagerDelegate: class{
    func changDataState(mngData: PDFMetaData)
}

/// 実行ステータス
///
/// - Unexecuted: 未実行
/// - Executing: 実行中
/// - Executed: 正常終了
/// - Cancel: キャンセル
/// - Error: エラー
enum ExeState {
    case Unexecuted
    case Executing
    case Executed
    case Cancel
    case Error(String)
}

struct PdfMngData {
    var metaData: PDFMetaData
    var exeState: ExeState = ExeState.Unexecuted
    init() {
        metaData = PDFMetaData()
    }
}

class PdfCreateManager: NSObject {
    let parallels = 4
    weak var delegate: PDFCreateManagerDelegate?
    
    private var isCancel = false
    var cnvertList:Array<Array<PdfMngData>>?
    
    
    /// PDF変換スタート
    ///
    /// - Parameter cnverts: 変換対象リスト
    func startPdfConvert(cnverts: [PdfMngData]) {
        isCancel = false
        cnvertList = parallelCnvtList(cnverts: cnverts)
        
        let creator = PdfCreator()

        let queue = DispatchQueue.global(qos: .default)
        for inList in cnvertList! {
            let queGroup = DispatchGroup()
            for var mngData in inList {
                queue.async(group: queGroup) {
                    print("start " + mngData.metaData.title)
                    do {
                        mngData.exeState = ExeState.Executing
                        DispatchQueue.main.async {
                            
                            
                        }
                        if self.isCancel {
                            creator.cancel()
                        }
                        try creator.createPDFFile(metaData: mngData.metaData)
                    }
                    catch PDFError.NoDirectory {
                        mngData.exeState = ExeState.Error("NoDirectory")
                    }
                    catch PDFError.DirEmpty {
                        mngData.exeState = ExeState.Error("DirEmpty")
                    }
                    catch PDFError.Cancel {
                        mngData.exeState = ExeState.Error("Cancel")
                    }
                    catch PDFError.EtcError(let msg) {
                        mngData.exeState = ExeState.Error(msg)
                    }
                    catch {
                        mngData.exeState = ExeState.Error("その他のエラー")
                    }
                    
                    DispatchQueue.main.async {
                        
                    }
                }
            }
            queGroup.wait()
        }
    }

    func parallelCnvtList(cnverts: [PdfMngData]) -> Array<Array<PdfMngData>> {
        var rslt = Array<Array<PdfMngData>>()
        
        for tuple in cnverts.enumerated() {
            if tuple.offset%self.parallels == 0 {
                print("new parallels")
                rslt.append(Array<PdfMngData>())
            }
            print("title "+tuple.element.metaData.title)
            rslt[rslt.count-1].append(tuple.element)
        }
        return rslt
    }
    
    func cancel() {
        isCancel = true
    }

}
