//
//  PreviewItemModel.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/8/21.
//

import QuickLook

class PreviewItemModel: NSObject, QLPreviewItem {
    let displayName: String
    let fileName: String
    let fileExtension: String?
    let url: URL

    init(displayName: String, fileName: String, url: URL, fileExtension: String? = nil) {
        self.displayName = displayName
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.url = url

        super.init()
    }

    var previewItemTitle: String? {
        return displayName
    }

    var previewItemURL: URL? {
        return url
    }
}
