//
//  HomeService.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/6/21.
//

import Foundation

/*

 This is Home Service, responsible for making api calls of getting images.
 
 */

typealias ImagesCompletionHandler = (Result<HomeImagesModel, RequestError>) -> Void
typealias ImageDownloadCompletionHandler = DownloadFileCompletionHandler

protocol HomeServiceProtocol {
    func getImages(completionHandler: @escaping ImagesCompletionHandler)
    func downloadImage(url: String, completionHandler: @escaping ImageDownloadCompletionHandler)
}

/*
 HomeEndPoints is URLPath of home images Api calls
 */

private enum HomeEndPoints {
    case media(String)
    
    var path: String {
        switch self {
        case .media(let id):
            return "shared/\(id)/media"
        }
    }
}

class HomeService: HomeServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: HomeServiceProtocol = HomeService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getImages(completionHandler: @escaping ImagesCompletionHandler) {
        let sharedKey = UserDefaultsConfig.sharedKey
        self.requestManager.performRequestWith(url: HomeEndPoints.media(sharedKey).path, httpMethod: .get) { (result: Result<HomeImagesModel, RequestError>) in
            // Taking Data to main thread so we can update UI.
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
    func downloadImage(url: String, completionHandler: @escaping ImageDownloadCompletionHandler) {
        self.requestManager.downloadfile(url: url) { success, fileLocation in
            DispatchQueue.main.async {
                completionHandler(success, fileLocation)
            }
        }
    }
}
