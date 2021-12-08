//
//  RequestManager.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/4/21.
//

import Foundation

/*
 This is app network layer that I wrote for my apps, it is super light and no need for adding alamofire to app :)
 */

typealias CodableResponse<T: Codable> = (Result<T, RequestError>) -> Void

final class RequestManager: NSObject, URLSessionDelegate {
    
    var baseApi: String = Bundle.main.info(for: InfoPlistKey.baseAPIURL)!
    
    var session: URLSession!
    
    var responseValidator: ResponseValidatorProtocol
    
    var reponseLog: URLRequestLoggableProtocol?
    
    var fileManager: FileManagable!
    
    var cacheManager: CacheManagable!
    
    typealias Headers = [String: String]
    
    private override init() {
        self.reponseLog = KiliaroResponseLog()
        self.responseValidator = KiliaroResponseValidator()
        self.fileManager = FilesManager.standard
        self.cacheManager = CacheManager.standard
        super.init()
        self.session = URLSession(configuration: cacheManager.cacheConfig(), delegate: self, delegateQueue: OperationQueue.main)
    }
    
    public init(session: URLSession, validator: ResponseValidatorProtocol) {
        self.session = session
        self.responseValidator = validator
    }
    
    static let shared = RequestManager()
    
}

extension RequestManager: RequestManagerProtocol {
    
    var timeOutInterval: Double {
        return 40
    }
    
    func performRequestWith<T: Codable>(url: String, httpMethod: HTTPMethod, completionHandler: @escaping CodableResponse<T>) {
        
        let headers = headerBuilder()
        
        let urlRequest = urlRequestBuilder(url: url, header: headers, httpMethod: httpMethod)
        
        performURLRequest(urlRequest, completionHandler: completionHandler)
    }
    
    func downloadfile(url: String, completion: @escaping (Bool, URL?) -> Void) {
        switch fileManager.exist(file: url) {
        case .exist(let url):
            debugPrint("The file already exists at path")
            completion(true, url)
        case .notExist:
            downloadFileFromAndSave(url: url, completion: completion)
        }
        
    }
    
    private func headerBuilder() -> Headers {
        let headers = [
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    private func urlRequestBuilder(url: String, header: Headers, httpMethod: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: baseApi + url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeOutInterval)
        urlRequest.allHTTPHeaderFields = header
        
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    private func performURLRequest<T: Codable>(_ request: URLRequest, completionHandler: @escaping CodableResponse<T>) {
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            self.reponseLog?.logResponse(response as? HTTPURLResponse, data: data, error: error, HTTPMethod: request.httpMethod)
            if error != nil {
                guard let cachedResponse = self.cacheManager.cachedResponse(for: request) else {
                    return completionHandler(.failure(RequestError.connectionError))
                }
                
                if let cachedResp = cachedResponse.data as? T {
                    let validationResult: (Result<T, RequestError>) = self.responseValidator.validation(response: cachedResp as? HTTPURLResponse, data: data)
                    return completionHandler(validationResult)
                } else {
                    return completionHandler(Result.failure(.notFound))
                }
            } else {
                let validationResult: (Result<T, RequestError>) = self.responseValidator.validation(response: response as? HTTPURLResponse, data: data)
                return completionHandler(validationResult)
            }
        }.resume()
    }
    
    private func downloadFileFromAndSave(url: String, completion: @escaping (Bool, URL?) -> Void) {
        let itemUrl = URL(string: url)
        // you can use NSURLSession.sharedSession to download the data asynchronously
        session.downloadTask(with: itemUrl!, completionHandler: { [weak self] (location, response, error) -> Void in
            guard let self = self else { return }
            guard let tempLocation = location, error == nil else { return }
            self.reponseLog?.logResponse(response as? HTTPURLResponse, data: try? Data(contentsOf: tempLocation), error: error, HTTPMethod: .none)
            switch self.fileManager.saveFile(url: url, tempLoc: tempLocation) {
            case .success(let url):
                completion(true, url)
            case .failure:
                completion(false, nil)
            }
        }).resume()
    }
    
}
