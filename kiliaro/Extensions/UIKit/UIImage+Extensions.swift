//
//  UIImage+Extensions.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/6/21.
//

import UIKit

// MARK: - Load from URL
extension UIImageView {
    
    func load(url: URL, placeholder: UIImage? = nil, cache: URLCache? = nil) {
        defer { self.removeActivityIndicator() }
        self.animateActivityIndicator()
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
