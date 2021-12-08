//
//  FilesManager.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/8/21.
//

import Foundation

final class FilesManager {
    
    // MARK: - singleton
    static let standard = FilesManager(fileManager: FileManager.default)
    
    // MARK: - Initializer
    var fileManager: FileManager
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    // MARK: - Properties
    private lazy var documentsDirectoryURL: URL =  {
        // lets create your document folder url
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    // MARK: - Private Funcs
    private func getDestinationUrl(for url: String) -> URL {
        let itemUrl = URL(string: url)
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("\(String(describing: itemUrl?.lastPathComponent)).jpg")
        print(destinationUrl)
        return destinationUrl
    }
    
    // MARK: - Public Funcs
    func exist(file url: String) -> FileReturnType {
        let destinationUrl = getDestinationUrl(for: url)
        // to check if it exists before downloading it
        if fileManager.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            return .exist(destinationUrl)
        }
        
        return .notExist
    }
    
    
    func saveFile(url: String ,tempLoc: URL) -> Result<URL, Error> {
        let destinationUrl = getDestinationUrl(for: url)
        do {
            // after downloading your file you need to move it to your destination url
            try fileManager.moveItem(at: tempLoc, to: destinationUrl)
            print("File moved to documents folder")
            return .success(destinationUrl)
        } catch let error as NSError {
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    
    func removeFile(url: URL, completion: @escaping DataCompletion<Bool>) {
        do {
            try fileManager.removeItem(at: url)
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    func removeAllFiles() {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectoryURL,
                                                               includingPropertiesForKeys: nil,
                                                               options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        print("🗑🚮 FileManager saved data Deleted 🚮🗑")
        } catch {
            print(error)
            print("⚠️ FileManager NOT Deleted: \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Conform to FileManagable
extension FilesManager: FileManagable { }
