//
//  FileManagableProtocol.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/8/21.
//

import Foundation

protocol FileManagable {
    var fileManager: FileManager { get set }
    func exist(file url: String) -> FileReturnType
    func saveFile(url: String ,tempLoc: URL) -> Result<URL, Error>
    func removeFile(url: URL, completion: @escaping DataCompletion<Bool>)
    func removeAllFiles()
}

enum FileReturnType {
    case exist(URL)
    case notExist
}
