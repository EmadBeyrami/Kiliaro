//
//  RequestManagerProtocol.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/4/21.
//

import Foundation

typealias DownloadFileCompletionHandler = (_ success: Bool,_ fileLocation: URL?) -> Void

protocol RequestManagerProtocol {
    /// Provided URL Session
    var session: URLSession! { get set }
    
    /// Timeout interval is interval for a request to be timedOut
    var timeOutInterval: Double { get }
    
    var baseApi: String { get set }
    
    var responseValidator: ResponseValidatorProtocol { get set }
    
    var reponseLog: URLRequestLoggableProtocol? { get set }
    
    var fileManager: FileManagable! { get set }
    
    var cacheManager: CacheManagable! { get set }
    /**
    To make 'get' request to url.
    
    - Parameter url: url of interest to retrieve data. It should be String
    - Parameter httpMethod: http method with associated value
    
    - Returns: completionHandler, which is Swift 5 Result Type ,  on Success returns the type which is codable . On failure returns RequestError based on your server RequestError.
    */
    func performRequestWith<T: Codable>(url: String, httpMethod: HTTPMethod, completionHandler: @escaping CodableResponse<T>)
    
    /**
    To  download File from URL
    
    - Parameter url: url of interest to retrieve data. It should be String
    
    - Returns: completionHandler, which is  Success returns a Bool and saved FileLocation
    */
    func downloadfile(url: String, completion: @escaping DownloadFileCompletionHandler)
    
}
