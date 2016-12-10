//
//  ViewController.swift
//  kantanPDF
//
//  Created by 田中智子 on 2016/12/07.
//  Copyright © 2016年 田中智子. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, DropContentViewDelegate {
    
    @IBOutlet weak var dropView: DropContentView!
    let model = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        dropView.delegate = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: DropContentViewDelegate
    func performDragOperation(sender: NSDraggingInfo) {
        model.dropActionPdf(sender: sender)
    }


}

