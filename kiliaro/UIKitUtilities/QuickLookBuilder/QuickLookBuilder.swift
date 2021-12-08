//
//  QuickLookBuilder.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/8/21.
//

import QuickLook

class QuickLookBuilder: QLPreviewController {
    
    private var item: QLPreviewItem!
    
    func initializeWith(item: QLPreviewItem, dataSource: QLPreviewControllerDataSource? = nil) {
        self.dataSource = dataSource ?? self
        self.item = item
    }
    
    deinit {
        debugPrint("deinitialized \(String(describing: self))")
    }
}

extension QuickLookBuilder: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.item
    }
}
